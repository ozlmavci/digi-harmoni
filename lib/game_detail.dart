import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameDetail extends StatefulWidget {
  final String gameTitle;
  final List<Map<String, dynamic>> questions;

  GameDetail({required this.gameTitle, required this.questions});

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool _isCompleted = false;
  int currentQuestionIndex = 0;
  int wrongAttempts = 0;
  int remainingTime = 30; // Süreyi 30 saniye ile başlatıyoruz
  Timer? _timer;
  bool _isTimeUp = false; // Süre doldu mu kontrolü
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingTime = 30; // Her yeni soru için süreyi sıfırlıyoruz
    _timer?.cancel(); // Eski timer varsa durdur
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime == 0) {
          _isTimeUp = true;
          _isCompleted = true;
          _timer?.cancel();
        } else {
          remainingTime--;
        }
      });
    });
  }

  void _checkAnswer(bool answer) async {
    if (!_isTimeUp && wrongAttempts < 3 && currentQuestionIndex < widget.questions.length) {
      setState(() {
        if (widget.questions[currentQuestionIndex]['answer'] == answer) {
          // Doğru cevap
        } else {
          wrongAttempts++; // Yanlış cevap
        }
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (wrongAttempts < 3 && !_isTimeUp) {
            currentQuestionIndex++;
            startTimer(); // Yeni soru için zamanlayıcıyı başlat
            if (currentQuestionIndex >= widget.questions.length) {
              _isCompleted = true;
              _timer?.cancel(); // Oyun bitince sayaç durdur
              saveAchievement(); // Firestore'a başarıyı kaydet
            }
          } else {
            _isCompleted = true;
            _timer?.cancel(); // Oyun bitince sayacı durdur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isTimeUp ? 'Süreniz doldu. Oyun bitti.' : 'Oyun Bitti! Başka hakkınız kalmadı.')),
            );
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context); // Önceki sayfaya dön
            });
          }
        });
      });
    }
  }

  Future<void> saveAchievement() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await firestore.collection('Users').doc(user.uid).update({
          'achievement': FieldValue.arrayUnion(['${widget.gameTitle} Kupası'])
        });
      }
    } catch (e) {
      print('Başarım kaydedilemedi: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameTitle),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 30),
                  SizedBox(width: 5),
                  Text(
                    '${3 - wrongAttempts}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Sayaç sadece oyunda görünsün
            if (!_isCompleted && wrongAttempts < 3)
              Container(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            // Süreye göre azalan daire
                            Container(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: remainingTime / 30,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            // Süre sayısı
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                '$remainingTime',
                                style: TextStyle(fontSize: 36, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: _isCompleted
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isTimeUp)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Icon(Icons.close, color: Colors.white, size: 50),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Süreniz doldu. Oyun bitti!',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ],
                      )
                    else if (wrongAttempts >= 3)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Icon(Icons.close, color: Colors.white, size: 50),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Başka hakkınız kalmadı. Oyun bitti!',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Icon(Icons.check, color: Colors.white, size: 50),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Tebrikler! ${widget.gameTitle} oyununu tamamladınız.',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.questions[currentQuestionIndex]['question'],
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _checkAnswer(true),
                                child: Text('Doğru', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  textStyle: TextStyle(fontSize: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _checkAnswer(false),
                                child: Text('Yanlış', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  textStyle: TextStyle(fontSize: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
