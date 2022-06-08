
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilfinal1/kategorifavori.dart';
import 'package:mobilfinal1/urun_detay.dart';
import 'package:flutter/material.dart';

class KategoriCopy extends StatefulWidget {
  final String kategori;

  final String tur;
  const KategoriCopy({Key? key, required this.kategori, required this.tur}) : super(key: key);
  @override
  State<KategoriCopy> createState() => _KategoriCopyState();
}

class _KategoriCopyState extends State<KategoriCopy> {

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
    if(toplam.isNaN){
      return 0;
    }
    return toplam;
  }

  Future<List<dynamic>> favoriMekanGetir() async{

    var collection = FirebaseFirestore.instance.collection('mekanlar');
    var querySnapshot = await collection.get();
    List<String> lazimOlan =[];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String mekanIsim = await data['isim'];
      lazimOlan.add(mekanIsim);
    }
    List<dynamic>favoriMekanlar=[];
    for (int i=0; i<lazimOlan.length; i++){
      double ortalama =await ortalamaGetir(lazimOlan[i]);
      if (ortalama>=4){
        favoriMekanlar.add(querySnapshot.docs[i].data());
      }

    }
    return favoriMekanlar;
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
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build (BuildContext context) {
    Query<Map<String, dynamic>> mekanRef =
        _firestore.collection("mekanlar").where("tur", isEqualTo: widget.tur.toString());


    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.star),
          onPressed: ()async{
        var favoriler= await favoriMekanGetir();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>KategoriFavori(favoriMekanlar: favoriler)));
      }
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: mekanRef.snapshots(),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasError){
                return Center(child: Text("Bir Hata Oluştu"),);
              }else{
                if(asyncSnapshot.hasData){
                  List<DocumentSnapshot> listOfDocumentSnap = asyncSnapshot.data!.docs;
                  return Flexible(
                    child: ListView.builder(
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          return ListTile(

                            title: Text('${listOfDocumentSnap[index]["isim"]}'),
                            subtitle: Text('${listOfDocumentSnap[index]["aciklama"]}',overflow: TextOverflow.ellipsis,),
                            leading: GestureDetector(
                              onTap: () async{
                                List<int> puanlar = await puanGetir(listOfDocumentSnap[index]["isim"]);
                                double ortalama = await ortalamaGetir(listOfDocumentSnap[index]["isim"]);
                                List<String> yorumlar = await yorumGetir(listOfDocumentSnap[index]["isim"]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UrunDetay(
                                          fiyat: '${listOfDocumentSnap[index]["aciklama"]}',
                                          isim: '${listOfDocumentSnap[index]["isim"]}',
                                          resimYolu: '${listOfDocumentSnap[index]["resim"]}',
                                          mevcut: listOfDocumentSnap[index]["ücret"]=="ücretsiz"?true:false,
                                          puan: ortalama,
                                          yorumlar: yorumlar,
                                          puanlar: puanlar,
                                        )));
                                //listOfDocumentSnap[index]
                              },
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${listOfDocumentSnap[index]["resim"]}'),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              }

            },
          ),
        ],
      )
    );
  }
}
