import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pic_match_puzzle/lvl_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Color color = Color(0xff059a5e);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Match_puzzle(),
      theme: ThemeData(
          primaryColor: color,
          textTheme: TextTheme(
              displayLarge: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)))));
}

class Match_puzzle extends StatefulWidget {
  Match_puzzle({super.key});

  static SharedPreferences? prefs;
  static List<int> mode = List.filled(3, 0);

  State<Match_puzzle> createState() => _Match_puzzleState();
}

class _Match_puzzleState extends State<Match_puzzle> {
  prefrence() async {
    Match_puzzle.prefs = await SharedPreferences.getInstance();
    Match_puzzle.mode[0] = Match_puzzle.prefs!.getInt("No Time Limit") ?? 0;
    Match_puzzle.prefs!.setInt("No Time Limit", Match_puzzle.mode[0]);
    Match_puzzle.mode[1] = Match_puzzle.prefs!.getInt("Normal") ?? 0;
    Match_puzzle.prefs!.setInt("Normal", Match_puzzle.mode[1]);
    Match_puzzle.mode[2] = Match_puzzle.prefs!.getInt("Hard") ?? 0;
    Match_puzzle.prefs!.setInt("Hard", Match_puzzle.mode[2]);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    prefrence();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Exit Game"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text("Yes")),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Mode",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.volume_up)),
            SizedBox(
              width: 20,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/imagenes/ayush.jpg"))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 210,
                    width: 210,
                    decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return lvl(
                                      Match_puzzle.mode[0], "No Time Limit");
                                },
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "No Time Limit",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return lvl(Match_puzzle.mode[1], "Normal");
                                },
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "Normal",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return lvl(Match_puzzle.mode[2], "Hard");
                                },
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "Hard",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  height: 60,
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Remove ADS",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 15),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Share",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "More Games",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
