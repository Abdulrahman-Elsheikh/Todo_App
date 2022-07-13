// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUppercase = true,
  double borderRadius = 0.0,
  double height = 50.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      // ignore: sort_child_properties_last
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUppercase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: background,
      ),
    );

Widget defaultTextField({
  double width = double.infinity,
  double height = 50.0,
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  required Function validate,
  required String hintText,
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit();
        }
      },
      onChanged: (String value) {
        if (onChange != null) {
          onChange(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return validate(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            if (suffixIcon != null) {
              suffixPressed!();
            }
          },
          icon: Icon(
            suffixIcon,
          ),
        ),
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        CircleAvatar(
          radius: 40.0,
          child: Text('${model['time']}'),
        ),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text('${model['title']}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            Text('${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      ]),
    );
