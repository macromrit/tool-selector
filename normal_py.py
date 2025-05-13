from baml_client import b

# Tool Imports
from tools.tools import add, subtract, divide, multiply


toolsy = {
    "add_2_numbers": add,
    "subtract_two_numbers": subtract,
    "divide_two_numbers": divide,
    "multiple_two_numbers": multiply
}



def ProblemDivider(inputState):
    output = inputState
    return {
        "output": b.BreakProblemsAndFindTools(
            user_message=output
        ),
        "type": str(type(output))
    }

steps = ProblemDivider("Add two and three and divide by 2, say hi")
print("-----------")

prev_value = 0

for step in steps["output"]:

    tool_chosen = step.tool_chosen.tool_name
    
    # if missing detected
    if tool_chosen == "MISSING": continue

    x, y = step.tool_chosen.x, step.tool_chosen.y

    if x == "previous_output":
        x = prev_value
    
    prev_value = toolsy[tool_chosen](x, y)

    print(tool_chosen, x, y)

# print(prev_value)