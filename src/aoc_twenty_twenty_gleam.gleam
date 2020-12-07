import gleam/io
import gleam/int
import gleam/string.{append}
import days/day1
import days/day2
import days/day3
import days/day4
import days/day5
import days/day6
import gleam/string
import gleam/bit_string
import gleam/dynamic

pub external type Charlist

pub external fn binary_to_list(String) -> Charlist = "erlang" "binary_to_list"
external fn list_to_binary(Charlist) -> String = "erlang" "list_to_binary"

pub fn run_day(day: String) -> Result(String, String) {
  case int.parse(day) {
    Ok(1) -> day1.run()
    Ok(2) -> day2.run()
    Ok(3) -> day3.run()
    Ok(4) -> day4.run()
    Ok(5) -> day5.run()
    Ok(6) -> day6.run()
    Error(_) -> Error(["The day supplied: \"", day, "\" is not an integer"] |> string.concat)
    _ -> Error("The supplied day is not supported")
  }
}

// These function and the usage should not be nessesary, they should b estarted automatically
// as they are listed in the app.src file?? 
external fn inet_start() -> Nil = "inets" "start"
external fn ssl_start() -> Nil = "ssl" "start"

pub fn main(arg) {
  inet_start()
  ssl_start()
  let result = case arg {
    [] -> Error("Please supply the day you wish to run as an argument")
    [day, ..] -> day |> list_to_binary |> run_day
  }

  case result {
    Ok(res) -> io.println("Result: " |> append(res))
    Error(error) -> io.println("ERROR: " |> append(error))
  }
}
