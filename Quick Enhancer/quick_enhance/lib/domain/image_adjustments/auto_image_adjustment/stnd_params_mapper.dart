import '../../enums/param_status.dart';

class StandardParamMapper {

  // ---------- BRIGHTNESS ----------
  static double brightnessAdjustment(ParamStatus s) {
    switch (s) {
      case ParamStatus.extremeLow:    return 0.12;
      case ParamStatus.veryLow:       return 0.09;
      case ParamStatus.low:           return 0.06;
      case ParamStatus.slightlyLow:   return 0.03;

      case ParamStatus.perfect:       return 0.01;

      case ParamStatus.slightlyHigh:  return -0.03;
      case ParamStatus.high:          return -0.05;
      case ParamStatus.veryHigh:      return -0.07;
      case ParamStatus.extremeHigh:   return -0.10;
    }
  }

  // ---------- CONTRAST ----------
  static double contrastAdjustment(ParamStatus s) {
    switch (s) {
      case ParamStatus.extremeLow:    return 0.30;
      case ParamStatus.veryLow:       return 0.22;
      case ParamStatus.low:           return 0.15;
      case ParamStatus.slightlyLow:   return 0.08;

      case ParamStatus.perfect:       return 0.04;

      case ParamStatus.slightlyHigh:  return -0.05;
      case ParamStatus.high:          return -0.10;
      case ParamStatus.veryHigh:      return -0.16;
      case ParamStatus.extremeHigh:   return -0.22;
    }
  }

  // ---------- SATURATION ----------
  static double saturationAdjustment(ParamStatus s) {
    switch (s) {
      case ParamStatus.extremeLow:    return 0.20;
      case ParamStatus.veryLow:       return 0.16;
      case ParamStatus.low:           return 0.12;
      case ParamStatus.slightlyLow:   return 0.06;

      case ParamStatus.perfect:       return 0.03;

      case ParamStatus.slightlyHigh:  return -0.05;
      case ParamStatus.high:          return -0.08;
      case ParamStatus.veryHigh:      return -0.12;
      case ParamStatus.extremeHigh:   return -0.16;
    }
  }

  // ---------- HIGHLIGHTS ----------

  static double highlightsAdjustment(ParamStatus s) {
    switch (s) {
      case ParamStatus.extremeLow:    return 0.06;
      case ParamStatus.veryLow:       return 0.05;
      case ParamStatus.low:           return 0.04;
      case ParamStatus.slightlyLow:   return 0.02;

      case ParamStatus.perfect:       return 0.0;

      case ParamStatus.slightlyHigh:  return -0.02;
      case ParamStatus.high:          return -0.04;
      case ParamStatus.veryHigh:      return -0.06;
      case ParamStatus.extremeHigh:   return -0.08;
    }
  }


  // ---------- SHADOWS ----------
  static double shadowsAdjustment(ParamStatus s) {
    switch (s) {
      case ParamStatus.extremeLow:    return 0.12;
      case ParamStatus.veryLow:       return 0.08;
      case ParamStatus.low:           return 0.05;
      case ParamStatus.slightlyLow:   return 0.02;

      case ParamStatus.perfect:       return 0.0;

      case ParamStatus.slightlyHigh:  return -0.02;
      case ParamStatus.high:          return -0.05;
      case ParamStatus.veryHigh:      return -0.08;
      case ParamStatus.extremeHigh:   return -0.12;
    }
  }
}
