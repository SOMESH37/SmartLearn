import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartlearn/helper.dart';
import '../helper.dart';

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Draw(),
      appBar: AppBar(
        backgroundColor: colors[6],
        elevation: 0,
        iconTheme: IconThemeData(
          color: colors[5],
        ),
        // toolbarHeight: 80,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(50),
        //   ),
        //   side: BorderSide(width: 3, color: colors[6]),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ToDo',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: colors[7],
                //  fontSize: 40,
              ),
            ),
            // Text(
            //   '11 Tasks',
            //   style: TextStyle(
            //     color: colors[7],
            //     // fontSize: 18,
            //   ),
            // ),
          ],
        ),
      ),
      // backgroundColor: Colors.lightBlueAccent,
      backgroundColor: colors[6],
      body: false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    resourceHelper[7],
                    width: 250,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          'Nothing in ToDo list',
                          style: TextStyle(
                            color: colors[5],
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Text(
                        'Click + to create new note',
                        style: TextStyle(
                          color: colors[5],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    35,
                    20,
                    0,
                    10,
                  ),
                  child: Text(
                    '11 Tasks',
                    style: TextStyle(
                      color: colors[7],
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    //  padding: EdgeInsets.only(top: 30),
                    itemCount: 11,
                    itemBuilder: (context, index) => tileTodo(context, index),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          elevation: 4,
          backgroundColor: colors[6],
          child: Icon(
            Icons.add,
            color: Colors.blue,
            size: 40,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddToDo(),
              ),
            );
          }),
    );
  }
}

class AddToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colors[5],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title'),
                TextField(
                  onChanged: (value) {},
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                      color: colors[7],
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                        color: colors[5],
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z 0-9]'),
                    ),
                  ],
                ),
                TextField(
                  onChanged: (value) {},
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note',
                    hintStyle: TextStyle(
                      color: colors[5],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
