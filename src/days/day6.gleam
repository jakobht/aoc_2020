import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int
import gleam/bool
import regex.{re_run, Capture, All, Binary, Match, Nomatch}

pub fn run() {
  try in: String = input.get_input("2020", "6")
  let in = in |> string.trim() |> string.split("\n\n")

  let p1 = part1(in) |> int.to_string
  let p2 = part2(in) |> int.to_string
  Ok(string.concat(["Part1: ", p1, " Part2: ", p2]))
}

pub fn part1(input: List(String)) -> Int {
  list.map(input, fn(i) {
    {i |> string.append("\n") |> string.to_graphemes |> list.unique |> list.length} - 1
  })
  |> list.fold(0, fn(x, y) {x + y})
}

pub fn part2(input: List(String)) -> Int {
  list.map(input, fn(i) {
    let i = i |> string.trim() |> string.split("\n") |> list.map(string.to_graphemes)
    assert [head, ..tail] = i
    list.fold(head, 0, fn(x, acc) {
      {list.all(tail, list.contains(_, x)) |> bool.to_int} + acc
    })
  })
  |> list.fold(0, fn(x, y) {x + y})
}
