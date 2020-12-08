import days/day8
import gleam/should
import gleam/int
import gleam/io

const data = [
  "nop +0",
  "acc +1",
  "jmp +4",
  "acc +3",
  "jmp -3",
  "acc -99",
  "acc +1",
  "jmp -4",
  "acc +6",
]

pub fn part1_test() {
  day8.part1(data) |> should.equal(5)
}

pub fn part2_test() {
  day8.part2(data) |> should.equal(8)
}
