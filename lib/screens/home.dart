import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../helper.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: drawer(),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(resourceHelper[2]),
                    ),
                  ),
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
          onPressed: () {},
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        //   child: Text(
        //     'My Classes',
        //     style: TextStyle(
        //       color: Colors.green,
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       decoration: TextDecoration.underline,
        //     ),
        //   ),
        // ),
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
                  color: colors[index % 5][500],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: colors[index % 5][300],
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image.asset(
                        resourceHelper[3],
                        width: 200,
                      ),
                      ListTile(
                        enabled: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 55),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Myclass(
                                  'Name ${index + 1}', colors[index % 5][500]),
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
                        subtitle: Text(
                          'Short description',
                          style: TextStyle(
                            color: colors[6],
                            fontSize: 13,
                          ),
                          maxLines: 1,
                        ),
                        trailing: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(resourceHelper[2]),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mytitle,
          style: TextStyle(),
        ),
        backgroundColor: colour,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {},
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
