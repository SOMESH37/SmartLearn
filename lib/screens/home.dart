import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../helper.dart';
import 'package:provider/provider.dart';
import '../model/home_net.dart';
import '../model/auth_net.dart';
import 'package:date_format/date_format.dart';

var gapH, gapW;
bool isStd;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoadd = true;
  int rep = -20;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      rep = await Provider.of<DataAllClasses>(context, listen: false)
          .updateClass(context);
      isStd = await Provider.of<Auth>(context, listen: false).data[0][2];
    });
    super.initState();
  }

  @override
  void dispose() {
    isLoadd = true;
    rep = -20;
    super.dispose();
  }

  // void didChangeDependencies()  {
  //    Provider.of<DataAllClasses>(context).updateClass(context);
  //   super.didChangeDependencies();
  // }
  @override
  Widget build(BuildContext context) {
    if (rep > -10 && mounted) {
      if (rep > -2) {
        setState(() {
          isLoadd = false;
        });
      } else {
        // showMyDialog(context, true, 'Something went wrong');
      }
    }
    var deviceSize = MediaQuery.of(context).size;
    gapH = deviceSize.height;
    gapW = deviceSize.width;
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),
      home: Scaffold(
        drawer: Container(
            constraints: BoxConstraints(
              minWidth: 310,
            ),
            child: Draw()),
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(
            color: colors[5],
          ),
          backgroundColor: colors[6],
          // title: Text(
          //   kSL,
          //   style: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Noti(),
                        ),
                      );
                    },
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: CircleAvatar(
                  //     radius: 14,
                  //     backgroundColor: Colors.white,
                  //     backgroundImage: AssetImage(resourceHelper[2]),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            isLoadd
                ? LinearProgressIndicator(
                    minHeight: 3,
                  )
                : SizedBox(
                    height: 3,
                  ),
            Provider.of<DataAllClasses>(context).myclasses.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            resourceHelper[6],
                            width: 250,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  'Not enrolled in any class',
                                  style: TextStyle(
                                    color: colors[5],
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Text(
                                Provider.of<Auth>(context).data[0][2]
                                    ? 'Click + to Join new class'
                                    : 'Click + to Create new class',
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
                : Expanded(child: ClassColumn())
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            isStd
                ? joinBox(context)
                : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Create(),
                    ),
                  );
          },
          child: Icon(
            Icons.add,
            color: Colors.blue,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class ClassColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 9),
            itemCount: Provider.of<DataAllClasses>(context).myclasses.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  color: colors[index % 5][0],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: colors[index % 5][1],
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image.asset(
                        resourceHelper[index % 3 + 3],
                        width: 200,
                        color: Colors.white54,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 150,
                        ),
                        child: ListTile(
                          enabled: true,
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 55),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyClass(
                                    Provider.of<DataAllClasses>(context)
                                        .myclasses[index][0],
                                    colors[index % 5][0],
                                    Provider.of<DataAllClasses>(context)
                                        .myclasses[index][5]),
                              ),
                            );
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 6,
                            ),
                            child: Text(
                              '${Provider.of<DataAllClasses>(context).myclasses[index][0]}',
                              style: TextStyle(
                                color: colors[6],
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            '${Provider.of<DataAllClasses>(context).myclasses[index][1]}',
                            style: TextStyle(
                              color: colors[6],
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: Provider.of<DataAllClasses>(
                                                context)
                                            .myclasses[index][3] ==
                                        null
                                    ? AssetImage(resourceHelper[2])
                                    : NetworkImage(
                                        '${Provider.of<DataAllClasses>(context).myclasses[index][3]}'),
                              ),
                              // Text(
                              //   '${Provider.of<DataAllClasses>(context).myclasses[index][2]}',
                              //   style: TextStyle(
                              //     color: colors[6],
                              //     fontSize: 12,
                              //   ),
                              //   overflow: TextOverflow.ellipsis,
                              //   maxLines: null,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyClass extends StatefulWidget {
  final String mytitle;
  final Color colour;
  final int classID;
  MyClass(this.mytitle, this.colour, this.classID);

  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  int rep1 = -20;
  @override
  void initState() {
    Provider.of<DataAllClasses>(context, listen: false).assign.clear();
    Future.delayed(Duration.zero, () async {
      rep1 = await Provider.of<DataAllClasses>(context, listen: false)
          .updateAssign(context, widget.classID);
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.vertical(
            //     bottom: Radius.circular(50),
            //   ),
            // ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    widget.mytitle,
                    style: TextStyle(),
                  ),
                ),
                // Text(
                //   'Total students: 39',
                //   style: TextStyle(
                //     fontSize: 12,
                //   ),
                // ),
              ],
            ),
            backgroundColor: widget.colour,
            elevation: 6,
            leadingWidth: 50,
            titleSpacing: 0,
            toolbarHeight: 120,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Info(widget.colour),
                      ),
                    );
                  },
                  color: Colors.white,
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: colors[6],
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: 'Discuss',
                  // icon: Icon(Icons.chat),
                ),
                Tab(
                  //   icon: Icon(Icons.class_),
                  text: 'Assignments',
                ),
                Tab(
                  //  icon: Icon(Icons.school),
                  text: 'Grades',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Discuss(),
              Work(widget.classID),
              Grades(),
            ],
          ),
        );
      }),
    );
  }
}

