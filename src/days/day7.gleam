import input
import gleam/list
import gleam/io
import gleam/string
import gleam/result
import gleam/int
import gleam/bool
import gleam/map
import regex.{re_run, Capture, All, Binary, Match, Nomatch}

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
    False -> {
      string.split(line, on: ",")
      |> list.map(fn(object) {
        let reg_object = "(\\d+) (.*) bag"
        assert Match([_, quantity, object]) = re_run(object, reg_object, [Capture(All, Binary)])
        tuple(quantity |> int.parse |> result.unwrap(-1), object)
      })
    }
  }
  tuple(subject, objects)
}

fn build_reverse_graph(input: List(tuple(String, List(tuple(Int, String))))) 
  -> map.Map(String, List(tuple(Int, String))) {
  list.fold(input, map.new(), fn(item, m) {
    assert tuple(to, froms) = item
    list.fold(froms, m, fn(from, m) {
      assert tuple(quant, from) = from
      map.update(m, from, fn(existing) {
        case existing {
          Ok(l) -> list.append(l, [tuple(quant, to)])
          Error(_) -> [tuple(quant, to)]
        }
      })
    })
  })
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
            assert tuple(_, name) = x
            name
          })

          find_children(graph, [head, ..passed], list.append(waiting, my_children))
        }
      }
    
  }
}

pub fn part1(input: List(String)) -> Int {
  let all_children = list.map(input, parse_line) 
  |> build_reverse_graph()
  |> find_children([], ["shiny gold"])
  |> io.debug
  
  list.length(all_children) - 1
}

fn build_graph(input: List(tuple(String, List(tuple(Int, String))))) 
  -> map.Map(String, List(tuple(Int, String))) {
  list.fold(input, map.new(), fn(item, m) {
    assert tuple(from, children) = item
    let m = map.merge(map.from_list([tuple(from, [])]), m)
    list.fold(children, m, fn(child, m) {
      assert tuple(quant, child) = child
      map.update(m, from, fn(existing) {
        case existing {
          Ok(l) -> list.append(l, [tuple(quant, child)])
          Error(_) -> [tuple(quant, child)]
        }
      })
    })
  })
}

fn count_bags(
  graph: map.Map(String, List(tuple(Int, String))), 
  cur: String, 
  requirements: map.Map(String, Int)) {
  assert Ok(children) = map.get(graph, cur)

  case map.get(requirements, cur) {
    Ok(requirement) -> tuple(requirements, requirement)
    Error(_) -> {
      assert tuple(requirements, my_requirement) = 
        list.fold(children, tuple(requirements, 1), fn(child, acc) {
          assert tuple(my_qt, child) = child
          assert tuple(requirements, acc) = acc
          assert tuple(new_requirements, cq) = count_bags(graph, child, requirements)
          tuple(new_requirements, acc + cq * my_qt)
        })
      tuple(map.insert(requirements, cur, my_requirement), my_requirement)
    }
  }
}

pub fn part2(input: List(String)) -> Int {
  assert tuple(_, res) = list.map(input, parse_line) 
  |> build_graph()
  |> count_bags("shiny gold", map.new())

  res - 1
}
