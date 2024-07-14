import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/studentProviders/studentProvider.dart';
import '../InstructionDialog/dialogMain.dart';

Widget textDisplay(value, type, context) {
  return Container(
      padding: type == "title"
          ? const EdgeInsets.all(20)
          : const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text(
          type == "diff"
              ? "Difficulty : $value"
              : type == "total"
                  ? "Questions to Attempt : $value"
                  : "$value",
          style: textStyle(type, context)));
}

TextStyle textStyle(value, context) {
  return TextStyle(
      fontSize:
          (value == "title") ? 20 : 17,
      color: (value == "title") ? Colors.blue.shade700 : Colors.black,
      fontWeight: (value == "title") ? FontWeight.w800 : FontWeight.w600,
      overflow: TextOverflow.visible);
}
