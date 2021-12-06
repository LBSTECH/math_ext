import 'dart:math';

import 'angle.dart';

const double pi2 = pi * 2;
const double piDiv2 = pi / 2;

extension Vector on Point {
  num dot(Point other) => x * other.x + y * other.y;

  /// [point] 까지의 투영 벡터를 계산하여 반환.
  /// [offset]이 주어질 경우 더해서 반환.
  Point projectionVectorTo(
    Point point, [
    Point offset = const Point(0, 0),
  ]) =>
      offset + (point * (dot(point) / point.dot(point)));

  /// [point]에 내린 수선의 벡터를 계산하여 반환.
  /// [offset]이 주어질 경우 더해서 반환.
  Point perpendicularVectorTo(
    Point point, [
    Point offset = const Point(0, 0),
  ]) =>
      offset - (this - projectionVectorTo(point));

  /// from 자표 부터 to 좌표 까지의 방위각을 라디안 단위로 반환.
  double azimuthRadianTo(Point to) {
    final theta = atan2(to.y - y, to.x - x);
    final azimuth = piDiv2 - theta;
    return azimuth < 0 ? azimuth + pi2 : azimuth;
  }

  /// from 자표 부터 to 좌표 까지의 방위각을 도 단위로 반환.
  double azimuthDegreeTo(Point to) => toDegree(azimuthRadianTo(to));
}
