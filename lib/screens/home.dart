import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import '../helper.dart';
import 'package:provider/provider.dart';
import '../model/home_net.dart';
import '../model/auth_net.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
        drawer: Draw(),
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
                    icon: Provider.of<DataAllClasses>(context).newNoti
                        ? Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.red[400],
                          )
                        : Icon(
                            Icons.notifications_none,
                            color: Colors.grey,
                          ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Noti(),
                        ),
                      );
                      setState(() {
                        Provider.of<DataAllClasses>(context, listen: false)
                            .newNoti = false;
                      });
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
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<DataAllClasses>(context, listen: false)
            .updateClass(context);
      },
      child: ListView.builder(
        // physics: BouncingScrollPhysics(),
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
                    color: Colors.white38,
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
                                    .myclasses[index][5],
                                index),
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
    );
  }
}

class MyClass extends StatefulWidget {
  final String mytitle;
  final Color colour;
  final int classID, index;
  MyClass(this.mytitle, this.colour, this.classID, this.index);

  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  int rep1 = -20, rep2 = -20, rep3 = -20;
  bool isL = true;
  @override
  void initState() {
    Provider.of<DataAllClasses>(context, listen: false).assign.clear();
    Provider.of<DataAllClasses>(context, listen: false).mydis.clear();
    Provider.of<DataAllClasses>(context, listen: false).grades.clear();
    Future.delayed(Duration.zero, () async {
      rep2 = await Provider.of<DataAllClasses>(context, listen: false)
          .updateDiscuss(context, widget.classID);
      rep1 = await Provider.of<DataAllClasses>(context, listen: false)
          .updateAssign(context, widget.classID);
      if (isStd)
        rep3 = await Provider.of<DataAllClasses>(context, listen: false)
            .grade(context, widget.classID);
      else
        rep3 = await Provider.of<DataAllClasses>(context, listen: false)
            .allGrades(context, widget.classID);
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (rep1 > -10 && rep2 > -10 && mounted) {
      if (rep1 > -2 && rep2 > -2) {
        setState(() {
          isL = false;
        });
      } else {
        // showMyDialog(context, true, 'Something went wrong');
      }
    }
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
              ],
            ),
            backgroundColor: widget.colour,
            elevation: 6,
            leadingWidth: 50,
            titleSpacing: 0,
            toolbarHeight: 120,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 35),
                child: isL
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.7,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(colors[6]),
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                buttonPadding: EdgeInsets.all(15),
                                content: Wrap(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                backgroundImage: Provider.of<
                                                                        DataAllClasses>(
                                                                    context)
                                                                .myclasses[
                                                            widget.index][3] ==
                                                        null
                                                    ? AssetImage(
                                                        resourceHelper[2])
                                                    : NetworkImage(
                                                        '${Provider.of<DataAllClasses>(context).myclasses[widget.index][3]}'),
                                              ),
                                            ),
                                            Text(
                                                '${Provider.of<DataAllClasses>(context).myclasses[widget.index][2]}'),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 13),
                                          child: Text(
                                            '${Provider.of<DataAllClasses>(context).myclasses[widget.index][4]}',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 50,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                            'Total students: ${Provider.of<DataAllClasses>(context).myclasses[widget.index][6]}'),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
              rep2 < -10
                  ? Center(
                      child: Image.asset(
                        resourceHelper[8],
                        width: 200,
                      ),
                    )
                  : Discuss(widget.classID, widget.colour),
              rep1 < -10
                  ? Center(
                      child: Image.asset(
                        resourceHelper[8],
                        width: 200,
                      ),
                    )
                  : Work(widget.classID, widget.colour),
              rep3 < -10
                  ? Center(
                      child: Image.asset(
                        resourceHelper[8],
                        width: 200,
                      ),
                    )
                  : isStd
                      ? Grades(widget.colour, widget.classID)
                      : AllGrades(widget.colour, widget.classID),
            ],
          ),
        );
      }),
    );
  }
}

