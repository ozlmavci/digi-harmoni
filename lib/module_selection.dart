import 'package:flutter/material.dart';
import 'module_detail.dart';

class ModuleSelection extends StatelessWidget {
  final List<Map<String, String>> modules = [
    {
      'title': 'Siber Zorbalık',
      'description': 'Siber zorbalıkla başa çıkma yollarını öğren.',
      'image': 'assets/images/cyberbullying.jpg', // Görsel yolu
      'text': 'assets/texts/cyberbullying.txt', // Metin yolu
    },
    {
      'title': 'Kişisel Veri Koruma',
      'description': 'Kişisel verilerinizi nasıl koruyacağınızı keşfedin.',
      'image': 'assets/images/data_protection.jpg',
      'text': 'assets/texts/data_protection.txt',
    },
    {
      'title': 'Şifre Yönetimi',
      'description': 'Güvenli şifreler nasıl oluşturulur, öğrenin.',
      'image': 'assets/images/password_management.jpg',
      'text': 'assets/texts/password_management.txt',
    },
    {
      'title': 'Sosyal Medya Güvenliği',
      'description': 'Sosyal medya hesaplarınızı güvenli hale getirin.',
      'image': 'assets/images/social_media_security.jpg',
      'text': 'assets/texts/social_media_security.txt',
    },
    {
      'title': 'Dezenformasyonu Tanıma',
      'description': 'Dezenformasyonu nasıl tanıyacağınızı öğrenin.',
      'image': 'assets/images/recognizing_disinformation.jpg',
      'text': 'assets/texts/recognizing_disinformation.txt',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modül Seçimi'),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(modules[index]['title']!),
              subtitle: Text(modules[index]['description']!),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModuleDetail(
                      title: modules[index]['title']!,
                      image: modules[index]['image']!,
                      text: modules[index]['text']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
