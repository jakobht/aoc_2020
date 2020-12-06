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
}

pub fn part1(input: List(String)) -> Int {
  list.map(input, calc_seat)
  |> list.fold(0, int.max)
}

pub fn part2(input: List(String)) -> Int {
  0
}
