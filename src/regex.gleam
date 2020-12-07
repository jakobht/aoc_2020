pub type CaptureOptions { All Binary }
pub type RegexOption { Capture(CaptureOptions, CaptureOptions) Anchored Global }
pub type MatchResult { Match(List(String)) Nomatch }

pub external fn re_run(String, String,
  List(RegexOption)) -> MatchResult = "re" "run"
