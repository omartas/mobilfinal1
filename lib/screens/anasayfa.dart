import 'package:flutter/material.dart';
import '../drawer.dart';
import 'urunler.dart';


class AnaSayfa extends StatefulWidget {

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifPageNo = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Color(0xFF90CAF9),
        title: Text(
          "Gezi Rehberi",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
        centerTitle: true,
      ),
      body:Urunler(),

      drawer: DrawerWidget(),
    );
  }
}