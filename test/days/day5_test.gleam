import days/day5
import gleam/should

pub fn part1_test() {
  day5.part1(["BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"]) |> should.equal(820)
}

pub fn calc_seat_test() {
  day5.calc_seat("BFFFBBFRRR") |> should.equal(567)
  day5.calc_seat("FFFBBBFRRR") |> should.equal(119)
  day5.calc_seat("BBFFBBFRLL") |> should.equal(820)
}

// pub fn part2_test() {
//   day5.part2([]) |> should.equal(4)
// }
