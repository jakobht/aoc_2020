import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int

// Currently solves last years challange 1
pub fn run() {
  try in = input.get_input("2020", "1")
  try in =
    in
    |> string.trim()
    |> string.split("\n")
    |> input.string_list_to_int_list
    |> result.map_error(fn(_) { "Could not parse all input as ints" })
  part1(in)
  |> int.to_string
  |> Ok()
}

pub fn part1(input) -> Int {
  0
}
