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
  try in: String = input.get_input("2020", "2")
  let in =
    in
    |> string.trim()
    |> string.split("\n")

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

fn parse_line(line: String) -> tuple(Int, Int, String, String) {
  assert Match([_, low, high, to_count, pass]) =
    re_run(line, "(\\d*)-(\\d*) (.*): (.*)", [tuple(Capture, All, Binary)])
  assert Ok(low) = int.parse(low)
  assert Ok(high) = int.parse(high)
  tuple(low, high, to_count, pass)
}

fn check_pass(pass: tuple(Int, Int, String, String)) -> Bool {
  assert tuple(low, high, to_count, pass) = pass
  let count =
    pass
    |> string.to_graphemes
    |> list.filter(fn(x) { x == to_count })
    |> list.length
  count >= low && count <= high
}

pub fn part1(input: List(String)) -> Int {
  input
  |> list.map(parse_line)
  |> list.filter(check_pass)
  |> list.length
}

fn check_pass2(pass: tuple(Int, Int, String, String)) -> Bool {
  assert tuple(i1, i2, to_count, pass) = pass
  let pass = string.to_graphemes(pass)
  let b1 =
    list.at(pass, i1 - 1)
    |> result.unwrap("") == to_count
  let b2 =
    list.at(pass, i2 - 1)
    |> result.unwrap("") == to_count
  b1 != b2
}

pub fn part2(input: List(String)) -> Int {
  input
  |> list.map(parse_line)
  |> list.filter(check_pass2)
  |> list.length
}
