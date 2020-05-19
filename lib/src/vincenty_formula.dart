part of geo_math;

/// 지구상 두 점 사이의 거리 계산 및 한 점으로 부터 일정 거리 떨어진 점을 계산하는
/// Vincenty 공식 구현.
/// Based on WGS-84.

/// 지구 평편률
const double flattening = 1 / 298.257223563;

/// 지구 중심부터 적도까지의 반지름(km)
const double equatorialRadius = 6378137.0;

/// 지구 중심부터 북극 까지의 반지름(km)
const double polarRadius = 6356752.314245;

/// 오차값 보정값
const double epsilon = 1e-12;

/// [from]부터 [azimuth]방향으로 [distanceM]떨어진 점의 좌표를 계산하여 반환.
Map<String, double> calculateOffset(
  final double fromLat,
  final double fromLng,
  final double azimuth,
  final double distanceM,
) {
  if (fromLat == null ||
      fromLng == null ||
      azimuth == null ||
      distanceM == null) {
    throw ArgumentError.notNull();
  }

  final sinAlpha1 = sin(azimuth);
  final cosAlpha1 = cos(azimuth);

  final tanU1 = (1 - flattening) * tan(toRadian(fromLat));
  final cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
  final sinU1 = tanU1 * cosU1;

  final sigma1 = atan2(tanU1, cosAlpha1);
  final sinAlpha = cosU1 * sinAlpha1;
  final cosSqrAlpha = 1 - sinAlpha * sinAlpha;
  final uSqr = cosSqrAlpha *
      (equatorialRadius * equatorialRadius - polarRadius * polarRadius) /
      (polarRadius * polarRadius);

  final A =
      1 + (uSqr / 16384) * (4096 + uSqr * (-768 + uSqr * (320 - 175 * uSqr)));
  final B = (uSqr / 1024) * (256 + uSqr * (-128 + uSqr * (74 - 47 * uSqr)));

  var maxIteration = 200;
  var prevSigma = pi2;
  var sigma = distanceM / (polarRadius * A);

  double cos2SigmaM;
  double sinSigma;
  double cosSigma;
  double deltaSigma;

  do {
    cos2SigmaM = cos(2 * sigma1 + sigma);
    sinSigma = sin(sigma);
    cosSigma = cos(sigma);
    deltaSigma = B *
        sinSigma *
        (cos2SigmaM +
            (B / 4) *
                (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                    (B / 6) *
                        cos2SigmaM *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM * cos2SigmaM)));

    prevSigma = sigma;
    sigma = distanceM / (polarRadius * A) + deltaSigma;
  } while ((sigma - prevSigma).abs() > epsilon && --maxIteration > 0);

  if (maxIteration == 0) {
    throw StateError('Offset calculation faild to converge!');
  }

  final temp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
  final targetLat = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
      (1 - flattening) * sqrt(sinAlpha * sinAlpha + temp * temp));
  final lambda = atan2(
      sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
  final C = (flattening / 16) *
      cosSqrAlpha *
      (4 + flattening * (4 - 3 * cosSqrAlpha));
  final L = lambda -
      (1 - C) *
          flattening *
          sinAlpha *
          (sigma +
              C *
                  sinSigma *
                  (cos2SigmaM +
                      C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));

  var targetLng = L + toRadian(fromLng);

  if (targetLng > pi) {
    targetLng = targetLng - 2 * pi;
  }
  if (targetLng < -pi) {
    targetLng = targetLng + 2 * pi;
  }

  return {'latitude': toDegree(targetLat), 'longitude': toDegree(targetLng)};
}

/// 두 점 [p1]과 [p2] 사이의 거리를 미터 단위로 계산하여 반환.
double calculateDistance(
  final double fromLat,
  final double fromLng,
  final double toLat,
  final double toLng,
) {
  if (fromLat == null || fromLng == null || toLat == null || toLng == null) {
    throw ArgumentError.notNull();
  }

  final L = toRadian(toLng) - toRadian(fromLng);
  final u1 = atan((1 - flattening) * tan(toRadian(fromLat)));
  final u2 = atan((1 - flattening) * tan(toRadian(toLat)));
  final sinU1 = sin(u1), cosU1 = cos(u1);
  final sinU2 = sin(u2), cosU2 = cos(u2);

  double sinLambda,
      cosLambda,
      sinSigma,
      cosSigma,
      sigma,
      sinAlpha,
      cosSqAlpha,
      cos2SigmaM;
  double lambda = L, lambdaP;

  var maxIterations = 200;

  do {
    sinLambda = sin(lambda);
    cosLambda = cos(lambda);
    sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
        (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
            (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));

    if (sinSigma == 0) {
      return 0.0; // co-incident points
    }

    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = atan2(sinSigma, cosSigma);
    sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
    cosSqAlpha = 1 - sinAlpha * sinAlpha;
    cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

    if (cos2SigmaM.isNaN) {
      cos2SigmaM = 0.0; // equatorial line: cosSqAlpha=0 (§6)
    }

    final C =
        flattening / 16 * cosSqAlpha * (4 + flattening * (4 - 3 * cosSqAlpha));
    lambdaP = lambda;
    lambda = L +
        (1 - C) *
            flattening *
            sinAlpha *
            (sigma +
                C *
                    sinSigma *
                    (cos2SigmaM +
                        C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
  } while ((lambda - lambdaP).abs() > 1e-12 && --maxIterations > 0);

  if (maxIterations == 0) {
    throw StateError('Distance calculation faild to converge!');
  }

  final uSq = cosSqAlpha *
      (equatorialRadius * equatorialRadius - polarRadius * polarRadius) /
      (polarRadius * polarRadius);
  final A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  final B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
  final deltaSigma = B *
      sinSigma *
      (cos2SigmaM +
          B /
              4 *
              (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                  B /
                      6 *
                      cos2SigmaM *
                      (-3 + 4 * sinSigma * sinSigma) *
                      (-3 + 4 * cos2SigmaM * cos2SigmaM)));

  return polarRadius * A * (sigma - deltaSigma);
}
