import 'dart:convert';
import 'dart:typed_data';

import 'package:byte_extensions/byte_extensions.dart';
import 'package:flutter/material.dart';
import 'package:mcu_gps_parser/Coord.dart';

class QuestionCreator extends StatefulWidget {
  const QuestionCreator({super.key});

  @override
  State<QuestionCreator> createState() => _QuestionCreatorState();
}

class _QuestionCreatorState extends State<QuestionCreator> {
  int _index = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<TextEditingController> textctrls;
  late List<GlobalKey<FormFieldState>> _formFieldKeys;

  late List<Step> steps;

  bool isNumeric(String s) {
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  void onPressed() {
    if (_formKey.currentState?.validate() == true) {
      QuestionData data = QuestionData(
          question: textctrls[0].text,
          correct: textctrls[1].text,
          incorrect1: textctrls[2].text,
          incorrect2: textctrls[3].text,
          c: Coord(
              x: double.parse(textctrls[5].text),
              y: double.parse(textctrls[6].text)));
      Navigator.pop(
        context,
        data,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//          leading: BackButton(onPressed: onPressed),
          title: const Text(
            "Create Question",
            textScaler: TextScaler.linear(2.0),
          ),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: Stepper(
                currentStep: _index,
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                onStepContinue: () {
                  if (_index < steps.length - 1) {
                    if (_formFieldKeys[_index].currentState?.validate() ==
                        true) {
                      setState(() {
                        _index = _index + 1;
                      });
                    }
                  } else {
                    if (_formKey.currentState?.validate() == true) {
                      onPressed();
                      //Navigator.pop(context, data);
                    }
                  }
                },
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index = _index - 1;
                    });
                  }
                },
                steps: steps)));
  }

  @override
  void dispose() {
    for (var textctrl in textctrls) {
      textctrl.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    const numSteps = 7;
    setState(() {
      textctrls = List.generate(numSteps, (i) => TextEditingController());
      _formFieldKeys =
          List.generate(numSteps, (i) => GlobalKey<FormFieldState>());

      steps = [
        Step(
            title: const Text("Question"),
            content: TextFormField(
              key: _formFieldKeys[0],
              controller: textctrls[0],
              decoration:
                  const InputDecoration(hintText: "Please input a question"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                }
                return null;
              },
            )),
        Step(
            title: const Text("Correct Answer"),
            content: TextFormField(
              key: _formFieldKeys[1],
              controller: textctrls[1],
              decoration: const InputDecoration(
                  hintText: "Please input the Correct answer"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                }
                return null;
              },
            )),
        Step(
            title: const Text("Incorrect Answer"),
            content: TextFormField(
              key: _formFieldKeys[2],
              controller: textctrls[2],
              decoration: const InputDecoration(
                  hintText: "Please input a incorrect answer"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                }
                return null;
              },
            )),
        Step(
            title: const Text("Incorrect Answer"),
            content: TextFormField(
              key: _formFieldKeys[3],
              controller: textctrls[3],
              decoration: const InputDecoration(
                  hintText: "Please input a incorrect answer"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                }
                return null;
              },
            )),
        Step(
            title: const Text("Coordinates"),
            content: Column(
              children: [
                TextFormField(
                  key: _formFieldKeys[5],
                  controller: textctrls[5],
                  decoration: const InputDecoration(
                      hintText:
                          "Please input the X coordinate for the question"),
                  validator: (value) {
                    if (value == null || value.isEmpty || !isNumeric(value)) {
                      return "Invalid input";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: _formFieldKeys[6],
                  controller: textctrls[6],
                  decoration: const InputDecoration(
                      hintText:
                          "Please input the y coordinate for the question"),
                  validator: (value) {
                    if (value == null || value.isEmpty || !isNumeric(value)) {
                      return "Invalid input";
                    }
                    return null;
                  },
                ),
              ],
            ))
      ];
    });
    super.initState();
  }
}

class QuestionData {
  String question;
  String correct;
  String incorrect1;
  String incorrect2;
  Coord c;
  //String coordinatey;

  QuestionData({
    required this.question,
    required this.correct,
    required this.incorrect1,
    required this.incorrect2,
    required this.c,
  });

  factory QuestionData.fromRawJson(String str) =>
      QuestionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
        question: json["question"],
        correct: json["correct"],
        incorrect1: json["incorrect1"],
        incorrect2: json["incorrect2"],
        c: Coord.fromJson(json["Coord"]),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "correct": correct,
        "incorrect1": incorrect1,
        "incorrect2": incorrect2,
        "Coord": c.toJson(),
      };

  @override
  String toString() {
    return 'QuestionData{question: $question, correct: $correct, incorrect1: $incorrect1, incorrect2: $incorrect2, cx: ${c.x} cy: ${c.y}}';
  }
  //String str = "";
  //int i = 0;
  //for (var q in questions) {
  //  str += "\"Q$i\":${q.toRawJson()},\n";
  //  i++;
  //}

  //Uint8List data = Uint8List.fromList(utf8.encode(str));
  //if (str.length > 999) {
  //  throw Exception("Data too long");
  //}
  //String sq = "SQ:${str.length}";

  //logger.fine(sq);
  //logger.fine(str);

  //widget.port.write(Uint8List.fromList(sq.codeUnits));
  //widget.port.write(data);
  Uint8List toBytes() {
    BytesBuilder bb = BytesBuilder();
    bb.add(question.codeUnits);
    bb.addByte(0x00);
    bb.add(correct.codeUnits);
    bb.addByte(0x00);
    bb.add(incorrect1.codeUnits);
    bb.addByte(0x00);
    bb.add(incorrect2.codeUnits);
    bb.addByte(0x00);
    var x = (c.x * 1000000).toInt();
    var y = (c.y * 1000000).toInt();
    var lx = x.asBytes(type: IntType.int32).cast<int>();
    var ly = y.asBytes(type: IntType.int32).cast<int>();
    bb.add(lx);
    bb.add(ly);
    bb.addByte(0x00);
    bb.addByte(0x00);
    return bb.toBytes();
  }
}
