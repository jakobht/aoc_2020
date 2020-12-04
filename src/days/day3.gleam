import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int

pub fn run() {
  try in: String = input.get_input("2020", "3")
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

fn count(
  input: List(List(String)),
  coords: tuple(Int, Int),
  slope: tuple(Int, Int),
) -> Int {
  assert tuple(x, y) = coords
  assert tuple(sx, sy) = slope
  let width =
    input
    |> list.head
    |> result.unwrap([])
    |> list.length
  let next_coords = tuple({ x + sx } % width, y + sy)

  case y >= list.length(input) {
    True -> 0
    False -> {
      assert Ok(point) =
        input
        |> list.at(y)
        |> result.then(fn(i) { list.at(i, x) })
      case point {
        "#" -> 1 + count(input, next_coords, slope)
        "." -> count(input, next_coords, slope)
      }
    }
  }
}

pub fn part1(input: List(String)) -> Int {
  count(
    input
    |> list.map(string.to_graphemes),
    tuple(0, 0),
    tuple(3, 1),
  )
}

pub fn part2(input: List(String)) -> Int {
  let slopes = [tuple(1, 1), tuple(3, 1), tuple(5, 1), tuple(7, 1), tuple(1, 2)]
  slopes
  |> list.map(count(
    input
    |> list.map(string.to_graphemes),
    tuple(0, 0),
    _,
  ))
  |> list.fold(1, fn(a, b) { a * b })
}
