
import 'package:flutter/material.dart';
import 'package:mobilfinal1/kategoricopy.dart';

class Urunler extends StatefulWidget {
  const Urunler({Key? key}) : super(key: key);

  @override
  State<Urunler> createState() => _UrunlerState();
}

class _UrunlerState extends State<Urunler> with SingleTickerProviderStateMixin{
  TabController? televizyonkontrolcusu;
  @override
  void initState(){
    televizyonkontrolcusu  = TabController(length: 7, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true, // sekmelerin yatayda kayabilmesini sağlar.
            indicatorColor: Colors.red[400],
              labelColor: Colors.red[400],
              unselectedLabelColor: Colors.grey,
              controller: televizyonkontrolcusu,
              labelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
              tabs: [
            Tab(child: Text("Tarihi yerler"),),
            Tab(child: Text("Parklar"),),
            Tab(child: Text("Kütüphaneler"),),
            Tab(child: Text("Oteller"),),
                  Tab(child: Text("Marketler"),),
                Tab(child: Text("İbadet Yerleri"),),
                Tab(child: Text("Otoparklar"),),
          ]),
          Expanded(
            child: TabBarView(
              controller: televizyonkontrolcusu,
              children: [
                KategoriCopy(kategori: "1",tur:"tarih" ,),
                KategoriCopy(kategori: "2",tur: "park",),
                KategoriCopy(kategori: "3",tur:"kutuphane" ,),
                KategoriCopy(kategori: "4",tur:"otel" ,),
                KategoriCopy(kategori: "5",tur:"market" ,),
                KategoriCopy(kategori: "6",tur:"cami" ,),
                KategoriCopy(kategori: "7",tur:"otopark" ,),
                ],
            ),
          )
        ],
      ),
    );
  }
}
