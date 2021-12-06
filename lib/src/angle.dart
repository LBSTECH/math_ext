import 'dart:math';

/// 평면상의 기하 연산.

/// [degree]를 라디안 단위로 변환.
double toRadian(num degree) => degree * (pi / 180);

/// [radian]을 도 단위로 변환.
double toDegree(num radian) => radian * (180 / pi);

/// 도 단위의 [azimuth]를 시계방향 각을 계산하여 시(1시, 2시) 방향 반환.
int degreeToClockPosition(num azimuth) {
  final angle = ((azimuth + 360) / 30 % 12).round();
  return angle == 0 ? 12 : angle;
}

/// 라디안 단위의 [azimuth]를 시계방향 각을 계산하여 시(1시, 2시) 방향 반환.
int radianToClockPosition(num azimuth) =>
    degreeToClockPosition(toDegree(azimuth));
