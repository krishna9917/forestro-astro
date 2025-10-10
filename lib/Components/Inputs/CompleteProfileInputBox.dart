import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileInputBox extends StatelessWidget {
  String title;
  TextEditingController? textEditingController;
  int maxLines;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  int? maxLength;
  bool readOnly;
  Widget? prefixIcon;
  Function()? onTap;
  Widget? suffixIcon;
  bool obscureText;
  bool autofocus;
  bool? enable;
  Function(String)? onChanged;
  String? hintText;
  List<TextInputFormatter>? inputFormatter;
  CompleteProfileInputBox(
      {super.key,
      this.keyboardType,
      this.textEditingController,
      required this.title,
      this.validator,
      this.readOnly = false,
      this.onTap,
      this.maxLines = 1,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus = false,
      this.obscureText = false,
      this.maxLength,this.enable,this.inputFormatter,this.onChanged,this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormatter,
          enabled: enable??true,
          controller: textEditingController,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 2,
                color: Color(0xFFECE7E4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompleteProfileSelectBox extends StatelessWidget {
  String title;
  List<String> list;
  String? hintText;
  dynamic Function(String?)? onChanged;
  CompleteProfileSelectBox({
    super.key,
    required this.list,
    this.hintText,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style:GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Theme(
          data: ThemeData.light(
            useMaterial3: true,
          ),
          child: CustomDropdown<String>(
            hintText: hintText,
            items: list,
            initialItem: list.first,
            onChanged: onChanged,
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(50),
              closedBorder: Border.all(
                color: const Color(0xFFECE7E4),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MultiSelectBox extends StatelessWidget {
  String title;
  List<String> list;
  String? hintText;
  List<String>? initialItems;
  Function(List<String>)? onListChanged;
  MultiSelectBox({
    super.key,
    required this.list,
    this.hintText,
    required this.title,
    this.onListChanged,
    this.initialItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Theme(
          data: ThemeData(
            useMaterial3: true,
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStatePropertyAll(AppColor.primary),
              overlayColor: MaterialStatePropertyAll(AppColor.primary),
              side: BorderSide(width: 1, color: AppColor.primary),
              fillColor: MaterialStatePropertyAll(Colors.white),
            ),
          ),
          child: CustomDropdown<String>.multiSelect(
            hintText: hintText,
            items: list,
            initialItems: this.initialItems,
            onListChanged: onListChanged,
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(50),
              closedBorder: Border.all(
                color: const Color(0xFFECE7E4),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchSelectBox extends StatelessWidget {
  String title;
  List<String> list;
  String? hintText;
  String? initialItem;
  Function(String)? onListChanged;
  SearchSelectBox({
    super.key,
    required this.list,
    this.hintText,
    required this.title,
    this.onListChanged,
    this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Theme(
          data: ThemeData(
            useMaterial3: true,
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStatePropertyAll(AppColor.primary),
              overlayColor: MaterialStatePropertyAll(AppColor.primary),
              side: BorderSide(width: 1, color: AppColor.primary),
              fillColor: MaterialStatePropertyAll(Colors.white),
            ),
          ),
          child: CustomDropdown<String>.search(
            hintText: hintText,
            items: list,
            initialItem: initialItem,
            onChanged: (e) {
              if (onListChanged != null) {
                onListChanged!(e!);
              }
            },
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(50),
              closedBorder: Border.all(
                color: const Color(0xFFECE7E4),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
