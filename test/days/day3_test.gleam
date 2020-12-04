import days/day3
import gleam/should

const data = [
  "..##.......", "#...#...#..", ".#....#..#.", "..#.#...#.#", ".#...##..#.", "..#.##.....",
  ".#.#.#....#", ".#........#", "#.##...#...", "#...##....#", ".#..#...#.#",
]

pub fn part1_test() {
  day3.part1(data)
  |> should.equal(7)
}

pub fn part2_test() {
  day3.part2(data)
  |> should.equal(336)
}
