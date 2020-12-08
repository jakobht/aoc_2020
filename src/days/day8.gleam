import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int
import gleam/bool
import gleam/map
import regex.{re_run, Capture, All, Binary, Match, Nomatch}
import util.{iff}

pub fn run() {
  try in: String = input.get_input("2020", "8")
  let in = in |> string.trim() |> string.split("\n")

  let p1 = part1(in) |> int.to_string
  let p2 = part2(in) |> int.to_string
  Ok(string.concat(["Part1: ", p1, " Part2: ", p2]))
}

type Command { Command(String, Int) }

fn new_command(line: String) -> Command {
  let [up_code, arg] = string.split(line, " ")
  Command(up_code, arg |> int.parse() |> result.unwrap(0))
}

type Return { LoopsAt(Int) Terminates(Int) }

fn check(program: List(Command), ip, acc, passed) -> Return {
  case list.contains(passed, ip), list.at(program, ip) {
    True, _ -> LoopsAt(acc)
    _, Ok(Command("nop", _)) -> check(program, ip + 1, acc, [ip, ..passed])
    _, Ok(Command("acc", arg)) -> check(program, ip + 1, acc + arg, [ip, ..passed])
    _, Ok(Command("jmp", arg)) -> check(program, ip + arg, acc, [ip, ..passed])
    _, Error(_) -> Terminates(acc)
  }
}

pub fn part1(input: List(String)) -> Int {
  assert LoopsAt(ip) = input
  |> list.map(new_command)
  |> check(0, 0, [])

  ip
}

fn change(program: List(Command), index: Int) -> List(Command) {
  assert tuple(begin, [to_change, ..end]) = list.split(program, index)
  let changed = case to_change {
    Command("acc", arg) -> Command("acc", arg)
    Command("jmp", arg) -> Command("nop", arg)
    Command("nop", arg) -> Command("jmp", arg)
  }

  begin |> list.append([changed]) |> list.append(end)
}

fn edit_instruction(program: List(Command)) {
  list.range(0, list.length(program))
  |> list.fold(Error(Nil), fn(index, acc) {
    case acc {
      Ok(x) -> Ok(x)
      Error(_) -> 
        case change(program, index) |> check(0, 0, []) {
          LoopsAt(_) -> Error(Nil)
          Terminates(x) -> Ok(x)
        }
    }
  })
}

pub fn part2(input: List(String)) -> Int {
  assert Ok(x) = input
  |> list.map(new_command)
  |> edit_instruction

  x
}
