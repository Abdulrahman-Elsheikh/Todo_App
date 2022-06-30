// ignore_for_file: avoid_print, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: Icon(
          Icons.menu,
        ),
        title: Text(
          'First App',
        ),
        actions: [
          IconButton(
            onPressed: (){
              print('Notification Clicked');
            },
            icon: Icon(
              Icons.notification_important,
            ),
          ),
          IconButton(
            onPressed: (){
              print('Search Clicked');
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
        centerTitle: true,
      ),
    );
  }
}
