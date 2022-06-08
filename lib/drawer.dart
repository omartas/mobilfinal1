import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0), //
        children: <Widget>[
          //çekmece başlığı
          UserAccountsDrawerHeader(
            accountName: Text("Tyler"),
            accountEmail: Text(user!.email!),

            currentAccountPicture: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/tyler.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue[400]),
          ),
          ListTile(title: Text("Etkinliklerim"), onTap: () {}),
          ListTile(title: Text("Mesajlarım"), onTap: () {}),
          ListTile(title: Text("Ayarlar"), onTap: () {}),
          ListTile(
              title: Text("Çıkış Yap"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
              }),
        ],
      ),
    );
  }
}