class Discuss extends StatelessWidget {
  final int classID;
  final Color col;
  Discuss(this.classID, this.col);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Provider.of<DataAllClasses>(context).mydis.isEmpty
            ? Center(
                child: Image.asset(
                  resourceHelper[8],
                  width: 200,
                ),
              )
            : RefreshIndicator(
                color: col,
                onRefresh: () async {
                  Provider.of<DataAllClasses>(context, listen: false)
                      .updateDiscuss(context, classID);
                },
                child: ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) =>
                      tileDiscuss(context, index, classID),
                  itemCount: Provider.of<DataAllClasses>(context).mydis.length,
                ),
              ),
        backgroundColor: Provider.of<DataAllClasses>(context).mydis.isEmpty
            ? null
            : Colors.blueGrey[50],
        floatingActionButton: FloatingActionButton(
          backgroundColor: colors[6],
          onPressed: () {
            bool isLoad = false;
            var dis;
            showBottomSheet(
              context: context,
              builder: (ctext) {
                return StatefulBuilder(
                  builder: (cxt, reSet) {
                    return Wrap(
                      spacing: 0,
                      children: [
                        if (isLoad)
                          LinearProgressIndicator(
                            minHeight: 6,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  scrollPadding: EdgeInsets.zero,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 4,
                                  autofocus: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(800),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(
                                          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    dis = value;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.send_sharp),
                                iconSize: 35,
                                color: Colors.blue,
                                onPressed: isLoad
                                    ? null
                                    : () async {
                                        if (dis == null || dis.length < 1) {
                                          HapticFeedback.mediumImpact();
                                          return;
                                        }
                                        FocusScope.of(cxt)
                                            .requestFocus(FocusNode());
                                        reSet(() {
                                          isLoad = true;
                                        });
                                        int res =
                                            await Provider.of<DataAllClasses>(
                                                    context,
                                                    listen: false)
                                                .discuss(context, dis, classID);
                                        if (res > -10) {
                                          reSet(() {
                                            isLoad = false;
                                          });
                                          if (res == 200) {
                                            Navigator.pop(ctext);
                                          } else if (res == 201) {
                                            Provider.of<DataAllClasses>(context)
                                                .updateDiscuss(
                                                    context, classID);
                                            Navigator.pop(ctext);
                                          } else {
                                            showMyDialog(context, false,
                                                'Something went wrong');
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
              backgroundColor: Colors.white,
              elevation: double.infinity,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
            );
          },
          child: Icon(
            Icons.chat_bubble,
            color: col,
            size: 25,
          ),
        ));
  }
}

tileDiscuss(context, int index, int classID) {
  bool me = Provider.of<DataAllClasses>(context).mydis[index][5];
  return Container(
    constraints: BoxConstraints(
      minHeight: 120,
    ),
    margin: EdgeInsets.only(left: me ? 20 : 0, right: me ? 0 : 20),
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(me ? 20 : 0),
            topRight: Radius.circular(me ? 0 : 20)),
        side: BorderSide(
          color: colors[7],
          width: 0.1,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        onLongPress: me
            ? () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (cxt) {
                    return AlertDialog(
                      buttonPadding: EdgeInsets.all(15),
                      title: Text('Make your choice'),
                      content: SingleChildScrollView(
                        child: Text('Do you want to delete your chat?'),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            Navigator.of(cxt).pop();
                            Fluttertoast.showToast(
                              msg: 'Your request has been send!',
                            );
                            int res = await Provider.of<DataAllClasses>(context,
                                    listen: false)
                                .deleteDiscuss(
                                    context,
                                    classID,
                                    Provider.of<DataAllClasses>(context,
                                            listen: false)
                                        .mydis[index][4]);
                            if (res == 200)
                              Fluttertoast.showToast(
                                msg: 'Nobody can know your secret :)',
                              );
                            else if (res == 202)
                              Provider.of<DataAllClasses>(context,
                                      listen: false)
                                  .updateDiscuss(context, classID);
                            else
                              Fluttertoast.showToast(
                                msg: 'Sorry, can\'t establish a connection.',
                              );
                          },
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            'Delete',
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
                    );
                  },
                );
              }
            : null,
        title: Column(
          children: [
            Row(
              mainAxisAlignment:
                  me ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    backgroundImage: Provider.of<DataAllClasses>(context)
                                .mydis[index][3] ==
                            null
                        ? AssetImage(resourceHelper[2])
                        : NetworkImage(
                            '${Provider.of<DataAllClasses>(context).mydis[index][3]}'),
                  ),
                ),
                Text(
                  '${Provider.of<DataAllClasses>(context).mydis[index][2]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                mainAxisAlignment:
                    me ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    formatDate(
                      DateTime.parse(Provider.of<DataAllClasses>(context)
                              .mydis[index][0])
                          .toLocal(),
                      [h, ':', nn, ' ', am, ' - ', d, '/', M, '/', yy],
                    ),
                    style: TextStyle(color: colors[5], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 1,
              height: 18,
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                      '${Provider.of<DataAllClasses>(context).mydis[index][1]}'),
                ),
                // Icon(Icons.chat),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class Work extends StatefulWidget {
  final int classID;
  final Color col;
  Work(this.classID, this.col);
  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends State<Work> {
  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      body: Provider.of<DataAllClasses>(context).assign.isEmpty
          ? Center(
              child: Image.asset(
                resourceHelper[8],
                width: 200,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                Provider.of<DataAllClasses>(context, listen: false)
                    .updateAssign(context, widget.classID);
              },
              color: widget.col,
              child: ListView.builder(
                // physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                itemCount: Provider.of<DataAllClasses>(context).assign.length,
                itemBuilder: (context, index) =>
                    tileWork(context, index, widget.classID),
              ),
            ),
      floatingActionButton: isStd
          ? null
          : FloatingActionButton(
              backgroundColor: colors[6],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateWork(widget.classID),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: widget.col,
                size: 40,
              ),
            ),
    );
  }
}

class AllGrades extends StatelessWidget {
  final Color col;
  final int classID;
  AllGrades(this.col, this.classID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<DataAllClasses>(context).grades.isEmpty
          ? Center(
              child: Image.asset(
                resourceHelper[8],
                width: 200,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                Provider.of<DataAllClasses>(context, listen: false)
                    .allGrades(context, classID);
              },
              color: col,
              child: ListView.builder(
                // physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 12),
                itemCount: Provider.of<DataAllClasses>(context).grades.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              // backgroundColor: Color(0xbf08BD80),
                              // valueColor:
                              //     AlwaysStoppedAnimation(Colors.greenAccent[300]),
                              value: Provider.of<DataAllClasses>(context)
                                      .grades[index][1] /
                                  100,
                              minHeight: 32,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    backgroundImage: Provider.of<
                                                    DataAllClasses>(context)
                                                .grades[index][2] ==
                                            null
                                        ? AssetImage(resourceHelper[2])
                                        : NetworkImage(
                                            '${Provider.of<DataAllClasses>(context).grades[index][2]}'),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Text(
                                        '${Provider.of<DataAllClasses>(context).grades[index][0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 18),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                  '${Provider.of<DataAllClasses>(context).grades[index][1]}%'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class Grades extends StatelessWidget {
  final Color col;
  final int classID;
  Grades(this.col, this.classID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<DataAllClasses>(context).grades.length < 2
          ? Center(
              child: Image.asset(
                resourceHelper[8],
                width: 200,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                Provider.of<DataAllClasses>(context, listen: false)
                    .grade(context, classID);
              },
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.lightBlue[100],
                        // valueColor: AlwaysStoppedAnimation(Colors.green[300]),
                        value: Provider.of<DataAllClasses>(context).grades[0] /
                            100,
                        minHeight: gapH * 0.07,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            'Total: ${Provider.of<DataAllClasses>(context).grades[0]}%',
                            style: TextStyle(
                                color: colors[6],
                                fontSize: gapH * 0.028,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Assignment',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        Text('Marks'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      // physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      itemCount:
                          Provider.of<DataAllClasses>(context).grades.length -
                              1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                '${Provider.of<DataAllClasses>(context).grades[index + 1][0]}',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                            Text(
                                              formatDate(
                                                  DateTime.parse(Provider.of<
                                                              DataAllClasses>(
                                                          context)
                                                      .grades[index + 1][5]),
                                                  [
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
                                                  ]),
                                              style: TextStyle(
                                                color: colors[5],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    !Provider.of<DataAllClasses>(context)
                                            .grades[index + 1][2]
                                        ? Text(
                                            'Not sumitted',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Provider.of<DataAllClasses>(context)
                                                .grades[index + 1][3]
                                            ? Text(
                                                '${Provider.of<DataAllClasses>(context).grades[index + 1][4]}/${Provider.of<DataAllClasses>(context).grades[index + 1][1]}',
                                              )
                                            : Text(
                                                'Unchecked',
                                                style: TextStyle(
                                                    // color: Colors.yellow[800]
                                                    ),
                                              ),
                                    !Provider.of<DataAllClasses>(context)
                                            .grades[index + 1][2]
                                        ? Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.red,
                                          )
                                        : Provider.of<DataAllClasses>(context)
                                                .grades[index + 1][3]
                                            ? Icon(Icons.check_circle,
                                                color: Colors.blue)
                                            : Icon(
                                                Icons.info,
                                                color: Colors.yellow[700],
                                              ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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
      body: Provider.of<DataAllClasses>(context).notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 200,
                    color: colors[5],
                  ),
                  Text(
                    'No recent activity!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              itemBuilder: (context, index) => tileNoti(context, index),
              itemCount:
                  Provider.of<DataAllClasses>(context).notifications.length,
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
                            if (res == 200) {
                              Navigator.pop(context);
                            } else if (res == 201) {
                              Provider.of<DataAllClasses>(context)
                                  .updateClass(context);
                              Navigator.pop(context);
                            } else
                              showMyDialog(
                                  context, false, 'Something went wrong');
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
                                if (res == 200)
                                  Navigator.pop(context);
                                else if (res == 201) {
                                  Navigator.pop(context);
                                  Provider.of<DataAllClasses>(context)
                                      .updateClass(context);
                                } else if (res == 400) {
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
              builder: (context) => isStd
                  ? UploadWork(
                      classID,
                      index,
                      (Provider.of<DataAllClasses>(context).assign[index][6] ==
                                  null ||
                              Provider.of<DataAllClasses>(context).assign[index]
                                      [6] ==
                                  false)
                          ? false
                          : true)
                  : ViewWork(classID, index),
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
  File pickedPDF;
  String pName;
  int pSize;
  var title, des, now, maxMarks;
  DateTime date = DateTime.now().add(Duration(days: 1));
  TimeOfDay time = TimeOfDay(hour: 21, minute: 0);
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: IgnorePointer(
          ignoring: isLoad,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
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
                                  maxMarks = int.tryParse(value);
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
                                  LengthLimitingTextInputFormatter(4),
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
                  margin: EdgeInsets.only(top: (gapH - 510)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 4),
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                  'pdf'
                                ]).timeout(Duration(minutes: 1), onTimeout: () {
                              Fluttertoast.showToast(
                                  msg: 'Unable to prepare the selected PDF');
                              return;
                            });
                            if (result == null) return;
                            if (mounted)
                              setState(() {
                                pickedPDF = File(result.files.single.path);
                                pName = result.files.single.name;
                                pSize = result.files.single.size;
                              });
                          },
                          child: pName == null
                              ? Text(
                                  '+ Select a file',
                                  style: TextStyle(color: Colors.blue),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$pName',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '$pSize KB',
                                    ),
                                  ],
                                ),
                          shape: pName == null
                              ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: Colors.blue,
                                    width: 0.75,
                                  ),
                                )
                              : null,
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
                                pickedPDF == null ||
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
                                    des, now, maxMarks, pickedPDF);
                            if (res > -10 && mounted) {
                              setState(() {
                                isLoad = false;
                              });
                              if (res == 201) {
                                Navigator.pop(context);
                              } else if (res == 400) {
                                showMyDialog(context, true,
                                    'Try changing time or title');
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
    Provider.of<DataAllClasses>(context, listen: false).ans.clear();
    Future.delayed(Duration.zero, () async {
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
                          onPressed: () {
                            pdfView(
                                context,
                                Provider.of<DataAllClasses>(context,
                                        listen: false)
                                    .assign[widget.idx][5]);
                          },
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
                        resourceHelper[8],
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
            buttonPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.fromLTRB(30, 25, 30, 0),
            titlePadding: EdgeInsets.only(left: 30, top: 30),
            // insetPadding: EdgeInsets.symmetric(vertical: gapH * 0.3),
            // actionsPadding: EdgeInsets.zero,
            title: Text('${Provider.of<DataAllClasses>(context).ans[idx][5]}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            content: Wrap(
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
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              color: colors[5],
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
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
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.zero,
                        minWidth: 0,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          pdfView(
                              context,
                              Provider.of<DataAllClasses>(context,
                                      listen: false)
                                  .ans[idx][1]);
                        },
                        child: Text(
                          'View',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Marks obtained',
                    hintText: Provider.of<DataAllClasses>(context).ans[idx][4]
                        ? '${Provider.of<DataAllClasses>(context).ans[idx][2]}'
                        : null,
                  ),
                  onChanged: (value) {
                    marks = int.tryParse(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Submission:',
                      ),
                      Text(
                        Provider.of<DataAllClasses>(context).ans[idx][3]
                            ? 'Late'
                            : 'Before time',
                      ),
                    ],
                  ),
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
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              padding: EdgeInsets.only(right: 15),
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
                              padding: EdgeInsets.symmetric(horizontal: 20),
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
                                if (marks == null) {
                                  HapticFeedback.mediumImpact();
                                  return;
                                }
                                reset(() {
                                  isL = true;
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                                  else if (res == 400)
                                    showMyDialog(context, true,
                                        'Can\'t exceed MaxMarks!');
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
              ),
            ],
          );
        },
      );
    },
  );
}

class UploadWork extends StatefulWidget {
  final int idx, classID;
  bool isAttempted;
  UploadWork(this.classID, this.idx, this.isAttempted);
  @override
  _UploadWorkState createState() => _UploadWorkState();
}

class _UploadWorkState extends State<UploadWork> {
  @override
  void initState() {
    Provider.of<DataAllClasses>(context, listen: false).ans.clear();
    Future.delayed(Duration.zero, () async {
      if (widget.isAttempted) {
        await Provider.of<DataAllClasses>(context, listen: false).viewAns(
            context,
            widget.classID,
            Provider.of<DataAllClasses>(context, listen: false)
                .assign[widget.idx][0],
            Provider.of<DataAllClasses>(context, listen: false)
                .assign[widget.idx][6]);
      }
    });
    super.initState();
  }

  File pickedPDF;
  String pName;
  int pSize;
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
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
      ),
      body: (Provider.of<DataAllClasses>(context).ans.isEmpty &&
              widget.isAttempted)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Provider.of<DataAllClasses>(context).assign[widget.idx][2]}',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 7),
                        child: Text(
                          'Due: ' +
                              formatDate(
                                  DateTime.parse(
                                      Provider.of<DataAllClasses>(context)
                                          .assign[widget.idx][3]),
                                  [
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
                                  ]),
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
                        padding: const EdgeInsets.only(top: 15, bottom: 4),
                        child: Text(
                          'Attachment:',
                          style: TextStyle(),
                        ),
                      ),
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
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: colors[5],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        Provider.of<DataAllClasses>(context)
                                                .assign[widget.idx][5]
                                                .toString()
                                                .contains('assignment')
                                            ? Provider.of<DataAllClasses>(
                                                    context)
                                                .assign[widget.idx][5]
                                                .toString()
                                                .substring(52)
                                            : '',
                                        style: TextStyle(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.zero,
                              minWidth: 0,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                pdfView(
                                    context,
                                    Provider.of<DataAllClasses>(context,
                                            listen: false)
                                        .assign[widget.idx][5]);
                              },
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (widget.isAttempted)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Submission:',
                                    ),
                                    Text(
                                      Provider.of<DataAllClasses>(context)
                                              .ans[0][3]
                                          ? 'Late'
                                          : 'Before time',
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Provider.of<DataAllClasses>(context).ans[0]
                                            [4]
                                        ? 'Marks obtained:'
                                        : 'Unchecked',
                                  ),
                                  Text(
                                    Provider.of<DataAllClasses>(context).ans[0]
                                            [4]
                                        ? '${Provider.of<DataAllClasses>(context).ans[0][2]}'
                                        : '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  widget.isAttempted
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your work:'),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.insert_drive_file_outlined,
                                            color: colors[5],
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                Provider.of<DataAllClasses>(
                                                            context)
                                                        .ans[0][1]
                                                        .toString()
                                                        .contains('answers')
                                                    ? Provider.of<
                                                                DataAllClasses>(
                                                            context)
                                                        .ans[0][1]
                                                        .toString()
                                                        .substring(49)
                                                    : '',
                                                style: TextStyle(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      splashColor: Colors.transparent,
                                      onPressed: () {
                                        pdfView(
                                            context,
                                            Provider.of<DataAllClasses>(context,
                                                    listen: false)
                                                .ans[0][1]);
                                      },
                                      child: Text(
                                        'View',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : isLoad
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: double.infinity,
                                  ),
                                  child: FlatButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    onPressed: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      FilePickerResult result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                            'pdf'
                                          ]).timeout(Duration(minutes: 1),
                                              onTimeout: () {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Unable to prepare the selected PDF');
                                        return;
                                      });
                                      if (result == null) return;
                                      if (mounted)
                                        setState(() {
                                          pickedPDF =
                                              File(result.files.single.path);
                                          pName = result.files.single.name;
                                          pSize = result.files.single.size;
                                        });
                                    },
                                    child: pName == null
                                        ? Text(
                                            '+ Select a file',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '$pName',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '$pSize KB',
                                              ),
                                            ],
                                          ),
                                    shape: pName == null
                                        ? RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            side: BorderSide(
                                              color: Colors.blue,
                                              width: 0.75,
                                            ),
                                          )
                                        : null,
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
                                      if (pickedPDF == null) {
                                        HapticFeedback.mediumImpact();
                                        return;
                                      }
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      setState(() {
                                        isLoad = true;
                                      });
                                      int res =
                                          await Provider.of<DataAllClasses>(
                                                  context,
                                                  listen: false)
                                              .uploadAns(
                                                  context,
                                                  widget.classID,
                                                  Provider.of<DataAllClasses>(
                                                          context,
                                                          listen: false)
                                                      .assign[widget.idx][0],
                                                  pickedPDF);
                                      if (res > -10 && mounted) {
                                        setState(() {
                                          isLoad = false;
                                        });
                                        if (res == 201) {
                                          Navigator.pop(context);
                                        } else if (res == 200) {
                                          setState(() {
                                            widget.isAttempted = true;
                                          });
                                        } else
                                          showMyDialog(context, true,
                                              'Something went wrong');
                                      }
                                    },
                                    child: Text(
                                      'Submit',
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
                ],
              ),
            ),
    );
  }
}

pdfView(context, String url) {
  if (url == null) {
    HapticFeedback.heavyImpact();
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PDF().cachedFromUrl(url,
          maxNrOfCacheObjects: 6,
          placeholder: (p) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  iconTheme: IconThemeData(color: colors[5]),
                ),
                backgroundColor: colors[6],
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Progress: $p%',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    CircularProgressIndicator(
                      value: p / 100,
                    )
                  ],
                )),
              ),
          errorWidget: (e) {
            Fluttertoast.showToast(msg: 'Cant\'t load PDF!');
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
              ),
              backgroundColor: colors[6],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'Sorry for inconvenience');
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: colors[6]),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    ),
  );
}
