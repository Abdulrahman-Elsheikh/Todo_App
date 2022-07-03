// ignore_for_file: prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe, invalid_required_positional_param

import 'package:flutter/material.dart';
import 'package:flutter_first_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_first_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_first_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDataBase(
                titleController.text,
                timeController.text,
                dateController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet((context) {
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
                                    lastDate: DateTime.parse('2030-01-01'))
                                .then((value) {
                              dateController.text =
                                  DateFormat.yMMMd().format(value!);
                            });
                          }),
                    ],
                  ),
                ),
              );
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
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
  }
}

Future<String> getName() async {
  return 'Abdulrahman El-Sheikh Button';
}

void createDataBase() async {
  Database database = await openDatabase(
    'tasks.db',
    version: 1,
    onCreate: (Database database, int version) {
      print('Database created');
      database
          .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, Status TEXT)',
          )
          .then((value) => print('Table created'))
          .catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    },
    onOpen: (Database database) {
      print('Database opened');
    },
  );
}

Future insertToDataBase(
  @required String title,
  @required String date,
  @required String time,
) async {
  Database database = await openDatabase(
    'tasks.db',
    version: 1,
  );
  return await database.transaction((txn) async {
    txn
        .rawInsert(
            'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
        .then((value) {
      print('$value inserted successfully');
    }).catchError((error) {
      print('Error when inserting ${error.toString()}');
    });
  });
}
