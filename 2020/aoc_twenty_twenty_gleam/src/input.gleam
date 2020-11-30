import gleam/io
import gleam/os
import gleam/map
import gleam/list
import gleam/string
import gleam/int
import gleam/httpc
import gleam/result
import gleam/http.{Get}

pub fn get_input(year, day) -> Result(String, String) {
  let env = os.get_env()
  try session_cookie = map.get(env, "AOC_SESSION") 
    |> result.map_error(fn(_) {"The environment variable AOC_SESSION is not defined"})

  let req = http.default_req()
    |> http.set_method(Get)
    |> http.set_host("adventofcode.com")
    |> http.set_path([year, "/day/", day, "/input"] |> string.concat)
    |> http.prepend_req_header("Cookie", string.append("session=", session_cookie))

  try resp = httpc.send(req) |> result.map_error(fn(x) {io.debug(x); "Error sending HTTP request"})

  Ok(resp.body)
}

/// Combine a list of results into a single result.
/// If all elements in the list are Ok then returns an Ok holding the list of values.
/// If any element is Error then returns the first error.
///
/// ## Examples
///    > all([Ok(1), Ok(2)])
///    Ok([1, 2])
///
///    > all([Ok(1), Error("e")])
///    Error("e")
pub fn all(results: List(Result(a, e))) -> Result(List(a), e) {
  list.try_map(results, fn(x) { x })
}

pub fn string_list_to_int_list(strings : List(String)) -> Result(List(Int), Nil) {
  list.map(strings, int.parse) |> all
}