class Discuss extends StatelessWidget {
  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        itemBuilder: (context, index) => tileDiscuss(context, index),
        itemCount: 15,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.chat_bubble,
          color: Colors.blue,
          size: 25,
        ),
      ),
    );
  }
}

class Work extends StatefulWidget {
  final int classID;
  Work(this.classID);
  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends State<Work> {
  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        itemCount: Provider.of<DataAllClasses>(context).assign.length,
        itemBuilder: (context, index) =>
            tileWork(context, index, widget.classID),
      ),
      floatingActionButton: isStd
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateWork(widget.classID),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.blue,
                size: 40,
              ),
            ),
    );
  }
}

class Grades extends StatelessWidget {
  @override
  Widget build(BuildContext cxt) {
    return Center(
      child: Text(
          'Efficiently mesh strategic collaboration and idea-sharing whereas standards compliant ideas. Globally negotiate installed base information through superior collaboration and idea-sharing.'),
    );
  }
}

class Noti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colors[5],
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: colors[7],
          ),
        ),
        titleSpacing: 0,
        backgroundColor: colors[6],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        itemBuilder: (context, index) => tileNoti(context, index),
        itemCount: 20,
      ),
    );
  }
}

class Info extends StatelessWidget {
  Color colour;
  Info(this.colour);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Information',
              style: TextStyle(
                color: colors[6],
                fontSize: 22,
              ),
            ),
            Divider(
              color: colors[6],
              thickness: 0.5,
              height: 12,
              endIndent: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total students:',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text('39'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Class code:',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text('8xbj39'),
                ],
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: colour,
        toolbarHeight: 120,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    30,
                    8,
                    15,
                    8,
                  ),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(resourceHelper[2]),
                  ),
                ),
                Text(
                  'Teacher\'s Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Flexible(
          //   child: ListView.builder(
          //     padding: EdgeInsets.symmetric(
          //       vertical: 2,
          //       horizontal: 30,
          //     ),
          //     itemBuilder: (context, index) => tileInfo(context, index),
          //     itemCount: 39,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String sub, des;
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create new class',
          style: TextStyle(
            color: colors[7],
          ),
        ),
        backgroundColor: colors[6],
        iconTheme: IconThemeData(
          color: colors[7],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
            ),
            TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(45),
                FilteringTextInputFormatter.deny(
                  RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Subject name',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
              onChanged: (value) {
                sub = value;
              },
            ),
            TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(295),
                FilteringTextInputFormatter.deny(
                  RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
              onChanged: (value) {
                des = value;
              },
              maxLines: null,
            ),
            SizedBox(
              height: 50,
            ),
            isLoad
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        onPressed: () async {
                          if (sub == null ||
                              des == null ||
                              des.length < 1 ||
                              sub.length < 1) {
                            HapticFeedback.heavyImpact();
                            return;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            isLoad = true;
                          });
                          int res = await Provider.of<DataAllClasses>(context,
                                  listen: false)
                              .createClass(context, sub, des);
                          if (res > -10 && mounted) {
                            setState(() {
                              isLoad = false;
                            });
                            if (res == 201) {
                              Navigator.pop(context);
                            } else
                              showMyDialog(
                                  context, false, 'Something went wrong');
                            //ERROR DIALOG res==-1 -> something went wrong
                          }
                        },
                        child: Text(
                          'Create',
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
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

joinBox(BuildContext context) async {
  bool isL = false;
  String code, error;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, reset) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(30, 25, 30, 25),
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            buttonPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            title: Text('Join class'),
            content: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(
                  RegExp('[a-zA-Z0-9]'),
                ),
              ],
              decoration: InputDecoration(
                hintText: 'Enter class code',
                errorText: error,
              ),
              onChanged: (value) {
                code = value;
                if (error != null)
                  reset(() {
                    error = null;
                  });
              },
            ),
            actions: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: double.maxFinite,
                ),
                child: isL
                    ? Column(
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          LinearProgressIndicator(
                            minHeight: 6,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            padding: EdgeInsets.only(right: 10),
                            splashColor: Colors.transparent,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: colors[7],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            padding: EdgeInsets.only(right: 30),
                            splashColor: Colors.transparent,
                            child: Text(
                              'Join',
                              style: TextStyle(
                                color: colors[7],
                              ),
                            ),
                            onPressed: () async {
                              if (code == null ||
                                  code.length < 1 ||
                                  error != null) {
                                HapticFeedback.mediumImpact();
                                return;
                              }
                              reset(() {
                                isL = true;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                              int res = await Provider.of<DataAllClasses>(
                                      context,
                                      listen: false)
                                  .joinClass(context, code);
                              if (res > -10) {
                                reset(() {
                                  isL = false;
                                });
                                if (res == 201)
                                  Navigator.pop(context);
                                else if (res == 400) {
                                  reset(() {
                                    error = 'Wrong class code';
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}

tileWork(context, int index, int classID) {
  var diff = DateTime.now().difference(
      DateTime.parse(Provider.of<DataAllClasses>(context).assign[index][3])
          .subtract(Duration(minutes: 330)));
  return Container(
    constraints: BoxConstraints(
      minHeight: 124,
    ),
    margin: EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colors[7],
          width: 0.1,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  isStd ? UploadWork() : ViewWork(classID, index),
            ),
          );
        },
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        title: Text(
          '${Provider.of<DataAllClasses>(context).assign[index][1]}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.watch_later_rounded,
            color: diff.inHours < -2
                ? Color(0xff08bd80)
                : diff.inSeconds <= 0 ? Colors.redAccent : Colors.transparent),
        subtitle: Column(
          children: [
            Divider(
              thickness: 1,
              height: 25,
            ),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatDate(
                    DateTime.parse(
                        Provider.of<DataAllClasses>(context).assign[index][3]),
                    [h, ':', nn, ' ', am, ' - ', d, '/', M, '/', yy])),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class CreateWork extends StatefulWidget {
  final int classID;
  CreateWork(this.classID);
  @override
  _CreateWorkState createState() => _CreateWorkState();
}

class _CreateWorkState extends State<CreateWork> {
  var title, des, now, maxMarks, file;
  DateTime date = DateTime.now().add(Duration(days: 1));
  TimeOfDay time = TimeOfDay(hour: 6, minute: 0);
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isLoad,
        title: Text(
          'Create new assignment',
          style: TextStyle(
            color: colors[7],
          ),
        ),
        backgroundColor: colors[6],
        iconTheme: IconThemeData(
          color: colors[7],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: IgnorePointer(
            ignoring: isLoad,
            child: Column(
              children: [
                isLoad
                    ? LinearProgressIndicator(
                        minHeight: 5,
                      )
                    : SizedBox(
                        height: 5,
                      ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Details:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            title = value;
                          },
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            color: colors[7],
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: colors[7],
                            ),
                            hintText: 'Assignment name',
                            hintStyle: TextStyle(
                              color: colors[5],
                            ),
                          ),
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ],
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          des = value;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: colors[7],
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            color: colors[7],
                          ),
                          hintText: 'Assignment details',
                          hintStyle: TextStyle(
                            color: colors[5],
                          ),
                        ),
                        maxLines: null,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: TextField(
                                onChanged: (value) {
                                  maxMarks = double.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: colors[7],
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Max marks',
                                  labelStyle: TextStyle(
                                    color: colors[7],
                                  ),
                                  hintText: '100',
                                  hintStyle: TextStyle(
                                    color: colors[5],
                                  ),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              child: Text(now != null
                                  ? formatDate(now, [
                                      h,
                                      ':',
                                      nn,
                                      ' ',
                                      am,
                                      ' - ',
                                      d,
                                      '/',
                                      M,
                                      '/',
                                      yy
                                    ])
                                  : ''),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: date ?? DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 99)));
                                if (date != null && time != null)
                                  setState(() {
                                    now = DateTime(date.year, date.month,
                                        date.day, time.hour, time.minute);
                                  });
                              },
                              child: Text(
                                'Choose date',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                time = await showTimePicker(
                                  initialTime: time ?? TimeOfDay.now(),
                                  context: context,
                                );
                                if (time != null && date != null)
                                  setState(() {
                                    now = DateTime(date.year, date.month,
                                        date.day, time.hour, time.minute);
                                  });
                              },
                              child: Text(
                                'Choose time',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: (gapH - 530)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 4),
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Text(
                            '+ Select file',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              width: 0.75,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          onPressed: () async {
                            if (title == null ||
                                des == null ||
                                now == null ||
                                maxMarks == null ||
                                maxMarks < 1 ||
                                des.length < 1 ||
                                title.length < 1) {
                              HapticFeedback.mediumImpact();
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              isLoad = true;
                            });
                            int res = await Provider.of<DataAllClasses>(context,
                                    listen: false)
                                .createAssign(context, widget.classID, title,
                                    des, now, maxMarks, file);
                            if (res > -10 && mounted) {
                              setState(() {
                                isLoad = false;
                              });
                              if (res == 201) {
                                Navigator.pop(context);
                              } else
                                showMyDialog(
                                    context, true, 'Something went wrong');
                            }
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewWork extends StatefulWidget {
  final int classID, idx;
  ViewWork(this.classID, this.idx);

  @override
  _ViewWorkState createState() => _ViewWorkState();
}

class _ViewWorkState extends State<ViewWork> {
  int res = -20;
  bool isLoad = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      Provider.of<DataAllClasses>(context, listen: false).ans.clear();
      res = await Provider.of<DataAllClasses>(context, listen: false)
          .viewAllAss(
              context,
              widget.classID,
              Provider.of<DataAllClasses>(context, listen: false)
                  .assign[widget.idx][0]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (res > -10 && mounted) {
      if (res > -2) {
        setState(() {
          isLoad = false;
        });
      } else {
        // showMyDialog(context, true, 'Something went wrong');
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Provider.of<DataAllClasses>(context).assign[widget.idx][1]}',
          style: TextStyle(
            color: colors[7],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors[6],
        iconTheme: IconThemeData(color: colors[5]),
        bottom: isLoad
            ? PreferredSize(
                child: LinearProgressIndicator(minHeight: 3),
                preferredSize: Size(double.infinity, 3),
              )
            : PreferredSize(
                child: SizedBox(height: 3),
                preferredSize: Size(double.infinity, 3),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Provider.of<DataAllClasses>(context).assign[widget.idx][2]}',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    'Due: ' +
                        formatDate(
                            DateTime.parse(Provider.of<DataAllClasses>(context)
                                .assign[widget.idx][3]),
                            [h, ':', nn, ' ', am, ' - ', d, '/', M, '/', yy]),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                Text(
                  '${Provider.of<DataAllClasses>(context).assign[widget.idx][4]} Maximum marks',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 4),
                  child: Text(
                    'Attachment:',
                    style: TextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: colors[5],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              color: colors[5],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                Provider.of<DataAllClasses>(context)
                                        .assign[widget.idx][5]
                                        .toString()
                                        .contains('assignment')
                                    ? Provider.of<DataAllClasses>(context)
                                        .assign[widget.idx][5]
                                        .toString()
                                        .substring(52)
                                    : '',
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                        FlatButton(
                          padding: EdgeInsets.zero,
                          minWidth: 0,
                          splashColor: Colors.transparent,
                          onPressed: () {},
                          child: Text(
                            'View',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 25,
                    thickness: 1.7,
                  ),
                ],
              ),
            ),
            isLoad || Provider.of<DataAllClasses>(context).ans.length < 1
                ? Container(
                    constraints: BoxConstraints(minHeight: gapH * 0.45),
                    width: double.infinity,
                    child: Center(
                      child: Image.asset(
                        resourceHelper[6],
                        width: 200,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: Provider.of<DataAllClasses>(context).ans.length,
                    itemBuilder: (context, index) => tileInfo(
                        context,
                        index,
                        widget.classID,
                        Provider.of<DataAllClasses>(context, listen: false)
                            .assign[widget.idx][0]),
                  ),
          ],
        ),
      ),
    );
  }
}

tileInfo(context, index, classID, assID) {
  return GestureDetector(
    onTap: () {
      updateMark(context, index, classID, assID,
          Provider.of<DataAllClasses>(context, listen: false).ans[index][0]);
    },
    behavior: HitTestBehavior.translucent,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                    right: 15,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: Provider.of<DataAllClasses>(context)
                                .ans[index][6] ==
                            null
                        ? AssetImage(resourceHelper[2])
                        : NetworkImage(
                            '${Provider.of<DataAllClasses>(context).ans[index][6]}'),
                  ),
                ),
                Text('${Provider.of<DataAllClasses>(context).ans[index][5]}'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(Provider.of<DataAllClasses>(context).ans[index][4]
                  ? '${Provider.of<DataAllClasses>(context).ans[index][2]}'
                  : 'Unchecked'),
            ),
          ],
        ),
        Divider(
          height: 25,
          indent: 15,
          thickness: 0.7,
        ),
      ],
    ),
  );
}

