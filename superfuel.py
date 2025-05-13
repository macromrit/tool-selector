# External Imports
from langgraph.graph import START, END, StateGraph
from typing_extensions import TypedDict
from pydantic import BaseModel

# BAML Imports
from baml_client import b

# Tool Imports
from tools.tools import add, subtract, divide, multiply

# States
class InputState(TypedDict):
    user_message: str

class OverAllState(TypedDict):
    user_message: str
    output: list
    result: float | int
    type: str

class OutPutState(TypedDict):
    result: float | int

# Nodes
def ProblemDivider(inputState: InputState) -> OverAllState:
    output = inputState["user_message"]
    return {
        "output": b.BreakProblemsAndFindTools(
            user_message=output
        ),
        "type": str(type(output))
    }


toolsy = {
    "add_2_numbers": add,
    "subtract_two_numbers": subtract,
    "divide_two_numbers": divide,
    "multiple_two_numbers": multiply
}

def FunctionExecutor(inputState: OverAllState) -> OutPutState:
    states = inputState["output"]
    prev_value = 0
  
    for step in states:
        tool_chosen = step.tool_chosen.tool_name

        # if missing detected
        if tool_chosen == "MISSING": continue

        x, y = step.tool_chosen.x, step.tool_chosen.y

        if x == "previous_output":
            x = prev_value
        
        prev_value = toolsy[tool_chosen](x, y)

    return {"result": prev_value}
  


# Building State Graph
builder = StateGraph(OverAllState, input=InputState, output=OutPutState)
builder.add_node("DecodeProblem", ProblemDivider)
builder.add_node("ToolExecutor", FunctionExecutor)


builder.add_edge(START, "DecodeProblem")
builder.add_edge("DecodeProblem", "ToolExecutor")
builder.add_edge("ToolExecutor", END)
# builder.add_edge("DecodeProblem", END)

graph = builder.compile()

