import 'dart:ui';

import 'package:flutter/material.dart';

class OnboardModel {
  String img;
  String text;
  String desc;
  Color bg;
  Color button;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
    required this.bg,
    required this.button,
  });
}


List<OnboardModel> screens=<OnboardModel>[
OnboardModel(
    img: 'assets/images/img-1.png',
    text:  "Welcome to Your Todo List",
    desc: "Stay organized and productive with our powerful todo list app.",
    bg: Colors.white,
    button: const Color(0xff4756DF)

),
OnboardModel(
    img: 'assets/images/img-2.png',
    text: "Add Tasks",
    desc: "Easily add tasks to your list and never forget important deadlines.",
    bg: Colors.white,
    button: const Color(0xff456322)

),
OnboardModel(
    img: 'assets/images/img-3.png',
    text:   "Prioritize and Categorize",
    desc: "Organize tasks based on priority and categories to stay focused and efficient.",
    bg: Colors.white,
    button: const Color(0xff47bd26)

),



];