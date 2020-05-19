library geo_math;

import 'dart:math';

import 'package:vector_math/vector_math.dart';

part 'src/general_math.dart';

part 'src/geometry.dart';

part 'src/vincenty_formula.dart';

/// from 자표 부터 to 좌표 까지의 방위각을 라디안 단위로 반환.
double getAzimuthBetweenRadian(
  double fromLat,
  double fromLng,
  double toLat,
  double toLng,
) {
  final theta = atan2(toLat - fromLat, toLng - fromLng);
  final azimuth = piDiv2 - theta;
  return azimuth < 0 ? azimuth + pi2 : azimuth;
}

/// from 자표 부터 to 좌표 까지의 방위각을 도 단위로 반환.
double getAzimuthBetweenDegree(
  double fromLat,
  double fromLng,
  double toLat,
  double toLng,
) =>
    toDegree(getAzimuthBetweenRadian(fromLat, fromLng, toLat, toLng));
