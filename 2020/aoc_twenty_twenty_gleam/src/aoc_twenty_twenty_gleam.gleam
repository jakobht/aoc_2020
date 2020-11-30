import gleam/io
import gleam/int
import gleam/string.{append}
import days/day1
import gleam/string
import gleam/bit_string
import gleam/dynamic

pub external type Charlist

// external fn binary_to_list(String) -> Charlist =
//  "erlang" "binary_to_list"

external fn list_to_binary(Charlist) -> String =
  "erlang" "list_to_binary"

pub fn run_day(day : String) -> Result(String, String) {
  case int.parse(day) {
    Error(_) -> Error(["The day supplied: \"", day, "\" is not an integer"] |> string.concat)
    Ok(1) -> day1.run()
    other -> Error("The supplied day is not supported")
  }
}

pub fn main(arg) {
  let result = case arg {
    [] -> Error("Please supply the day you wish to run as an argument")
    [day, ..] -> day |> list_to_binary |> run_day
  }

  case result {
    Ok(res) -> io.println("Result: " |> append(res))
    Error(error) -> io.println("ERROR: " |> append(error))
  }
}
