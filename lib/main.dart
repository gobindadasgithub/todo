import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/OnboardingPage/OnBoard.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/DatabaseHelper/Database_Helper.dart';
import 'package:todo_list_app/Provider/todo_list_screen.dart';
import 'package:todo_list_app/Provider/todo_model.dart';


import 'HomePage/homePage.dart';
import 'Provider/todo_provider.dart';


int? isviewed;
void main() async{
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isviewed != 0 ? const OnBoard() : TodoListScreen(),
      ),
    );



  }
}


