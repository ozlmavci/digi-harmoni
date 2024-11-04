import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _gender = 'Erkek'; // Varsayılan cinsiyet

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Kullanıcı verilerini Firestore'dan çek
  Future<void> _loadUserData() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc['fullname'] ?? '';
            _cityController.text = userDoc['city'] ?? '';
            _birthDateController.text = userDoc['birthday'] ?? '';
            _emailController.text = userDoc['email'] ?? '';
            _gender = userDoc['gender'] ?? 'Erkek'; // Varsayılan olarak Erkek
          });
        }
      }
    } catch (e) {
      print('Kullanıcı verileri yüklenirken bir hata oluştu: $e');
    }
  }

  // Firestore'da kullanıcı bilgilerini güncelle
  Future<void> _updateUserData() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        await firestore.collection('Users').doc(user.uid).update({
          'fullname': _nameController.text,
          'city': _cityController.text,
          'birthday': _birthDateController.text,
          'email': _emailController.text,
          'gender': _gender,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil güncellendi!')),
        );
      }
    } catch (e) {
      print('Profil güncellenirken bir hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil güncellenirken bir hata oluştu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Düzenle'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Ad Soyad'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Yaşadığı Şehir'),
            ),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Doğum Tarihi'),
            ),
            DropdownButton<String>(
              value: _gender,
              items: ['Erkek', 'Kadın'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              isExpanded: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateUserData();
              },
              child: Text(
                'Kaydet',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
