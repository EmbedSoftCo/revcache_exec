import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app/create_question.dart';
import 'package:app/custom/cardlisttile.dart';
import 'package:app/mappage.dart';
import 'package:app/parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:logging/logging.dart';
import 'package:toastification/toastification.dart';

String inputbuff = ""; // global buffer for the received chars over serial
String arrayToHex(Uint8List data) {
  var result = '';
  for (final x in data) {
    var str = '00' + x.toRadixString(16);
    result += str.substring(str.length - 2, str.length);
  }
  return result.toUpperCase();
}

class SelectedPort extends StatefulWidget {
  final SerialPort port;
  const SelectedPort({super.key, required this.port});

  @override
  State<SelectedPort> createState() => _SelectedPortState();
}

class _SelectedPortState extends State<SelectedPort> {
  /// instantiate logger for this page
  final Logger logger = Logger("SelectedPort");

  /// create buffers to  collect serial data
  /// StreamSubscription<Uint8List> is the stream
  late StreamSubscription<Uint8List> stream;

  /// StringBuffer is the string representation of the streams characters
  late List<int> bytebuff;

  /// create list of QuestionData structures to be converted to JSON and send using serial
  late List<QuestionData> questions;

  /// callback for button to show map.
  /// this converts the stringbuffer to a string, checks its not empty and creates the Map and passes the string as data

  void showMap() {
    if (bytebuff.isEmpty) {
      return;
    }
    print(bytebuff.length);

    var parser = Parser(bytebuff);
    print(parser.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapPage(title: "Map", data: parser)));
  }

  /// callback for button to add question. creates page with stepper widget
  void addQuestion() async {
    var retdata = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const QuestionCreator()))
        .then((data) {
      return data;
    });

    if (retdata is QuestionData) {
      logger.fine(retdata);
      setState(() {
        questions.add(retdata);
      });
    }
  }

  void successToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: const Text("Questions succesfully Send"),
      //description: Widget,
      alignment: Alignment.bottomLeft,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
    );
  }

  void sendData() async {
    int sum = 0;

    for (var q in questions) {
      sum += q.toBytes().lengthInBytes;
    }

    if (sum > 511) {
      return;
    }
    var buffer = Uint8List(0);

    for (var q in questions) {
      buffer + q.toBytes();
    }
    print(buffer);
    //widget.port.write(q.toBytes());

//
//    String str = "";
//    int i = 0;
//    for (var q in questions) {
//      str += "\"Q$i\":${q.toRawJson()},\n";
//      i++;
//    }
//
//    Uint8List data = Uint8List.fromList(utf8.encode(str));
//    if (str.length > 999) {
//      throw Exception("Data too long");
//    }
//    String sq = "SQ:${str.length}";
//
//    logger.fine(sq);
//    logger.fine(str);
//
//    widget.port.write(Uint8List.fromList(sq.codeUnits));
//    widget.port.write(data);
    successToast();
  }

  int iter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          stream.cancel();
          widget.port.close();
          Navigator.pop(context, widget.port);
        }),
        title: Text(
          widget.port.name ?? "",
          textScaler: const TextScaler.linear(2.0),
        ),
        centerTitle: true,
      ),
      //body: StreamBuilder(stream: stream, builder: builder),
      body: ListView(
        children: [
          for (final q in questions)
            Builder(builder: (context) {
              iter++;
              return ExpansionTile(
                  title: Row(
                    children: [
                      Text(q.question),
                      const Spacer(),
                      Center(
                        child: FloatingActionButton(
                          heroTag: "delbtn$iter",
                          child: const Icon(Icons.delete),
                          onPressed: () => setState(() {
                            questions.remove(q);
                          }),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    CardListTile("correct Answer", q.correct),
                    CardListTile("incorrect Answer1", q.incorrect1),
                    CardListTile("incorrect Answer2", q.incorrect2),
                    CardListTile("coord x", q.c.x.toString()),
                    CardListTile("coord y", q.c.y.toString()),
                  ]);
            })
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              heroTag: "mapbtn",
              onPressed: showMap,
              child: const Icon(Icons.map)),
          FloatingActionButton(
              heroTag: "qbtn",
              onPressed: addQuestion,
              child: const Icon(Icons.add)),
          FloatingActionButton(
              heroTag: "sendbtn",
              onPressed: sendData,
              child: const Icon(Icons.upload))
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initStream();
    widget.port.write(Uint8List.fromList("getLog".codeUnits));
    questions = [];
  }

  void initStream() {
    setState(() {
      // open the port to read
      widget.port.openReadWrite();
      final reader = SerialPortReader(widget.port);
      bytebuff = List.empty(growable: true);
      // if data is available in the buffer call the anonymous function in the listen()
      stream = reader.stream.listen((data) {
        // store all incoming serial data
        //setState(() {
        bytebuff.addAll(data);
        //});
      });
    });
  }
}
