import 'package:flutter/material.dart';
import 'package:pic_match_puzzle/main.dart';
import 'package:pic_match_puzzle/pazzle.dart';

class lvl extends StatefulWidget {
  int index;
  String mode;

  lvl(this.index, this.mode);

  static List level = [];

  @override
  State<lvl> createState() => _lvlState();
}

class _lvlState extends State<lvl> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are You Sure To Exit"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return Match_puzzle();
                        },
                      ));
                    },
                    child: Text("Yes"))
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Select Level",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          actions: [
            Center(
              child: Text(
                "${widget.mode}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.volume_up)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/imagenes/ayush.jpg"))),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 120),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index1) {
              return Container(
                margin: EdgeInsets.all(20),
                height: 500,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal.shade50,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    )),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10),
                          width: 170,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                          child: Text("MATCH ${index1 + 1}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return (widget.index >= index1 * 10 + index)
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return Puzzle(
                                            index, widget.mode, index1);
                                      },
                                    ));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(10),
                                      width: 170,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                      child:
                                          (widget.index > index1 * 10 + index)
                                              ? Text(
                                                  "Level ${index1 * 10 + index + 1}-${Match_puzzle.prefs!.getString("${widget.mode}-${index1 * 10 + index}")}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                )
                                              : Text(
                                                  "Level ${index1 * 10 + index + 1}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                )),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10),
                                  width: 170,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100),
                                  child: Text(
                                    "Level ${index1 * 10 + index + 1}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
