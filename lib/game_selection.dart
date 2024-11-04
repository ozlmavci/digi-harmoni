import 'package:flutter/material.dart';
import 'game_detail.dart';

class GameSelection extends StatelessWidget {
  final List<String> gameTitles = [
    'Siber Zorbalık',
    'Kişisel Veri Koruma',
    'Şifre Yönetimi',
    'Sosyal Medya Güvenliği',
    'Dezenformasyonu Tanıma',
  ];

  // Sorular
  final Map<String, List<Map<String, dynamic>>> gameQuestions = {
    'Siber Zorbalık': [
      {'question': 'Siber zorbalık, yalnızca yüz yüze yapılan zorbalık türlerine benzer bir şekilde gerçekleşir.', 'answer': false},
      {'question': 'İnternetin sağladığı anonimlik, zorbalara daha saldırgan davranışlar sergileme cesareti verebilir.', 'answer': true},
      {'question': 'Eğer siber zorbalıkla karşılaşırsan, ailenle ya da öğretmeninle bu durumu paylaşmak iyi bir fikir değildir.', 'answer': false},
      {'question': 'Siber zorbalığın mağdurları, genellikle yüksek özsaygıya sahip bireylerdir.', 'answer': false},
      {'question': 'Siber zorbalıkla mücadelede, açık iletişim kurmak ve farkındalık yaratmak önemlidir.', 'answer': true},
      {'question': 'Zeynep, arkadaşlarının oyun platformunda ona kötü davranmasını önemsememeli, çünkü bu sadece oyun.', 'answer': false},
      {'question': 'Siber zorbalık, sadece psikolojik etkilerle sınırlı kalır ve fiziksel sağlık sorunlarına yol açmaz.', 'answer': false},
      {'question': 'Ali, sosyal medyada tanımadığı birinin ona sürekli kötü yorumlar yaptığını gördü. Bu durum siber zorbalık olarak adlandırılabilir.', 'answer': true},
    ],
    'Kişisel Veri Koruma': [
      {'question': 'Kişisel verileri korumak sadece çevrimiçi yaşamda önemlidir.', 'answer': false},
      {'question': 'Güçlü parolalar, en az sekiz karakter içermeli ve büyük harf, küçük harf, rakam ve sembol içermelidir.', 'answer': true},
      {'question': 'Aynı parolayı birden fazla hesapta kullanmak güvenliği artırır.', 'answer': false},
      {'question': 'Çevrimiçi hesapların gizlilik ayarlarını kontrol etmek, kişisel bilgilerinizi korumanın önemli bir yoludur.', 'answer': true},
      {'question': 'Tanımadığınız kişilerden gelen e-postalardaki bağlantılara tıklamak güvenlidir.', 'answer': false},
      {'question': 'Kişisel bilgilerinizi yalnızca gerekli olduğunda paylaşmak önemlidir.', 'answer': true},
      {'question': 'Cihazlarınızda güncellemeleri düzenli olarak yapmak gereksiz bir iştir.', 'answer': false},
      {'question': 'Veri güvenliği konusunda farkındalığınızı artırmak, çevrimiçi tehditlere karşı hazırlıklı olmanıza yardımcı olur.', 'answer': true},
    ],
    'Şifre Yönetimi': [
      {'question': 'Güvenli bir şifre en az sekiz karakterden oluşmalıdır.', 'answer': true},
      {'question': 'Aynı şifreyi birden fazla hesapta kullanmak güvenliği artırır.', 'answer': false},
      {'question': 'Rastgele karakterlerden oluşan şifreler, tahmin edilmesi zor olduğu için daha güvenlidir.', 'answer': true},
      {'question': 'Parola yöneticileri, şifrelerinizi güvenli bir şekilde saklamanıza yardımcı olabilir.', 'answer': true},
      {'question': 'Ahmet, bir hesabının güvenliğinden şüphelendiğinde şifresini değiştirmemelidir.', 'answer': false},
      {'question': 'Sibel, "KedimBeyaz" cümlesini "K3d!mB3y@z" şeklinde değiştirerek daha güvenli bir şifre oluşturmuştur. Bu doğru bir yaklaşımdır.', 'answer': true},
      {'question': 'Elif, her hesabı için aynı şifreyi kullanmakta ve bunu sorun etmiyor. Bu durum onun güvenliğini tehlikeye atar.', 'answer': true},
      {'question': 'İki faktörlü kimlik doğrulama (2FA) kullanmak, hesabınıza ek bir güvenlik katmanı ekler.', 'answer': true},
    ],
    'Sosyal Medya Güvenliği': [
      {'question': 'Sosyal medya hesapları için güçlü ve karmaşık parolalar kullanmak önemlidir.', 'answer': true},
      {'question': 'Her sosyal medya hesabı için aynı şifreyi kullanmak güvenliği artırır.', 'answer': false},
      {'question': 'Hesabınızın gizlilik ayarlarını gözden geçirmek, paylaştığınız bilgilerin güvenliğini artırır.', 'answer': true},
      {'question': 'Tanımadığınız kişilerden gelen bağlantılara tıklamak güvenlidir.', 'answer': false},
      {'question': 'Ayşe, sosyal medya hesabında tanımadığı bir kişiden gelen mesajı tıklayarak bir bağlantıya girdi. Bu durumda Ayşe, kimlik avı saldırısına maruz kalma riskini artırmıştır.', 'answer': true},
      {'question': 'İki faktörlü kimlik doğrulama (2FA) kullanmak, hesabınıza giriş yaparken ek bir güvenlik katmanı sağlar.', 'answer': true},
      {'question': 'Paylaştığınız kişisel bilgileri sosyal medya üzerinden paylaşmak güvenlidir.', 'answer': false},
      {'question': 'Mehmet, sosyal medya hesabında bir izinsiz giriş olduğunu fark ettiğinde hemen şifresini değiştirmelidir.', 'answer': true},
    ],
    'Dezenformasyonu Tanıma': [
      {'question': 'Dezenformasyon, doğru bilgilerin yayılmasıdır.', 'answer': false},
      {'question': 'Dezenformasyonun arkasında siyasi veya ekonomik motivasyonlar olabilir.', 'answer': true},
      {'question': 'Bilgiyi paylaşmadan önce kaynağını kontrol etmek önemlidir.', 'answer': true},
      {'question': 'Duygusal bir dil kullanımı, dezenformasyonun bir belirtisi olabilir.', 'answer': true},
      {'question': 'Görsel içerikler, dezenformasyonun yayılmasına katkıda bulunamaz.', 'answer': false},
      {'question': 'Sadece tanınmış haber kaynaklarından gelen bilgiler güvenilirdir.', 'answer': false},
      {'question': 'Duygusal tepkilere neden olan bilgiler, genellikle doğru bilgilerdir.', 'answer': false},
      {'question': 'Dijital okuryazarlık becerilerini geliştirmek dezenformasyonla başa çıkmaya yardımcı olabilir.', 'answer': true},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oyunlar'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: gameTitles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(gameTitles[index]),
              trailing: Icon(Icons.play_arrow),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetail(
                      gameTitle: gameTitles[index],
                      questions: gameQuestions[gameTitles[index]]!,
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
