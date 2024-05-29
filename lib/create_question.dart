import 'dart:convert';

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
          incorrect3: textctrls[4].text,
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
            title: const Text("Incorrect Answer"),
            content: TextFormField(
              key: _formFieldKeys[4],
              controller: textctrls[4],
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
  String incorrect3;
  Coord c;
  //String coordinatey;

  QuestionData({
    required this.question,
    required this.correct,
    required this.incorrect1,
    required this.incorrect2,
    required this.incorrect3,
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
        incorrect3: json["incorrect3"],
        c: Coord.fromJson(json["Coord"]),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "correct": correct,
        "incorrect1": incorrect1,
        "incorrect2": incorrect2,
        "incorrect3": incorrect3,
        "Coord": c.toJson(),
      };

  @override
  String toString() {
    return 'QuestionData{question: $question, correct: $correct, incorrect1: $incorrect1, incorrect2: $incorrect2, incorrect3: $incorrect3, cx: ${c.x} cy: ${c.y}}';
  }
}
