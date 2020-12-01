import days/day1
import gleam/should

pub fn part1_test() {
    let data = [
        1721,
        979,
        366,
        299,
        675,
        1456,
    ]

    day1.part1(data)
    |> should.equal(514579)
}