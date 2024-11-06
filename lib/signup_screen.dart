import 'package:digi_harmoni/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String selectedGender = 'Erkek';
  final List<String> genders = ['Erkek', 'Kadın']; // Cinsiyet seçenekleri

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF080E2D),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Ekleme
              Center(
                child: Image.asset(
                  'assets/images/digiharmoni-logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Kayıt Ol',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),

              // İsim girişi
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Şehir girişi
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Şehir',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Doğum tarihi girişi
              TextField(
                controller: birthDateController,
                decoration: InputDecoration(
                  labelText: 'Doğum Tarihi (Gün/Ay/Yıl)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Cinsiyet seçimi dropdown
              DropdownButtonFormField<String>(
                dropdownColor: Color(0xFF080E2D),
                value: selectedGender,
                decoration: InputDecoration(
                  labelText: 'Cinsiyet',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                items: genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Email girişi
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Şifre girişi
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),

              // Kayıt butonu
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String name = nameController.text.trim();
                  String city = cityController.text.trim();
                  String birthDate = birthDateController.text.trim();
                  String gender = selectedGender;

                  if (email.isNotEmpty &&
                      password.isNotEmpty &&
                      name.isNotEmpty &&
                      city.isNotEmpty &&
                      birthDate.isNotEmpty) {
                    if (password.length >= 6) {
                      try {
                        // Firebase ile kullanıcı oluşturma
                        UserCredential userCredential =
                        await firebaseAuth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Kullanıcı bilgilerini Firestore'a kaydetme
                        await firestore
                            .collection('Users') // Koleksiyon adı: Users
                            .doc(userCredential.user?.uid) // Firebase User ID ile document oluşturuluyor
                            .set({
                          'fullname': name,
                          'city': city,
                          'birthday': birthDate,
                          'email': email,
                          'gender': gender,
                          'achievement': [],         // Başarımlar
                          'badge': [],               // Rozetler
                        });

                        // Başarılı kayıt sonrası giriş sayfasına yönlendirme
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } catch (e) {
                        String errorMessage;
                        if (e is FirebaseAuthException) {
                          switch (e.code) {
                            case 'email-already-in-use':
                              errorMessage = 'E-posta zaten kayıtlı.';
                              break;
                            case 'invalid-email':
                              errorMessage = 'Geçersiz e-posta adresi.';
                              break;
                            case 'operation-not-allowed':
                              errorMessage =
                              'Bu işlemi gerçekleştirmek için gerekli izinler yok.';
                              break;
                            case 'weak-password':
                              errorMessage =
                              'Şifre çok zayıf, en az 6 karakter olmalı.';
                              break;
                            default:
                              errorMessage =
                              'Bir hata oluştu. Lütfen tekrar deneyin.';
                          }
                        } else {
                          errorMessage =
                          'Bir hata oluştu. Lütfen tekrar deneyin.';
                        }

                        // Hata mesajını göster
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Kayıt Başarısız', style: TextStyle(color: Colors.black87)),
                              content: Text(errorMessage, style: TextStyle(color: Colors.black87)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Tamam', style: TextStyle(color: Colors.black87)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // Şifre kısa ise uyarı
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Kayıt Başarısız', style: TextStyle(color: Colors.black87)),
                            content: Text('Şifre en az 6 karakterden oluşmalı.', style: TextStyle(color: Colors.black87)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Tamam', style: TextStyle(color: Colors.black87)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // Boş alan kontrolü
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Kayıt Başarısız', style: TextStyle(color: Colors.black87)),
                          content: Text('Lütfen tüm alanları doldurun.', style: TextStyle(color: Colors.black87)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Tamam', style: TextStyle(color: Colors.black87)),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Kayıt Ol',
                  style: TextStyle(color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A7BFF),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Giriş yapma butonu
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Zaten üye misin? Giriş yap',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
