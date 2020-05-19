part of geo_math;

// dart:math 패키지에 없는 간단한 math 함수

/// [value]를 [minimum]이상 [maximum]이하로 제한하여 반환합니다.
num clamp(num value, num minimum, num maximum) =>
    max(minimum, min(maximum, value));

/// [value]를 [minimum]이상 [maximum]이하로 제한하여 반환합니다.
///
/// [Geometry.clamp]와 달리 [maximum]를 넘어가게 되면 [value]를 [maximum]로 나눈 나머지를 [minimum]과 비교합니다.
num wrap(num value, num minimum, num maximum) {
  if (minimum == maximum) return minimum;

  final range = maximum - minimum;

  return ((value - minimum) % range + range) % range + minimum;
}
