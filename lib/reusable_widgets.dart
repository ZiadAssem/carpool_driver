// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:flutter/material.dart';

//text form field
Widget reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    [validator, bool showPassword = true]) {
  return SizedBox(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Colors.transparent,
      elevation: 10,
      child: Expanded(
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: !showPassword,
          enableSuggestions: !isPasswordType,
          autocorrect: !isPasswordType,
          style: TextStyle(color: Colors.black.withOpacity(0.9)),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color.fromARGB(255, 142, 15, 6),
            ),
            labelText: text,
            labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          keyboardType: isPasswordType
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
        ),
      ),
    ),
  );
}

Container resuableButton(
    BuildContext context, String title,double width, Function() onTap) {
  return Container(
    width: width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 142, 15, 6)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

PreferredSizeWidget reusableAppBar(
  title,
// TabBar
) {
  return AppBar(
    title: Text('$title'),
    backgroundColor:
        const Color.fromARGB(255, 142, 15, 6), // Change app bar color
    // bottom:TabBar,
  );
}

Color reusableColor() {
  return const Color.fromARGB(255, 142, 15, 6);
}


