import days/day6
import gleam/should

const data = [
  "abc",
"a
b
c",
"ab
ac",
"a
a
a
a",
"b"
]

pub fn part1_test() {
  day6.part1(data) |> should.equal(11)
}

pub fn part2_test() {
  day6.part2(data) |> should.equal(6)
}
