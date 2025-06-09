import 'package:flutter/material.dart';
import 'package:myapp/notes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA-3yBw-9zQ63UE-8AU6xAsERG2MuDk2Yc", 
      appId:  "1:57571701233:android:2b40ceeb6ab143ecad9450", 
      messagingSenderId: "57571701233", 
      projectId: "notesapp-ebd40")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Note());
  }
}
