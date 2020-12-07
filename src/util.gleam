pub fn iff(condition: Bool, then then: a, else else: a) {
  case condition {
    True -> then
    False -> else
  }
}