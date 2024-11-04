import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;

class ModuleDetail extends StatefulWidget {
  final String title;
  final String image;
  final String text; // Metin dosyası yolu

  ModuleDetail({required this.title, required this.image, required this.text});

  @override
  _ModuleDetailState createState() => _ModuleDetailState();
}

class _ModuleDetailState extends State<ModuleDetail> {
  bool _isCompleted = false; // Animasyon durumunu kontrol eden değişken
  String _description = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Modül metni txt dosyasından çağrılıyor
    loadModuleText(widget.text).then((text) {
      setState(() {
        _description = text;
      });
    });
  }

  // Metin dosyasını yükle
  Future<String> loadModuleText(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

  // Firestore'a başarı rozeti ekle
  Future<void> _addBadgeToFirestore(String badgeTitle) async {
    try {
      // Firebase Authentication'dan mevcut kullanıcıyı al
      User? user = _auth.currentUser;

      if (user != null) {
        // Kullanıcı ID'sini kullanarak Firestore'da ilgili belgeyi al
        DocumentReference userDoc = FirebaseFirestore.instance.collection('Users').doc(user.uid);

        // Firestore'da 'badge[]' alanına başarıyı ekle
        await userDoc.update({
          'badge': FieldValue.arrayUnion(["$badgeTitle Rozeti"])
        });
      } else {
        print("Kullanıcı oturum açmamış.");
      }
    } catch (e) {
      print("Başarım eklenirken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _description.isNotEmpty ? _description : 'Yükleniyor...',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Rozeti kazandıktan sonra bildirim
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.title} modülünü tamamladınız! Başarı rozeti kazandınız!'),
                          ),
                        );

                        // Animasyonu başlat
                        setState(() {
                          _isCompleted = true;
                        });

                        // Firestore'a başarıyı ekle
                        _addBadgeToFirestore(widget.title);

                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Geri dön
                        });
                      },
                      child: Text('Modülü Tamamla', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: _isCompleted ? 100 : 0,
              height: _isCompleted ? 100 : 0,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: _isCompleted
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
