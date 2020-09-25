import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/todo.dart';

const List resourceHelper = [
  'resources/front.svg',
  'resources/bottom.svg',
  'resources/profile.png',
  'resources/back1.png',
  'resources/back2.png',
  'resources/back3.png',
];

const List colors = [
  [
    Color(0xff7E2EFF),
    Color(0xbfa166ff),
  ],
  [
    Color(0xff2D81F7),
    Color(0xbf6ba7fa),
  ],
  [
    Color(0xff2cb599),
    Color(0xbf5bd7be),
  ],
  [
    Color(0xfff76441),
    Color(0xbffa9c85),
  ],
  [
    Color(0xfff7b341),
    Color(0xbffacf85),
  ],
  Colors.grey,
  Colors.white,
  Colors.black,
];

const kFirstText = 'Make your E-learning easy with';
const kSL = 'SmartLearn ';
const kOTP = ' Check your email for OTP ';

snack(c, txt) {
  return Scaffold.of(c).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
    ),
  );
}

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

bool _sel1 = true;
bool _sel2 = false;

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 70,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(resourceHelper[2]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Random Name',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        'some@email.com',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        'Student',
                        style: TextStyle(),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 60,
            thickness: 2,
            endIndent: 50,
            indent: 50,
          ),
          Card(
            margin: EdgeInsets.fromLTRB(0, 0, 40, 2),
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(100),
              ),
            ),
            child: ListTile(
              selectedTileColor: Color(0xffeaf2fe),
              selected: _sel1,
              leading: Icon(Icons.home),
              title: Text('My Classes'),
              onTap: () {
                setState(() {
                  _sel1 = true;
                  _sel2 = false;
                });
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                  (_) => false,
                );
              },
            ),
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.local_library),
          //   title: Text('Library'),
          //   onTap: () {},
          // ),
          //  Divider(),
          Card(
            margin: EdgeInsets.fromLTRB(0, 0, 40, 2),
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(100),
              ),
            ),
            child: ListTile(
              selectedTileColor: Color(0xffeaf2fe),
              selected: _sel2,
              leading: Icon(Icons.format_list_bulleted),
              title: Text('To-Do'),
              onTap: () {
                setState(() {
                  _sel2 = true;
                  _sel1 = false;
                });
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Todo(),
                  ),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

tileNoti(context, int index) {
  return Container(
    constraints: BoxConstraints(
      minHeight: 100,
    ),
    margin: EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: Card(
      elevation: 0.2,
      shadowColor: colors[1][0],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colors[1][1],
          width: 0.1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        title: Text('Name $index || Discuss'),
        subtitle: Wrap(
          children: [
            Text(
                'Dramatically fashion covalent technologies via adaptive covalsd intellectual capital. Dynamically integrate.'),
          ],
        ),
      ),
    ),
  );
}

tileDiscuss(context, int index) {
  return Container(
    constraints: BoxConstraints(
      minHeight: 120,
    ),
    margin: EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colors[7],
          width: 0.1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        title: Text(
          'Student name ${index + 10}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Wrap(
          children: [
            Divider(
              thickness: 1,
              endIndent: 40,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    'Efficiently mesh strategic collaboration and idea-sharing whereas standards compliant ideas. Globally negotiate installed base information through superior collaboration and idea-sharing.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    //    softWrap: false,
                  ),
                ),
                Icon(Icons.chat),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

tileWork(context, int index) {
  return Container(
    constraints: BoxConstraints(
      minHeight: 120,
    ),
    margin: EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colors[7],
          width: 0.1,
        ),
      ),
      child: ListTile(
        trailing: Icon(Icons.more_vert),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        title: Text(
          'Assignment ${index + 1}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Wrap(
          children: [
            Divider(
              thickness: 1,
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.insert_drive_file),
                Text(' File_name.pdf'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

tileInfo(context, index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(resourceHelper[2]),
        ),
      ),
      Text('Student ${index + 1}'),
    ],
  );
}

tileTodo(context, index) {
  return ListTile(
    contentPadding: EdgeInsets.fromLTRB(
      50,
      8,
      50,
      8,
    ),
    title: Text(
      'Task ${index + 1}',
      style: TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ),
    subtitle: Text(
      index == 2
          ? 'Efficiently mesh strategic collaboration and idea-sharing whereas standards compliant ideas. Globally negotiate installed base information through superior collaboration and idea-sharing.'
          : '',
      style: TextStyle(),
    ),
  );
}
