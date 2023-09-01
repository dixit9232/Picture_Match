import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pic_match_puzzle/lvl_page.dart';
import 'package:pic_match_puzzle/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Puzzle extends StatefulWidget {
  int matchindex;
  int index;
  String mode;

  Puzzle(this.index, this.mode, this.matchindex);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  List<bool> temp = [];
  List someImages = [];
  List selectedImages = [];
  List img = [];
  List pos = [];
  List<bool> tmp = [];
  Timer? timer;
  int count = 7, end_normal = 60, end_hard = 30;
  bool downtime = false, slider_time = false, next_count = false;

  prefs() async {
    Match_puzzle.prefs = await SharedPreferences.getInstance();
    Match_puzzle.mode[0] = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
    Match_puzzle.mode[1] = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
    Match_puzzle.mode[2] = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
  }

  lvlcheck() {
    if (widget.mode == "No Time Limit") {
      if (widget.matchindex * 10 + widget.index >= Match_puzzle.mode[0]) {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + widget.matchindex * 10}",
            count.toString());
        widget.matchindex * 10 + widget.index++;
        Match_puzzle.prefs!
            .setInt("${widget.mode}", widget.matchindex * 10 + widget.index);
      } else {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + 10 * widget.matchindex}",
            count.toString());
        widget.index = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
      }
    }
    if (widget.mode == "Normal") {
      if (widget.index + widget.matchindex * 10 >= Match_puzzle.mode[1]) {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + widget.matchindex * 10}",
            count.toString());
        widget.matchindex * 10 + widget.index++;
        Match_puzzle.prefs!
            .setInt("${widget.mode}", widget.index + widget.matchindex * 10);
      } else {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + widget.matchindex * 10}",
            count.toString());
        widget.index = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
      }
    }
    if (widget.mode == "Hard") {
      if (widget.index + 10 * widget.matchindex >= Match_puzzle.mode[2]) {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + widget.matchindex * 10}",
            count.toString());
        widget.matchindex * 10 + widget.index++;
        Match_puzzle.prefs!.setInt("${widget.mode}", widget.index);
      } else {
        Match_puzzle.prefs!.setString(
            "${widget.mode}-${widget.index + widget.matchindex * 10}",
            count.toString());
        widget.index = Match_puzzle.prefs!.getInt("${widget.mode}") ?? 0;
      }
    }
    setState(() {});
  }

  Widget alart() {
    return AlertDialog(
      title: Text(
          style: TextStyle(wordSpacing: 2),
          "Congratulations!!!! You Completed this Puzzle In $count sec."),
      actions: [
        TextButton(
            onPressed: () {
              lvlcheck();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return lvl(
                      widget.matchindex * 10 + widget.index, widget.mode);
                },
              ));
            },
            child: Text("Yes"))
      ],
    );
  }

  Widget timeout_alart() {
    return AlertDialog(
      title: Text(
          style: TextStyle(wordSpacing: 2),
          "Time Out!",
          textAlign: TextAlign.center),
      content: Text("Are you play again?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Match_puzzle();
                },
              ));
            },
            child: Text("No")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return lvl(Match_puzzle.prefs!.getInt("${widget.mode}")??0, widget.mode);
                },
              ));
            },
            child: Text("Yes"))
      ],
    );
  }

  one() async {
    if (img.length == 2) {
      if (img[0] == img[1]) {
        temp[pos[0]] = true;
        temp[pos[1]] = true;
        tmp.add(temp[pos[0]]);
        tmp.add(temp[pos[1]]);
        if (temp.length == tmp.length) {
          setState(() {
            timer_cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => alart());
          });
          tmp = [];
        }
        pos = [];
        img = [];
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        temp[pos[0]] = false;
        temp[pos[1]] = false;
        pos = [];
        img = [];
      }
    }
  }

  two() async {
    if (img.length == 3) {
      if (img[0] == img[1] && img[0] == img[2] && img[1] == img[2]) {
        temp[pos[0]] = true;
        temp[pos[1]] = true;
        temp[pos[2]] = true;
        tmp.add(temp[pos[0]]);
        tmp.add(temp[pos[1]]);
        tmp.add(temp[pos[2]]);
        if (temp.length == tmp.length) {
          setState(() {
            timer_cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => alart());
          });
          tmp = [];
        }
        pos = [];
        img = [];
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        temp[pos[0]] = false;
        temp[pos[1]] = false;
        temp[pos[2]] = false;
        pos = [];
        img = [];
      }
    }
  }

  three() async {
    if (img.length == 4) {
      if (img[0] == img[1] &&
          img[0] == img[2] &&
          img[0] == img[3] &&
          img[1] == img[2] &&
          img[1] == img[3] &&
          img[2] == img[3]) {
        temp[pos[0]] = true;
        temp[pos[1]] = true;
        temp[pos[2]] = true;
        temp[pos[3]] = true;
        tmp.add(temp[pos[0]]);
        tmp.add(temp[pos[1]]);
        tmp.add(temp[pos[2]]);
        tmp.add(temp[pos[3]]);
        if (tmp.length == temp.length) {
          setState(() {
            timer_cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => alart());
          });
          tmp = [];
        }
        pos = [];
        img = [];
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        temp[pos[0]] = false;
        temp[pos[1]] = false;
        temp[pos[2]] = false;
        temp[pos[3]] = false;
        pos = [];
        img = [];
        setState(() {});
      }
    }
  }

  four() async {
    if (img.length == 5) {
      if (img[0] == img[1] &&
          img[0] == img[2] &&
          img[0] == img[3] &&
          img[0] == img[4] &&
          img[1] == img[2] &&
          img[1] == img[3] &&
          img[1] == img[4] &&
          img[2] == img[3] &&
          img[2] == img[4] &&
          img[3] == img[4]) {
        temp[pos[0]] = true;
        temp[pos[1]] = true;
        temp[pos[2]] = true;
        temp[pos[3]] = true;
        temp[pos[4]] = true;
        tmp.add(temp[pos[0]]);
        tmp.add(temp[pos[1]]);
        tmp.add(temp[pos[2]]);
        tmp.add(temp[pos[3]]);
        tmp.add(temp[pos[4]]);
        if (tmp.length == temp.length) {
          setState(() {
            timer_cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => alart());
          });
          tmp = [];
        }
        pos = [];
        img = [];
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        temp[pos[0]] = false;
        temp[pos[1]] = false;
        temp[pos[2]] = false;
        temp[pos[3]] = false;
        temp[pos[4]] = false;
        pos = [];
        img = [];
        setState(() {});
      }
    }
  }

  five() async {
    if (img.length == 6) {
      if (img[0] == img[1] &&
          img[0] == img[2] &&
          img[0] == img[3] &&
          img[0] == img[4] &&
          img[0] == img[5] &&
          img[1] == img[2] &&
          img[1] == img[3] &&
          img[1] == img[4] &&
          img[1] == img[5] &&
          img[2] == img[3] &&
          img[2] == img[4] &&
          img[2] == img[5] &&
          img[3] == img[4] &&
          img[3] == img[5] &&
          img[4] == img[5]) {
        temp[pos[0]] = true;
        temp[pos[1]] = true;
        temp[pos[2]] = true;
        temp[pos[3]] = true;
        temp[pos[4]] = true;
        temp[pos[5]] = true;
        tmp.add(temp[pos[0]]);
        tmp.add(temp[pos[1]]);
        tmp.add(temp[pos[2]]);
        tmp.add(temp[pos[3]]);
        tmp.add(temp[pos[4]]);
        tmp.add(temp[pos[5]]);
        if (tmp.length == temp.length) {
          setState(() {
            timer_cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => alart());
          });
          tmp = [];
        }
        pos = [];
        img = [];
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        temp[pos[0]] = false;
        temp[pos[1]] = false;
        temp[pos[2]] = false;
        temp[pos[3]] = false;
        temp[pos[4]] = false;
        temp[pos[5]] = false;
        pos = [];
        img = [];
        setState(() {});
      }
    }
  }

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('imagenes/'))
        .where((String key) => key.contains('.png'))
        .toList();

    setState(() {
      someImages = imagePaths;
      someImages.shuffle();
      if (widget.matchindex == 0) {
        for (int i = 0; i < 6 + widget.index * 2; i++) {
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
        }
        selectedImages.shuffle();
      }
      if (widget.matchindex == 1) {
        for (int i = 0; i < 6 + widget.index; i++) {
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
        }
        selectedImages.shuffle();
      }
      if (widget.matchindex == 2) {
        for (int i = 0; i < 6 + widget.index; i++) {
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
        }
        selectedImages.shuffle();
      }
      if (widget.matchindex == 3) {
        for (int i = 0; i < 6 + widget.index; i++) {
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
        }
        selectedImages.shuffle();
      }
      if (widget.matchindex == 4) {
        for (int i = 0; i < 4 + widget.index; i++) {
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
          selectedImages.add(someImages[i]);
        }
        selectedImages.shuffle();
      }
    });
    temp = List.filled(selectedImages.length, true);
  }

  show_time() async {
    await Future.delayed(
        Duration.zero,
        () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Memorize Image"),
                  content: Text("You Have 7 Seconds to Memorize all Images"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          downtime = true;
                          slider_time = true;
                          Navigator.of(context).pop(timer_start());
                          setState(() {});
                        },
                        child: Text("OK"))
                  ],
                );
              },
            ));
  }

  timer_start() async {
    for (count = 7; count > 0; count--) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {});
    }
    if (count == 0) {
      temp = List.filled(temp.length, false);
      if (widget.mode == "No Time Limit") {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            count++;
          });
        });
      }
      if (widget.mode == "Normal") {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            count++;
            if (count >= end_normal) {
              timer_cancel();
              showDialog(
                context: context,
                builder: (context) => timeout_alart(),
              );
            }
          });
        });
      }
      if (widget.mode == "Hard") {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            count++;
            if (count >= end_hard) {
              timer_cancel();
              showDialog(
                context: context,
                builder: (context) => timeout_alart(),
              );
            }
          });
        });
      }
    }
    setState(() {});
  }

  timer_cancel() {
    timer!.cancel();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initStatex
    super.initState();
    _initImages();
    show_time();
    prefs();
  }

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
                          return lvl(widget.index, widget.mode);
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
          title: (widget.mode == "No Time Limit")
              ? Text("Time:${count}")
              : (widget.mode == "Normal")
                  ? Text("Time${count}/${end_normal}")
                  : Text("Time:${count}/${end_hard}"),
          actions: [
            Center(
              child: Text(
                "${widget.mode}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            IconButton(
                onPressed: () {
                  timer_cancel();
                },
                icon: Icon(Icons.volume_up)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
          ],
        ),
        body: SafeArea(
            child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.teal.shade50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (slider_time)
                  ? Countdown(
                      seconds: 7,
                      build: (BuildContext context, double time) {
                        return SliderTheme(
                          child: Slider(
                            value: time,
                            max: 7,
                            min: 0,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Colors.teal.shade100,
                            onChanged: (double value) {},
                          ),
                          data: SliderTheme.of(context).copyWith(
                              trackHeight: 10,
                              thumbColor: Colors.transparent,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 0.0)),
                        );
                      },
                      interval: Duration(seconds: 1),
                      onFinished: () async {
                        slider_time = false;
                        next_count = true;
                        setState(() {});
                      },
                    )
                  : SliderTheme(
                      child: Slider(
                        value: count.toDouble(),
                        max: (widget.mode == "Normal")
                            ? end_normal.toDouble()
                            : (widget.mode == "Hard")
                                ? end_hard.toDouble()
                                : double.infinity,
                        min: 0,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.teal.shade100,
                        onChanged: (double value) {},
                      ),
                      data: SliderTheme.of(context).copyWith(
                          trackHeight: 10,
                          thumbColor: Colors.transparent,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                    ),
              Expanded(
                child: GridView.builder(
                  itemCount: selectedImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 1,
                      childAspectRatio:(widget.index>=6)?1:(widget.index==5)?1.2:1.8,
                      mainAxisSpacing: 1,
                      crossAxisCount: (widget.index == 0)
                          ? 3
                          : (widget.index <= 4)
                              ? 4
                              : (widget.index == 5)
                                  ? 5
                                  : (widget.index == 6)
                                      ? 6
                                      : (widget.index == 7)
                                          ? 5
                                          : (widget.index == 8)
                                              ? 7
                                              : 8),
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: temp[index],
                      replacement: InkWell(
                        onTap: () async {
                          int j = 1;
                          if (widget.matchindex == 0) {
                            if (temp[index] == false && j == 1) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 2;
                              setState(() {});
                            } else if (temp[index] == false && j == 2) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 1;
                              setState(() {});
                            }
                            one();
                          } else if (widget.matchindex == 1) {
                            if (temp[index] == false && j == 1) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 2;
                              setState(() {});
                            } else if (temp[index] == false && j == 2) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 3;
                              setState(() {});
                            } else if (temp[index] == false && j == 3) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 1;
                              setState(() {});
                            }
                            two();
                          } else if (widget.matchindex == 2) {
                            if (temp[index] == false && j == 1) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 2;
                              setState(() {});
                            } else if (temp[index] == false && j == 2) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 3;
                              setState(() {});
                            } else if (temp[index] == false && j == 3) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 4;
                              setState(() {});
                            } else if (temp[index] == false && j == 4) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 1;
                              setState(() {});
                            }
                            three();
                          } else if (widget.matchindex == 3) {
                            if (temp[index] == false && j == 1) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 2;
                              setState(() {});
                            } else if (temp[index] == false && j == 2) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 3;
                              setState(() {});
                            } else if (temp[index] == false && j == 3) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 4;
                              setState(() {});
                            } else if (temp[index] == false && j == 4) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 5;
                              setState(() {});
                            } else if (temp[index] == false && j == 5) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 1;
                              setState(() {});
                            }
                            four();
                          } else if (widget.matchindex == 4) {
                            if (temp[index] == false && j == 1) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 2;
                              setState(() {});
                            } else if (temp[index] == false && j == 2) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 3;
                              setState(() {});
                            } else if (temp[index] == false && j == 3) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 4;
                              setState(() {});
                            } else if (temp[index] == false && j == 4) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 5;
                              setState(() {});
                            } else if (temp[index] == false && j == 5) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 6;
                              setState(() {});
                            } else if (temp[index] == false && j == 6) {
                              await Future.delayed(Duration.zero);
                              temp[index] = true;
                              pos.add(index);
                              img.add(selectedImages[index]);
                              j = 1;
                              setState(() {});
                            }
                            five();
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.tealAccent.shade700,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: Image.asset("${selectedImages[index]}"),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Image.asset("${selectedImages[index]}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
