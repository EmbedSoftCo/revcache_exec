import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app/create_question.dart';
import 'package:app/custom/cardlisttile.dart';
import 'package:app/mappage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:logging/logging.dart';
import 'package:toastification/toastification.dart';

String inputbuff = ""; // global buffer for the received chars over serial

class SelectedPort extends StatefulWidget {
  final SerialPort port;
  const SelectedPort({super.key, required this.port});

  @override
  State<SelectedPort> createState() => _SelectedPortState();
}

class _SelectedPortState extends State<SelectedPort> {
  final Logger logger = Logger("SelectedPort");

  late StreamSubscription<Uint8List> stream;
  late StringBuffer strbuff;
  late List<QuestionData> questions;

  void onPressed() {
    String str = strbuff.toString();

    logger.fine(str);

    if (!strbuff.isNotEmpty) {
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapPage(title: "Map", data: str)));
  }

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
    String str = "";
    int i = 0;
    for (var q in questions) {
      str += "\"Q$i\":${q.toRawJson()},\n";
      i++;
    }

    Uint8List data = Uint8List.fromList(utf8.encode(str));
    if (str.length > 999) {
      throw Exception("Data too long");
    }
    String sq = "SQ:${str.length}";

    logger.fine(sq);
    logger.fine(str);

    widget.port.write(Uint8List.fromList(sq.codeUnits));
    widget.port.write(data);
    strbuff.clear();
    successToast();

    // start background process to check if the last 2 chars in the strbuff are ACK or NACK
    Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if (strbuff.toString().contains("NACK")) {
        // do something when not successfull
        logger.info("NACK received, resending data");
        widget.port.write(data);
      } else if (strbuff.toString().contains("ACK")) {
        // do something when successfull
        // show on screen
        logger.info("ACK received, Showing toast");
        successToast();
        timer.cancel();
      }
    });
  }

  int iter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          stream.cancel();
          widget.port.close();
          logger.fine(strbuff.toString());
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
                    CardListTile("incorrect Answer3", q.incorrect3),
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
              onPressed: onPressed,
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
      strbuff = StringBuffer();
      // if data is available in the buffer call the anonymous function in the listen()
      stream = reader.stream.listen((data) {
        // store all incoming serial data
        //setState(() {
        strbuff.write(utf8.decode(data));
        //});
      });
    });
  }
}
