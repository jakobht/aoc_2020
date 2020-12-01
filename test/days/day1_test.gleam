import days/day1
import gleam/should

const data = [1721, 979, 366, 299, 675, 1456]

pub fn part1_test() {
  day1.part1(data)
  |> should.equal(514579)
}

pub fn part2_test() {
  day1.part2(data)
  |> should.equal(241861950)
}
