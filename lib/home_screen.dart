import 'package:flutter/material.dart';
import 'module_selection.dart';
import 'game_selection.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Sayfaları listeleyelim
  final List<Widget> _pages = [
    ModuleSelection(), // Modül Seçimi
    GameSelection(), // Oyun Seçimi
    ProfileScreen(), // Profil
  ];

  // Alt menü öğesi tıklama
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Seçilen öğeyi güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Seçilen sayfayı göster

      // Alt menüyü ekliyoruz
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Modüller',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Oyunlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
