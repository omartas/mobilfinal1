import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UrunDetay extends StatefulWidget {
  //bu sayfada her ürün için farklı detaylar gösterilecek o yüzden değişkenleri tanımlayalım

  final String isim;
  final String fiyat;
  final String resimYolu;
  final bool mevcut;

  final double puan;
  final List yorumlar;
  final List puanlar;

  const UrunDetay(
      {super.key,
      required this.isim,
      required this.fiyat,
      required this.resimYolu,
      required this.mevcut,
      required this.puan,
      required this.yorumlar,
      required this.puanlar});

  @override
  State<UrunDetay> createState() => _UrunDetayState();
}

class _UrunDetayState extends State<UrunDetay> {
  double _currentSliderValue = 3;
  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance.collection('yorumlar');
    final user = FirebaseAuth.instance.currentUser;
    TextEditingController yorumController = TextEditingController();
    ScrollController scrollController = ScrollController();
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(widget.resimYolu)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.red[400],
                      size: 40,
                    ))
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 10),
              Text(
                widget.isim,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Puan :${widget.puan.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400]),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.mevcut ? Colors.red[400] : Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.mevcut ? "Ücretsiz" : "Ücretli",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.fiyat,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        cursorWidth: 5,
                        controller: yorumController,
                        decoration: InputDecoration(
                          hintText: "Yorum Ekle",
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        var id = new DateTime.now().millisecondsSinceEpoch;
                        Map<String, dynamic> yorumData = {
                          "yorum": yorumController.text,
                          "yorumlayan": user!.uid.toString(),
                          "puan": _currentSliderValue.toInt(),
                          "mekanId": widget.isim,
                        };
                        await collection.doc(id.toString()).set(yorumData);

                        print(yorumController.text);
                        setState(()async{
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Yorum Yap")),
                ],
              ),
              SizedBox(height: 10),
              Slider(
                value: _currentSliderValue,
                max: 5,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: widget.yorumlar.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Card(
                      child: ListTile(
                        title: Text(widget.yorumlar[index]),
                        subtitle: Text(' Puan : ${widget.puanlar[index].toString()}'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
