import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/todo.dart';
import './model/auth_net.dart';
import 'package:provider/provider.dart';

var kurl = "https://d401eed842a0.ngrok.io";
const List resourceHelper = [
  'resources/front.svg',
  'resources/bottom.svg',
  'resources/profile.png',
  'resources/back1.png',
  'resources/back2.png',
  'resources/back3.png',
  'resources/noclass.png',
  'resources/notodo.png',
  'resources/noassign.png',
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

Future showMyDialog(context, isDis, String msg) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(15),
        title: Text('Important Notice!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              // Text(isDis),
              Text(msg),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Text(
              'Okay',
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

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

bool _sel1 = true;
bool _sel2 = false;

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    //Provider.of<DataAllClasses>(context).myclasses.clear();
    // print(Provider.of<Auth>(context).token);
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 23,
              top: 70,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: Provider.of<Auth>(context).data[0][3] == null
                      ? AssetImage(resourceHelper[2])
                      : NetworkImage(
                          '${Provider.of<Auth>(context).data[0][3]}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Provider.of<Auth>(context).data[0][0]}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          '${Provider.of<Auth>(context).data[0][1]}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          // maxLines: null,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          Provider.of<Auth>(context).data[0][2]
                              ? 'Student'
                              : 'Teacher',
                          style: TextStyle(),
                          maxLines: 1,
                        ),
                      ],
                    ),
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
                setState(
                  () {
                    _sel1 = true;
                    _sel2 = false;
                  },
                );
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
