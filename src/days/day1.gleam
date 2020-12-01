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

fn part1_find(input: List(Int)) -> tuple(Int, Int) {
  assert [head, ..tail] = input

  case list.find(tail, fn(x) { x + head == 2020 }) {
    Ok(x) -> tuple(head, x)
    Error(_) -> part1_find(tail)
  }
}

pub fn part1(input: List(Int)) -> Int {
  assert tuple(a, b) = part1_find(input)

  a*b
  }
}
