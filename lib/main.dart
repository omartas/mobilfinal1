import 'package:flutter/material.dart';
import 'package:mobilfinal1/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initilazition = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'final',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: _initilazition,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString(),style: TextStyle(fontSize: 20),),);
            }else if (snapshot.hasData){
              return LoginScreen();
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }),
      //LoginScreen(),
    );
  }
}

