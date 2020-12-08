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
  try in: String = input.get_input("2020", "7")
  let in = in |> string.trim() |> string.split("\n")

  let p1 = part1(in) |> int.to_string
  let p2 = part2(in) |> int.to_string
  Ok(string.concat(["Part1: ", p1, " Part2: ", p2]))
}

pub fn parse_line(line: String) -> tuple(String, List(tuple(Int, String))) {
  let reg_subject = "^(.*) bags contain"
  assert Match([_, subject]) = re_run(line, reg_subject, [Capture(All, Binary)])

  let objects = case string.contains(line, "no other bags") {
    True -> []
    False ->  string.split(line, on: ",")
      |> list.map(fn(object) {
        let reg_object = "(\\d+) (.*) bag"
        assert Match([_, quantity, object]) = re_run(object, reg_object, [Capture(All, Binary)])
        tuple(quantity |> int.parse |> result.unwrap(-1), object)
      })
  }
  tuple(subject, objects)
}

pub fn find_children(graph, passed, waiting) {
  case waiting {
    [] -> passed
    [head, ..tail] -> 
      case list.contains(passed, head) {
        True -> find_children(graph, passed, tail)
        False -> {
          let my_children = map.get(graph, head) |> result.unwrap([])
          |> list.map(fn(x) {
            let tuple(_, name) = x
            name
          })

          find_children(graph, [head, ..passed], list.append(waiting, my_children))
        }
      }
    
  }
}

pub fn part1(input: List(String)) -> Int {
  let all_children = list.map(input, parse_line) 
  |> build_graph(Reversed)
  |> find_children([], ["shiny gold"])
  
  list.length(all_children) - 1
}

type Reversed { Reversed Regular }

fn build_graph(input: List(tuple(String, List(tuple(Int, String)))), reversed: Reversed) 
  -> map.Map(String, List(tuple(Int, String))) 
{
  list.fold(input, map.new(), fn(item, m) {
    let tuple(from, children) = item
    list.fold(children, m, fn(child, m) {
      let tuple(quant, child) = child
      let tuple(from, child) = iff(reversed == Regular, tuple(from, child), tuple(child, from))

      map.update(m, from, fn(existing) {
        case existing {
          Ok(l) -> [tuple(quant, child), ..l]
          Error(_) -> [tuple(quant, child)]
        }
      })
    })
  })
}

fn count_bags(
  graph: map.Map(String, List(tuple(Int, String))), 
  cur: String, 
  requirements: map.Map(String, Int)) 
{
  case map.get(graph, cur) {
    Ok(children) -> {
      case map.get(requirements, cur) {
        Ok(requirement) -> tuple(requirements, requirement)
        Error(_) -> {
          let tuple(requirements, my_requirement) = 
            list.fold(children, tuple(requirements, 1), fn(child, acc) {
              let tuple(my_qt, child) = child
              let tuple(requirements, acc) = acc
              let tuple(new_requirements, cq) = count_bags(graph, child, requirements)
              tuple(new_requirements, acc + cq * my_qt)
            })
          tuple(map.insert(requirements, cur, my_requirement), my_requirement)
        }
      }
    }
    Error(_) -> tuple(map.insert(requirements, cur, 1), 1)
  }
}

pub fn part2(input: List(String)) -> Int {
  let tuple(_, res) = list.map(input, parse_line) 
  |> build_graph(Regular)
  |> count_bags("shiny gold", map.new())

  res - 1
}
