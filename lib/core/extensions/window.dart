import 'package:flutter/material.dart';

extension WindowDimensionsExtension on BuildContext {
  double get windowWidth {
    return MediaQuery.of(this).size.width;
  }

  double get windowHeight {
    return MediaQuery.of(this).size.height;
  }
}
