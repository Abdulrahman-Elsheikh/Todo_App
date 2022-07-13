// ignore_for_file: prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe, invalid_required_positional_param, unused_local_variable, prefer_is_empty, use_key_in_widget_constructors, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_first_app/shared/cubit/cubit.dart';
import 'package:flutter_first_app/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:flutter_first_app/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a title';
                                    }
                                    return null;
                                  },
                                  hintText: 'Task title',
                                  labelText: 'Task title',
                                  prefixIcon: Icons.title,
                                ),
                                SizedBox(height: 15.0),
                                defaultTextField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a time';
                                      }
                                      return null;
                                    },
                                    hintText: 'Task Time',
                                    labelText: 'Task Time',
                                    prefixIcon: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    }),
                                SizedBox(height: 15.0),
                                defaultTextField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a date';
                                      }
                                      return null;
                                    },
                                    hintText: 'Task Date',
                                    labelText: 'Task Date',
                                    prefixIcon: Icons.calendar_today_outlined,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2030-01-01'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    }),
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(
                          isShown: false,
                          icon: Icons.edit,
                        );
                      });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeIndex(index);
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
