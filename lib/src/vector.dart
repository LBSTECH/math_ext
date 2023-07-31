import 'dart:math';

import 'package:vector_math/vector_math.dart';

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

  /// from 좌표부터 to 좌표까지의 방위각을 라디안 단위로 반환.
  double azimuthRadianTo(Point to) {
    var startLongitudeRadians = radians(x.toDouble());
    var startLatitudeRadians = radians(y.toDouble());
    var endLongitudeRadians = radians(to.x.toDouble());
    var endLatitudeRadians = radians(to.y.toDouble());

    var dY = sin(endLongitudeRadians - startLongitudeRadians) *
        cos(endLatitudeRadians);
    var dX = cos(startLatitudeRadians) * sin(endLatitudeRadians) -
        sin(startLatitudeRadians) *
            cos(endLatitudeRadians) *
            cos(endLongitudeRadians - startLongitudeRadians);

    return atan2(dY, dX);
  }

  /// from 자표 부터 to 좌표 까지의 방위각을 도 단위로 반환.
  double azimuthDegreeTo(Point to) => toDegree(azimuthRadianTo(to));
}