updateMark(BuildContext context, idx, classID, assID, ansID) async {
  bool isL = false;
  int marks;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, reset) {
          return AlertDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            buttonPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            contentPadding: EdgeInsets.fromLTRB(30, 25, 30, 25),
            // insetPadding: EdgeInsets.symmetric(vertical: gapH * 0.3),
            // actionsPadding: EdgeInsets.zero,
            title: Text('Student name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            content: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: colors[5],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            color: colors[5],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              Provider.of<DataAllClasses>(context)
                                      .ans[idx][1]
                                      .toString()
                                      .contains('answers')
                                  ? Provider.of<DataAllClasses>(context)
                                      .ans[idx][1]
                                      .toString()
                                      .substring(49)
                                  : '',
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                      FlatButton(
                        padding: EdgeInsets.zero,
                        minWidth: 0,
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        child: Text(
                          'View',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Marks obtained',
                  ),
                  onChanged: (value) {
                    marks = int.parse(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submission:',
                    ),
                    Text(
                      Provider.of<DataAllClasses>(context).ans[idx][3]
                          ? 'Late'
                          : 'On time',
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: double.maxFinite,
                ),
                child: isL
                    ? Column(
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          LinearProgressIndicator(
                            minHeight: 6,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            padding: EdgeInsets.only(right: 10),
                            splashColor: Colors.transparent,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: colors[7],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: colors[6],
                              ),
                            ),
                            onPressed: () async {
                              if (marks == null || marks < 1) {
                                HapticFeedback.mediumImpact();
                                return;
                              }
                              reset(() {
                                isL = true;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                              int res = await Provider.of<DataAllClasses>(
                                      context,
                                      listen: false)
                                  .updateMarks(
                                      context, marks, classID, assID, ansID);
                              if (res > -10) {
                                reset(() {
                                  isL = false;
                                });
                                if (res == 200)
                                  Navigator.pop(context);
                                else {
                                  showMyDialog(
                                      context, true, 'Something went wrong');
                                }
                              }
                            },
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}

class UploadWork extends StatefulWidget {
  @override
  _UploadWorkState createState() => _UploadWorkState();
}

class _UploadWorkState extends State<UploadWork> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('upload'),
    );
  }
}
