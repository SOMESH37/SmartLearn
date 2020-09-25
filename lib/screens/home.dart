import 'package:flutter/material.dart';
import 'dart:ui';
import '../helper.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: Stack(
          children: [
            Class_column(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Join(),
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
            itemCount: 10,
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
                      ),
                      ListTile(
                        enabled: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 55),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Myclass(
                                  'Name ${index + 1}', colors[index % 5][0]),
                            ),
                          );
                        },
                        title: Text(
                          'Name ${index + 1}',
                          style: TextStyle(
                            color: colors[6],
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        subtitle: Wrap(
                          children: [
                            Text(
                              'Short description about class',
                              style: TextStyle(
                                color: colors[6],
                                fontSize: 13,
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(resourceHelper[2]),
                            ),
                            Text(
                              'Teacher\'s name',
                              style: TextStyle(
                                color: colors[6],
                                fontSize: 12,
                              ),
                            ),
                          ],
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

class Join extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join class',
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
            Text(
              'Ask your teacher for the class code',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 75,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter class code',
                labelStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              onSaved: (value) {},
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Join',
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
