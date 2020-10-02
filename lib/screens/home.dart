import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../helper.dart';
import 'package:provider/provider.dart';
import '../model/home_net.dart';
import '../model/auth_net.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    Provider.of<DataAllClasses>(context).updateClass(context);
    super.didChangeDependencies();
  }

  String code;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),
      home: Scaffold(
        drawer: Draw(),
        appBar: AppBar(
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
        body: Provider.of<DataAllClasses>(context).myclasses.isEmpty
            ? Center(
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
              )
            : Stack(
                children: [
                  Class_column(),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Provider.of<Auth>(context, listen: false).data[0][2]
                ? showDialog(
                    context: context,
                    barrierDismissible: true,
                    child: AlertDialog(
                      title: Text('Join class'),
                      content: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter class code',
                        ),
                        onChanged: (value) {
                          code = value;
                        },
                      ),
                      actions: [
                        FlatButton(
                          child: Text('Join'),
                          onPressed: () async {
                            // int res =
                            //     await Provider.of<DataAllClasses>(context)
                            //         .joinClass(context, code);
                          },
                        )
                      ],
                    ),
                  )
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

class Class_column extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 12),
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
                                builder: (context) => Myclass(
                                    '${Provider.of<DataAllClasses>(context).myclasses[index][0]}',
                                    colors[index % 5][0]),
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
                                        '${Provider.of<DataAllClasses>(context).myclasses[index][2]}'),
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

class Myclass extends StatelessWidget {
  Color colour;
  String mytitle;
  Myclass(this.mytitle, this.colour);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    mytitle,
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
            backgroundColor: colour,
            elevation: 6,
            leadingWidth: 50,
            titleSpacing: 0,
            toolbarHeight: 120,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Info(colour),
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
              Work(),
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

class Work extends StatelessWidget {
  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        itemBuilder: (context, index) => tileWork(context, index),
        itemCount: 15,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
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
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 30,
              ),
              itemBuilder: (context, index) => tileInfo(context, index),
              itemCount: 39,
            ),
          ),
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
  final _subController = TextEditingController();
  final _desController = TextEditingController();
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
              controller: _subController,
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
              controller: _desController,
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
                          if (_desController.value == null ||
                              _subController.value == null) {
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
                          if (res > -10) {
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
