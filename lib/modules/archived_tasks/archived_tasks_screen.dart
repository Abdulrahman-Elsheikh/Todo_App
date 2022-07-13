// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_first_app/shared/components/components.dart';
import 'package:flutter_first_app/shared/cubit/cubit.dart';
import 'package:flutter_first_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var archivedTasks = AppCubit.get(context).archivedTasks;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return tasksBuilder(tasks: archivedTasks);
      },
    );
  }
}
