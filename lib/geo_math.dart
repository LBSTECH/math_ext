library geo_math;

import 'dart:math';

import 'package:vector_math/vector_math.dart';

part 'src/general_math.dart';

part 'src/geometry.dart';

part 'src/vincenty_formula.dart';

double getAzimuthBetween(
  double fromLat,
  double fromLng,
  double toLat,
  double toLng,
) {
  final theta = atan2(toLat - fromLat, toLng - fromLng);
  final azimuth = piDiv2 - theta;
  return azimuth < 0 ? azimuth + pi2 : azimuth;
}

double getAzimuthBetweenDeg(
  double fromLat,
  double fromLng,
  double toLat,
  double toLng,
) =>
    toDegree(getAzimuthBetween(fromLat, fromLng, toLat, toLng));
