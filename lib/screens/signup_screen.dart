import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mobilfinal1/screens/anasayfa.dart';
import 'package:mobilfinal1/screens/signup_screen.dart';


class SignUpWidget extends StatefulWidget {

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();



  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return AnaSayfa();
            }else{

              return ScrollviewWidget(emailController: emailController, passwordController: passwordController);
            }
          }

      ),
    );
  }

}

class ScrollviewWidget extends StatelessWidget {
  const ScrollviewWidget({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    Future signUp()async{
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      }on FirebaseAuthException catch (e){
        print(e);
      }
    }
    Future signIn() async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text.trim(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 130,),
          FlutterLogo(size: 100),
          SizedBox(height: 50,),
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Mailinizi giriniz.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Şifre',
                  hintText: 'Şifrenizi Giriniz'),
            ),
          ),
          SizedBox(height: 50,),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              child: Text(
                'Kayıt Ol',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              onPressed: signUp,
            ),
          ),
        ],
      ),
    );


  }

}

