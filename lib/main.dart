// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/shared/bloc_observer.dart';
import 'layout/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      // Use blocs...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
