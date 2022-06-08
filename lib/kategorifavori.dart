
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilfinal1/urun_detay.dart';
import 'package:flutter/material.dart';

class KategoriFavori extends StatefulWidget {

  final favoriMekanlar;

  const KategoriFavori({super.key, required this.favoriMekanlar});
  @override
  State<KategoriFavori> createState() => _KategoriFavoriState();
}


class _KategoriFavoriState extends State<KategoriFavori> {

  var collection1 = FirebaseFirestore.instance.collection('mekanlar');

  Future<double> ortalamaGetir(String mekanIsmi) async{
    double toplam =0;
    int sayac =0;

    var collection = FirebaseFirestore.instance.collection('yorumlar');
    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {


      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String mekanIsim = await data['mekanId'];
      if(mekanIsim==mekanIsmi){
        sayac++;
        int puan = await data['puan'];
        toplam+=puan;

      }
    }
    toplam=toplam/sayac;


    if(toplam==double.nan){
      return 0;
    }else{
      return toplam;
    }

  }

  Future<List<String>> yorumGetir(String mekanIsmi) async{


    var collection = FirebaseFirestore.instance.collection('yorumlar');
    var querySnapshot = await collection.get();
    List<String> lazimOlan =[];
    for (var queryDocumentSnapshot in querySnapshot.docs) {


      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String mekanIsim = await data['mekanId'];
      if(mekanIsim==mekanIsmi){
        String yorum = await data['yorum'];
        lazimOlan.add(yorum);
      }
    }
    return lazimOlan;
  }

  Future<List<dynamic>> favoriMekanGetir() async{


    var collection = FirebaseFirestore.instance.collection('mekanlar');
    var querySnapshot = await collection.get();
    List<String> lazimOlan =[];
    for (var queryDocumentSnapshot in querySnapshot.docs) {


      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String mekanIsim = await data['isim'];
      lazimOlan.add(mekanIsim);
print(mekanIsim);

  }
  List<dynamic>favoriMekanlar=[];
    for (int i=0; i<lazimOlan.length; i++){
      double ortalama =await ortalamaGetir(lazimOlan[i]);
      print(lazimOlan);
      if (ortalama>=4){
        favoriMekanlar.add(querySnapshot.docs[i].data());
      }

    }

  return favoriMekanlar;


  }

  Future<List<int>> puanGetir(String mekanIsmi) async{


    var collection = FirebaseFirestore.instance.collection('yorumlar');
    var querySnapshot = await collection.get();
    List<int> lazimOlan =[];
    for (var queryDocumentSnapshot in querySnapshot.docs) {


      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String mekanIsim = await data['mekanId'];
      if(mekanIsim==mekanIsmi){
        int puan = await data['puan'];
        lazimOlan.add(puan);
      }
    }
    return lazimOlan;
  }




  @override
  Widget build (BuildContext context) {

//widget.favoriMekanlar[index]['isim'].toString()
    var degisken =widget.favoriMekanlar;
    print(degisken);
    return Scaffold(
      appBar: AppBar(title: Text("Favori Mekanlar"),),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Flexible(
            child: ListView.builder(
                itemCount: degisken.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${degisken[index]["isim"]}'),
                    subtitle: Text('${degisken[index]["tur"]}',overflow: TextOverflow.ellipsis,),
                    leading: GestureDetector(
                      onTap: () async{

                        List<int> puanlar = await puanGetir(degisken[index]["isim"]);
                        double ortalama = await ortalamaGetir(degisken[index]["isim"]);
                        List<String> yorumlar = await yorumGetir(degisken[index]["isim"]);
                        print(yorumlar);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UrunDetay(
                                  fiyat: '${degisken[index]["aciklama"]}',
                                  isim: '${degisken[index]["isim"]}',
                                  resimYolu: '${degisken[index]["resim"]}',
                                  mevcut: degisken[index]["ücret"]=="ücretsiz"?true:false,
                                  puan: ortalama,
                                  yorumlar: yorumlar,
                                  puanlar: puanlar,
                                )));
                        //listOfDocumentSnap[index]
                      },
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                '${degisken[index]["resim"]}'),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  );
                }),
          ),

        ],
      )
    );
  }
  }

