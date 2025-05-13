class Add {
  tool_name "add_2_numbers" @description("Use this tool to get the sum of two numbers only.")
  x float | "previous_output" @description("The first variable")
  y float @description("The second variable")
}

class Subtract {
  tool_name "subtract_two_numbers" @description("Use this tool to get the difference between two numbers only.")
  x float  | "previous_output" @description("The first variable")
  y float  @description("The second variable")
}

class Divide {
    tool_name "divide_two_numbers" @description("Use this tool to divide variable x by y.")
    x float | "previous_output" @description("The first variable")
    y float  @description("The second variable")
}

class Multiply {
    tool_name "multiple_two_numbers" @description("Use this tool to multiply variable x by y.")
    x float  | "previous_output" @description("The first variable")
    y float @description("The second variable")
}

class MISSING {
    tool_name "MISSING" @description("use this when can't do anything")
}

enum ToolChoose {
    ADD_TWO_NUMBERS @alias("add_2_numbers") @description(#"Tool to add 2 numbers"#)
    SUBTRACT_TWO_NUMBERS @alias("subtract_2_numbers") @description(#"Tool to add 2 numbers"#)
    DIVIDE_TWO_NUMBERS @alias("divide_2_numbers") @description(#"Tool to add 2 numbers"#)
    MULTIPLY_TWO_NUMBERS @alias("multiply_2_numbers") @description(#"Tool to add 2 numbers"#)
    MISSING @description(#"can't find a tool to use"#)
}


class SmallerProblems {
    problem_statement string
    tool_chosen Add | Subtract | Divide | Multiply | MISSING
}


function BreakProblemsAndFindTools(user_message: string) -> SmallerProblems[]{
  client CustomGPT4o
  prompt #"

    {{ _.role('system') }}
    Analyse the user message given, and break them into multiple small solvable steps in sequential order.
    if Can't find an appropriate tool to solve a small problem, assign it the value MISSING for tool_chose
    
    --------

    {{ ctx.output_format }}
    
    --------
    
    {{ _.role('user') }}
    {{ user_message }}
  "#
}

// class ToolCall {
//   tool_name ToolChoose
//   parameters Add | Subtract | Divide | Multiply | MISSING
// }

// function AssignToolsAndParameters(subproblems: SmallerProblems[]) -> (Add | Subtract | Divide | Multiply | MISSING)[]{
//   client CustomGPT4o
//   prompt #"

//     {{ _.role('system') }}
//     Analyse the smaller problems given and choose the right tool, and give the inputs right too.
    
//     --------

//     {{ ctx.output_format }}
    
//     --------
    
//     {{ _.role('user') }}
//     {{subproblems}}
//   "#
// }


    



test AddTool {
    functions [BreakProblemsAndFindTools]
    args {
        user_message #"
            Add 5 with 2.5 and 3.2 and divide it by 4. And say chotabheem
        "#
    }

}

///
// [
//   {
//     "problem_statement": "Add 5 with 2.5.",
//     "tool_chosen": "ADD_TWO_NUMBERS"
//   },
//   {
//     "problem_statement": "Add the result with 3.2.",
//     "tool_chosen": "ADD_TWO_NUMBERS"
//   },
//   {
//     "problem_statement": "Divide the result by 4.",
//     "tool_chosen": "DIVIDE_TWO_NUMBERS"
//   },
//   {
//     "problem_statement": "Say 'chotabheem'.",
//     "tool_chosen": "MISSING"
//   }
// ]
///