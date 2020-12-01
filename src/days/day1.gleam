import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int

pub fn run() {
  try in = input.get_input("2020", "1")
  try in =
    in
    |> string.trim()
    |> string.split("\n")
    |> input.string_list_to_int_list
    |> result.map_error(fn(_) { "Could not parse all input as ints" })
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

fn part1_find(input: List(Int), sum) -> Result(tuple(Int, Int), Nil) {
  case list.is_empty(input) {
    True -> Error(Nil)
    False -> {
      assert [head, ..tail] = input
      case list.find(tail, fn(x) { x + head == sum }) {
        Ok(x) -> Ok(tuple(head, x))
        Error(_) -> part1_find(tail, sum)
      }
    }
  }
}

pub fn part1(input: List(Int)) -> Int {
  assert Ok(tuple(a, b)) = part1_find(input, 2020)

  a * b
}

pub fn part2(input: List(Int)) -> Int {
  assert [head, ..tail] = input

  case part1_find(tail, 2020 - head) {
    Ok(tuple(a, b)) -> head * a * b
    Error(_) -> part2(tail)
  }
}
