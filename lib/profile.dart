import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_detail.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  String profileImageUrl = 'assets/images/profile.jpg';
  String name = 'Yükleniyor...';
  String city = 'Yükleniyor...';
  String birthDate = 'Yükleniyor...';
  String email = 'Yükleniyor...';
  String gender = 'Yükleniyor...';
  List<String> achievements = []; // Başarımlar
  List<String> badges = []; // Rozetler

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // Şu anki kullanıcıyı alıyor
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        // Firestore'dan kullanıcı verilerini çekme
        DocumentSnapshot userDoc = await firestore.collection('Users').doc(user.uid).get();

        if (userDoc.exists) {
          // Firestore'dan gelen verileri atama
          setState(() {
            name = userDoc['fullname'];
            city = userDoc['city'];
            birthDate = userDoc['birthday'];
            email = userDoc['email'];
            gender = userDoc['gender'];
            achievements = List<String>.from(userDoc['achievement']);
            badges = List<String>.from(userDoc['badge']);
          });
        }
      }
    } catch (e) {
      print('Kullanıcı verileri yüklenirken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Profil düzenleme sayfasına git
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileDetailScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profil bilgileri
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(profileImageUrl),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    city,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text('Doğum Tarihi: $birthDate'),
                  SizedBox(height: 5),
                  Text('Email: $email'),
                  SizedBox(height: 5),
                  Text('Cinsiyet: $gender'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Rozetler ve Başarımlar
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kazanılan Rozetler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  badges.isNotEmpty
                      ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: badges.map((badge) {
                      return Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: Colors.white),
                            SizedBox(width: 5),
                            Text(badge, style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        backgroundColor: Colors.yellow[800],
                      );
                    }).toList(),
                  )
                      : Text('Henüz kazanılmış rozet yok'),

                  SizedBox(height: 20),

                  Text(
                    'Kazanılan Başarımlar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  achievements.isNotEmpty
                      ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: achievements.map((achievement) {
                      return Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emoji_events, color: Colors.white),
                            SizedBox(width: 5),
                            Text(achievement, style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        backgroundColor: Colors.yellow[900],
                      );
                    }).toList(),
                  )
                      : Text('Henüz kazanılmış başarımlar yok'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
