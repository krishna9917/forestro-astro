import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:phone_input/phone_input_package.dart';

Widget InputPhoneNo(
    {void Function(PhoneNumber?)? onChanged,
    Color? bgcolor,
    bool autofocus = false,
    PhoneNumber? initialValue,
    Color? bordercolor}) {
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(width: 1, color: bordercolor ?? AppColor.primary),
  );
  return PhoneInput(
    showFlagInInput: false,
    autofocus: autofocus,
    defaultCountry: IsoCode.IN,
    style: const TextStyle(fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      hintText: "Mobile Number",
      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      border: outlineInputBorder,
      filled: true,
      fillColor: bgcolor ?? Colors.transparent,
      enabledBorder: outlineInputBorder,
      focusedErrorBorder: outlineInputBorder,
      errorBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    ),
    showArrow: true,
    countrySelectorNavigator: const CountrySelectorNavigator.modalBottomSheet(
      searchInputDecoration: InputDecoration(
          icon: Icon(Icons.search_rounded),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Search Country"),
      addFavoriteSeparator: true,
      flagShape: BoxShape.circle,
    ),
    onChanged: onChanged,
    initialValue: initialValue,
  );
}

class SelectBox extends StatelessWidget {
  final List<String> list;
  final String? hint;
  final String? initialItem;
  final dynamic Function(String?)? onChanged;
  SelectBox({
    required this.list,
    this.initialItem,
    required this.onChanged,
    this.hint = "Select",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: hint,
      items: list,
      initialItem: initialItem,

      closedHeaderPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),

      decoration: CustomDropdownDecoration(
        closedBorderRadius: BorderRadius.circular(50),
        closedBorder: Border.all(
          width: 1,
          color: Color.fromARGB(255, 233, 233, 233),
        ),
      ),
      onChanged: onChanged,
      // Run validation on item selected
      validateOnChange: true,

      // Function to validate if the current selected item is valid or not
      validator: (value) => null,
    );
  }
}

class InputBox extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  InputBox({
    required this.title,
    this.controller,
    super.key,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 7),
          child: Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            fillColor: Color.fromARGB(164, 255, 255, 255),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 233, 233, 233),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
