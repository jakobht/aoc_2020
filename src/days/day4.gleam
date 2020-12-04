import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int

type RegexOption {
  Capture
  All
  Binary
}

type MatchResult {
  Match(List(String))
  Nomatch
}

external fn re_run(
  String,
  String,
  List(tuple(RegexOption, RegexOption, RegexOption)),
) -> MatchResult =
  "re" "run"

pub fn run() {
  try in: String = input.get_input("2020", "4")
  let in =
    in
    |> string.trim()
    |> string.split("\n\n")

  let p1 =
    part1(in)
    |> int.to_string
  let p2 =
    part2(in)
    |> int.to_string
  Ok(
    ["Part1: ", p1, " Part2: ", p2]
    |> string.concat,
  )
}

const required_fields = ["byr:", "iyr:", "eyr:", "hgt:", "hcl:", "ecl:", "pid:"]

pub fn part1(input: List(String)) -> Int {
  input
  |> list.filter(fn(pp) {
    list.all(required_fields, fn(f) { string.contains(pp, f) })
  })
  |> list.length
}

pub fn get_prop(pass: String, prop: String) -> Result(String, Nil) {
  let pattern: String =
    [prop, ":([^ ]*)( |$)"]
    |> string.concat()
  let pass = string.replace(pass, "\n", " ")
  case re_run(pass, pattern, [tuple(Capture, All, Binary)]) {
    Match([_, x, _]) -> Ok(x)
    Nomatch -> Error(Nil)
  }
}

pub fn int_between(to_check, min: Int, max: Int) {
  case to_check
  |> result.then(int.parse) {
    Ok(x) -> x >= min && x <= max
    Error(_) -> False
  }
}

pub fn validate_byr(pass: String) {
  get_prop(pass, "byr")
  |> int_between(1920, 2002)
}

pub fn validate_iyr(pass: String) {
  get_prop(pass, "iyr")
  |> int_between(2010, 2020)
}

pub fn validate_eyr(pass: String) {
  get_prop(pass, "eyr")
  |> int_between(2020, 2030)
}

pub fn validate_hgt(pass: String) {
  case get_prop(pass, "hgt") {
    Ok(prop) -> {
      let pattern = "^(\\d*)(cm|in)$"
      case re_run(prop, pattern, [tuple(Capture, All, Binary)]) {
        Match([_, x, "cm"]) -> int_between(Ok(x), 150, 193)
        Match([_, x, "in"]) -> int_between(Ok(x), 59, 76)
        _ -> False
      }
    }
    Error(_) -> False
  }
}

pub fn validate_hcl(pass: String) {
  case get_prop(pass, "hcl") {
    Ok(prop) -> {
      let pattern = "^#([0-9]|[a-f]){6}$"
      case re_run(prop, pattern, [tuple(Capture, All, Binary)]) {
        Match(_) -> True
        Nomatch -> False
      }
    }
    Error(_) -> False
  }
}

pub fn validate_ecl(pass: String) {
  case get_prop(pass, "ecl") {
    Ok(prop) ->
      list.contains(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], prop)
    _ -> False
  }
}

pub fn validate_pid(pass: String) {
  case get_prop(pass, "pid") {
    Ok(prop) -> {
      let pattern = "^\\d{9}$"
      case re_run(prop, pattern, [tuple(Capture, All, Binary)]) {
        Match(_) -> True
        Nomatch -> False
      }
    }
    _ -> False
  }
}

pub fn part2(input: List(String)) -> Int {
  input
  |> list.filter(fn(pass) {
    validate_byr(pass) && validate_iyr(pass) && validate_eyr(pass) && validate_hgt(
      pass,
    ) && validate_hcl(pass) && validate_ecl(pass) && validate_pid(pass)
  })
  |> list.length
}
