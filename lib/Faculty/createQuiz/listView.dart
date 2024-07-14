import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/createQuizProvider.dart';

class ListViewQuestions extends StatelessWidget {
  const ListViewQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var providerValue = Provider.of<CreateQuizProvider>(context);
    if (providerValue.list.isEmpty) {
      return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            alignment: Alignment.center,
            child: const Text(
              "\n\nAdd Questions to Quiz from '+' icon on Upper Right Corner.\n\n",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8f3040),
                  overflow: TextOverflow.visible,
                  wordSpacing: 2,
                  letterSpacing: 0.4),
              textAlign: TextAlign.center,
            )),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: providerValue.list.length,
          itemBuilder: (context, index) {
            return QuestionCard(index: index);
          },
        ),
      );
    }
  }
}

class QuestionCard extends StatelessWidget {
  final int index;
  const QuestionCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var providerValue = Provider.of<CreateQuizProvider>(context);
    var data = providerValue.list.elementAt(index);
    String ques = data["Question"] ?? "";
    String opt1 = data["Answer1"] ?? "";
    String opt2 = data["Answer2"] ?? "";
    String opt3 = data["Answer3"] ?? "";
    String opt4 = data["Answer4"] ?? "";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Question(index: index),
                  QuestionValue(question: ques),
                  OptionRow(option1: opt1, option2: opt2),
                  OptionRow(option1: opt3, option2: opt4),
                ],
              ),
            ),
            DeleteQuestionButton(providerValue: providerValue, index: index),
          ],
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  final int index;
  const Question({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Text(
        "Question: #${index + 1}",
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.visible),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class QuestionValue extends StatelessWidget {
  final String question;
  const QuestionValue({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 2),
      child: Text(
        question,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.visible),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  final String option1;
  final String option2;
  const OptionRow({Key? key, required this.option1, required this.option2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Option(text: option1)),
        Expanded(child: Option(text: option2)),
      ],
    );
  }
}

class Option extends StatelessWidget {
  final String text;
  const Option({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DeleteQuestionButton extends StatelessWidget {
  final CreateQuizProvider providerValue;
  final int index;

  const DeleteQuestionButton({Key? key, required this.providerValue, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => providerValue.deleteData(index),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Icon(Icons.remove),
      ),
    );
  }
}
