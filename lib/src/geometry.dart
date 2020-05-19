part of geo_math;

/// 평면상의 기하 연산.

const double pi2 = pi * 2;
const double piDiv2 = pi / 2;

double toRadian(double degree) => degree * (pi / 180);

double toDegree(double radian) => radian * (180 / pi);

/// 도 단위의 [azimuth]를 시계방향 각을 계산하여 시(1시, 2시) 방향 반환.
int degreeToClockPosition(double azimuth) {
  final angle = ((azimuth + 360) / 30 % 12).round();
  return angle == 0 ? 12 : angle;
}

/// 라디안 단위의 [azimuth]를 시계방향 각을 계산하여 시(1시, 2시) 방향 반환.
int radianToClockPosition(double azimuth) =>
    degreeToClockPosition(toDegree(azimuth));

/// 두 벡터[v1], [v2] 사이의 투영 벡터를 계산하여 반환.
/// [offset]이 주어질 경우 더해서 반환.
Vector2 getProjectionVectorBetween(Vector2 v1, Vector2 v2, {Vector2 offset}) =>
    (v2 * (v1.dot(v2) / v2.dot(v2))) + (offset ?? Vector2.zero());

/// 두 벡터[v1]에서 [v2]에 내린 수선의 벡터를 계산하여 반환.
/// [offset]이 주어질 경우 더해서 반환.
Vector2 getPerpendicularVectorBetween(Vector2 v1, Vector2 v2,
        {Vector2 offset}) =>
    ((v1 - getProjectionVectorBetween(v1, v2)) * -1) +
    (offset ?? Vector2.zero());
