import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int

type RegexOption { Capture All Binary }

type MatchResult {
  Match(List(String))
  Nomatch
}

external fn re_run(String, String,
  List(tuple(RegexOption, RegexOption, RegexOption))) -> MatchResult = "re" "run"

pub fn run() {
  try in: String = input.get_input("2020", "4")
  let in = in |> string.trim() |> string.split("\n\n")

  let p1 = part1(in) |> int.to_string
  let p2 = part2(in) |> int.to_string
  Ok(string.concat(["Part1: ", p1, " Part2: ", p2]))
}

const required_fields = ["byr:", "iyr:", "eyr:", "hgt:", "hcl:", "ecl:", "pid:"]

pub fn part1(input: List(String)) -> Int {
  list.filter(input, 
    fn(pp) { list.all(required_fields, fn(f) { string.contains(pp, f) }) }
  )
  |> list.length
}

pub fn test_prop(pass: String, prop: String, f) -> Bool {
  let pass = string.replace(pass, "\n", " ")
  let pattern = string.append(prop, ":([^ ]*)( |$)")
  case re_run(pass, pattern, [tuple(Capture, All, Binary)]) {
    Match([_, x, _]) -> f(x)
    Nomatch -> False
  }
}

pub fn int_between(to_check, min: Int, max: Int) {
  case int.parse(to_check) {
    Ok(x) -> x >= min && x <= max
    Error(_) -> False
  }
}

pub fn validate_byr(pass: String) {
  test_prop(pass, "byr", int_between(_, 1920, 2002))
}

pub fn validate_iyr(pass: String) {
  test_prop(pass, "iyr", int_between(_, 2010, 2020))
}

pub fn validate_eyr(pass: String) {
  test_prop(pass, "eyr", int_between(_, 2020, 2030))
}

pub fn validate_hgt(pass: String) {
  test_prop(pass, "hgt", fn(prop) {
      case re_run(prop, "^(\\d*)(cm|in)$", [tuple(Capture, All, Binary)]) {
        Match([_, x, "cm"]) -> int_between(x, 150, 193)
        Match([_, x, "in"]) -> int_between(x, 59, 76)
        _ -> False
      }
  })
}

pub fn validate_hcl(pass: String) {
  test_prop(pass, "hcl", fn(prop) {
      re_run(prop, "^#([0-9]|[a-f]){6}$", [tuple(Capture, All, Binary)]) != Nomatch
  })
}

pub fn validate_ecl(pass: String) {
  test_prop(pass, "ecl", list.contains(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], _))
}

pub fn validate_pid(pass: String) {
  test_prop(pass, "pid", fn(prop) {
      re_run(prop, "^\\d{9}$", [tuple(Capture, All, Binary)]) != Nomatch
  })
}

pub fn part2(input: List(String)) -> Int {
  list.filter(input, fn(pass) {
    validate_byr(pass) && validate_iyr(pass) && validate_eyr(pass) && validate_hgt(pass) &&
      validate_hcl(pass) && validate_ecl(pass) && validate_pid(pass)
  })
  |> list.length
}
