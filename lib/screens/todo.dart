import 'package:flutter/material.dart';
import 'package:smartlearn/helper.dart';
import '../helper.dart';

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Draw(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(50),
        //   ),
        //   side: BorderSide(width: 3, color: colors[6]),
        // ),
        iconTheme: IconThemeData(
          color: colors[6],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ToDo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors[6],
                fontSize: 40,
              ),
            ),
            Text(
              '11 Tasks',
              style: TextStyle(
                color: colors[6],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 30),
          itemCount: 11,
          itemBuilder: (context, index) => tileTodo(context, index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () {}),
    );
  }
}
