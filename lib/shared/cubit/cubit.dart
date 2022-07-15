// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, avoid_function_literals_in_foreach_calls, invalid_required_positional_param

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_first_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:flutter_first_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_first_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_first_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

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

  late Database todoDatabase;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() async {
    openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (Database todoDatabase, int version) {
        print('Database created');
        todoDatabase
            .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
            )
            .then((value) => print('Table created'))
            .catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (todoDatabase) async {
        print('Database opened');
        getDataFromDatabase(todoDatabase);
      },
    ).then((value) {
      todoDatabase = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    todoDatabase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(todoDatabase);
      }).catchError((error) {
        print('Error when inserting ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(todoDatabase) async {
    emit(AppGetDatabaseLoadingState());
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    todoDatabase.rawQuery('SELECT * FROM tasks').then((value) {
      print('From get $value');
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedTasks.add(element);
        }
      });
      print(newTasks);
      emit(AppGetDatabaseState());
    });
  }

  void updateDataFromDatabase({
    required String status,
    required int id,
  }) async {
    todoDatabase.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      print('$value updated successfully');
      getDataFromDatabase(todoDatabase);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDataFromDatabase({
    required int id,
  }) async {
    todoDatabase
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      print('$value deleted successfully');
      getDataFromDatabase(todoDatabase);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
