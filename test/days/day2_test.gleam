import days/day2
import gleam/should

const data = ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]

pub fn part1_test() {
  day2.part1(data)
  |> should.equal(2)
}

pub fn part2_test() {
  day2.part2(data)
  |> should.equal(1)
}
