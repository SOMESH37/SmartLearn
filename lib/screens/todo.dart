import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartlearn/helper.dart';
import '../helper.dart';
import '../model/home_net.dart';
import 'package:provider/provider.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool isLoad = true;
  bool isLoadd = false;
  int rep = -20;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      rep = await Provider.of<DataAllClasses>(context, listen: false)
          .updateTodo(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    isLoad = true;
    isLoadd = false;
    rep = -20;
    super.dispose();
  }
  // void didChangeDependencies() {
  //   Provider.of<DataAllClasses>(context).updateTodo(context);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    if (rep > -10 && mounted) {
      if (rep > -2) {
        setState(() {
          isLoad = false;
        });
      } else {
        // showMyDialog(context, true, 'Can\'t refresh ToDo');
      }
    }
    return Scaffold(
      drawer: Container(
          constraints: BoxConstraints(
            minWidth: 310,
          ),
          child: Draw()),
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
      body: Column(
        children: [
          (isLoadd || isLoad)
              ? LinearProgressIndicator(
                  minHeight: 3,
                )
              : SizedBox(
                  height: 3,
                ),
          Provider.of<DataAllClasses>(context).mytodo.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          35,
                          17,
                          0,
                          8,
                        ),
                        child: Text(
                          '${Provider.of<DataAllClasses>(context).mytodo.length} Tasks',
                          style: TextStyle(
                            color: colors[7],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: Provider.of<DataAllClasses>(context)
                              .mytodo
                              .length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.fromLTRB(
                                    35,
                                    18,
                                    35,
                                    10,
                                  ),
                                  title: Text(
                                    '${Provider.of<DataAllClasses>(context).mytodo[index][1]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    Provider.of<DataAllClasses>(context)
                                            .mytodo[index][2] ??
                                        '',
                                    style: TextStyle(),
                                  ),
                                  trailing: PopupMenuButton(
                                    onSelected: (value) async {
                                      setState(() {
                                        isLoadd = true;
                                      });
                                      if (value == 0) {
                                        int res =
                                            await Provider.of<DataAllClasses>(
                                                    context,
                                                    listen: false)
                                                .deleteTodo(
                                                    context,
                                                    Provider.of<DataAllClasses>(
                                                            context,
                                                            listen: false)
                                                        .mytodo[index][0]);
                                        if (res > -10 && mounted) {
                                          setState(() {
                                            isLoadd = false;
                                          });
                                          if (res == 200)
                                            print('Deleted a todo');
                                          else
                                            showMyDialog(context, true,
                                                'Something went wrong');
                                        }
                                      } else
                                        print(value);
                                    },
                                    child: Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 0,
                                        height: 14,
                                        child: Text(
                                          'Delete',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  endIndent: 35,
                                  height: 0,
                                  thickness: 1,
                                  indent: 35,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  String title, des;
  bool isLoaded = false;

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
        padding: EdgeInsets.fromLTRB(30, 15, 30, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title'),
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
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
                  maxLines: null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z 0-9]'),
                    ),
                  ],
                ),
                TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(250),
                    FilteringTextInputFormatter.deny(
                      RegExp(
                          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                    ),
                  ],
                  onChanged: (value) {
                    des = value;
                  },
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
            isLoaded
                ? LinearProgressIndicator(
                    minHeight: 5,
                  )
                : Row(
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
                          onPressed: () async {
                            if (title == null || title.length < 1) {
                              HapticFeedback.mediumImpact();
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              isLoaded = true;
                            });
                            int res = await Provider.of<DataAllClasses>(context,
                                    listen: false)
                                .createTodo(context, title, des);
                            if (res > -10 && mounted) {
                              setState(() {
                                isLoaded = false;
                              });
                              if (res == 201) {
                                Navigator.pop(context);
                              } else
                                showMyDialog(
                                    context, true, 'Something went wrong');
                            }
                          },
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
