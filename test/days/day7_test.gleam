import days/day7
import gleam/should

const data = [
  "light red bags contain 1 bright white bag, 2 muted yellow bags.",
  "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
  "bright white bags contain 1 shiny gold bag.",
  "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
  "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
  "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
  "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
  "faded blue bags contain no other bags.",
  "dotted black bags contain no other bags.",
]

pub fn parse_line1_test() {
  day7.parse_line("light red bags contain 1 bright white bag, 2 muted yellow bags.")
  |> should.equal(tuple("light red", [tuple(1, "bright white"), tuple(2, "muted yellow")]))
}

pub fn parse_line2_test() {
  day7.parse_line("faded blue bags contain no other bags.")
  |> should.equal(tuple("faded blue", []))
}

pub fn parse_line3_test() {
  day7.parse_line("striped green bags contain 443245432 wavy coral bags, 4 shiny gold bags, 3 dark brown bags, 5 vibrant brown bags.")
  |> should.equal(tuple("striped green", 
    [tuple(443245432, "wavy coral"), tuple(4, "shiny gold"), tuple(3, "dark brown"), tuple(5, "vibrant brown")]))
}

pub fn part1_test() {
  day7.part1(data) |> should.equal(4)
}

const data2 = [
  "shiny gold bags contain 2 dark red bags.",
  "dark red bags contain 2 dark orange bags.",
  "dark orange bags contain 2 dark yellow bags.",
  "dark yellow bags contain 2 dark green bags.",
  "dark green bags contain 2 dark blue bags.",
  "dark blue bags contain 2 dark violet bags.",
  "dark violet bags contain no other bags.",
]

pub fn part2_test() {
  day7.part2(data2) |> should.equal(126)
}
