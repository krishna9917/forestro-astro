import 'package:flutter/services.dart';
import 'package:fore_astro_2/package/phoneinput/src/constants/patterns.dart';
import 'package:fore_astro_2/package/phoneinput/src/controllers/phone_controller.dart';
import 'package:fore_astro_2/package/phoneinput/src/number_parser/metadata/metadata_finder.dart';

class PhoneLengthLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  PhoneLengthLimitingTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(Patterns.numberDividers), '');
    return newText.length > maxLength ? oldValue : newValue;
  }

  PhoneLengthLimitingTextInputFormatter.fromController(PhoneController controller)
      : maxLength = MetadataFinder.getMetadataLengthForIsoCode(controller.value!.isoCode).mobile.last;
}
