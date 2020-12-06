import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int
import regex.{re_run, Capture, All, Binary, Match, Nomatch}

pub external type Charlist
pub external fn binary_to_list(String) -> Charlist = "erlang" "binary_to_list"

pub external fn list_to_integer(Charlist, Int) -> Int = "erlang" "list_to_integer"

pub fn run() {
  try in: String = input.get_input("2020", "5")
  let in = in |> string.trim() |> string.split("\n")

  let p1 = part1(in) |> int.to_string
  let p2 = part2(in) |> int.to_string
  Ok(string.concat(["Part1: ", p1, " Part2: ", p2]))
}

pub fn calc_seat(boarding_pass: String) -> Int {
  boarding_pass
  |> string.replace("B", "1")
  |> string.replace("F", "0")
  |> string.replace("R", "1")
  |> string.replace("L", "0")
  |> binary_to_list
  |> list_to_integer(2)
  // |> result.unwrap(-1)
}

pub fn part1(input: List(String)) -> Int {
  list.map(input, calc_seat)
  |> list.fold(0, int.max)
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
