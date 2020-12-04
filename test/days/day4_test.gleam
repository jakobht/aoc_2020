import days/day4
import gleam/should

const data_part1 = [
  "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm",
  "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929", "hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:179cm",
  "hcl:#cfa07d eyr:2025 pid:166559648\niyr:2011 ecl:brn hgt:59in",
]

pub fn part1_test() {
  day4.part1(data_part1)
  |> should.equal(2)
}

const data_part2 = [
  "eyr:1972 cid:100\nhcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926", "iyr:2019\nhcl:#602927 eyr:1967 hgt:170cm\necl:grn pid:012533040 byr:1946",
  "hcl:dab227 iyr:2012\necl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277",
  "hgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007", "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980\nhcl:#623a2f",
  "eyr:2029 ecl:blu cid:129 byr:1989\niyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",
  "hcl:#888785\nhgt:164cm byr:2001 iyr:2015 cid:88\npid:545766238 ecl:hzl\neyr:2022",
  "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719",
]

pub fn part2_test() {
  day4.part2(data_part2)
  |> should.equal(4)
}

pub fn get_prop_begin_test() {
  day4.get_prop(
    "hgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007",
    "hgt",
  )
  |> should.equal(Ok("59cm"))
}

pub fn get_prop_newline_test() {
  day4.get_prop(
    "hgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007",
    "ecl",
  )
  |> should.equal(Ok("zzz"))
}

pub fn get_prop_mid_test() {
  day4.get_prop(
    "hgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007",
    "hcl",
  )
  |> should.equal(Ok("74454a"))
}

pub fn get_prop_end_test() {
  day4.get_prop(
    "hgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007",
    "byr",
  )
  |> should.equal(Ok("2007"))
}

pub fn validate_byr_test() {
  day4.validate_byr("byr:1919")
  |> should.equal(False)

  day4.validate_byr("byr:1920")
  |> should.equal(True)

  day4.validate_byr("byr:1960")
  |> should.equal(True)

  day4.validate_byr("byr:2002")
  |> should.equal(True)

  day4.validate_byr("byr:2003")
  |> should.equal(False)

  day4.validate_byr("iyr:2000")
  |> should.equal(False)
}

pub fn validate_iyr_test() {
  day4.validate_iyr("iyr:2009")
  |> should.equal(False)

  day4.validate_iyr("iyr:2010")
  |> should.equal(True)

  day4.validate_iyr("iyr:2015")
  |> should.equal(True)

  day4.validate_iyr("iyr:2020")
  |> should.equal(True)

  day4.validate_iyr("iyr:2021")
  |> should.equal(False)

  day4.validate_iyr("byr:2015")
  |> should.equal(False)
}

pub fn validate_eyr_test() {
  day4.validate_eyr("eyr:2019")
  |> should.equal(False)

  day4.validate_eyr("eyr:2020")
  |> should.equal(True)

  day4.validate_eyr("eyr:2025")
  |> should.equal(True)

  day4.validate_eyr("eyr:2030")
  |> should.equal(True)

  day4.validate_eyr("eyr:2031")
  |> should.equal(False)

  day4.validate_eyr("eyr:2035")
  |> should.equal(False)
}

pub fn validate_hgt_test() {
  day4.validate_hgt("hgt:149cm")
  |> should.equal(False)

  day4.validate_hgt("hgt:150cm")
  |> should.equal(True)

  day4.validate_hgt("hgt:58in")
  |> should.equal(False)

  day4.validate_hgt("hgt:59in")
  |> should.equal(True)

  day4.validate_hgt("hgt:59int")
  |> should.equal(False)
}

pub fn validate_hcl_test() {
  day4.validate_hcl("hcl:#123abc")
  |> should.equal(True)

  day4.validate_hcl("hcl:#123abz")
  |> should.equal(False)

  day4.validate_hcl("hcl:abc123")
  |> should.equal(False)
  day4.validate_hcl("hcl:#123abcd")
  |> should.equal(False)
}

pub fn validate_ecl_test() {
  day4.validate_ecl("ecl:amb")
  |> should.equal(True)

  day4.validate_ecl("ecl:aaa")
  |> should.equal(False)
}

pub fn validate_pid_test() {
  day4.validate_pid("pid:123456789")
  |> should.equal(True)

  day4.validate_pid("pid:12345678")
  |> should.equal(False)

  day4.validate_pid("pid:12345678k")
  |> should.equal(False)
}
