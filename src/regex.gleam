pub type RegexOption { Capture All Binary }
pub type MatchResult { Match(List(String)) Nomatch }

pub external fn re_run(String, String,
  List(tuple(RegexOption, RegexOption, RegexOption))) -> MatchResult = "re" "run"
