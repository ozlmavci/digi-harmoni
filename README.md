# Digi-Harmoni

Digi-Harmoni, kullanıcıların **dijital güvenlik**, **siber zorbalık** ve **kişisel veri koruma** gibi konularda bilinçlenmelerini sağlamak amacıyla tasarlanmış bir **Dijital Farkındalık Mobil Uygulaması**dır. Uygulama, eğitici modüller ve oyunlarla dijital farkındalığı artırmayı hedeflemektedir.

---

## Özellikler

### Splash Sayfası
- Uygulama açılışında özel olarak tasarlanan bir **Splash sayfası** gösterilmektedir.
- Bu sayfada, uygulamaya ait logo yer alır.

### Kullanıcı Giriş ve Kayıt Sistemi
#### Login Sayfası
- Kullanıcılar, kayıt sırasında belirttikleri **e-mail** ve **şifre** ile giriş yapabilir.
- Firebase Authentication kullanılarak güvenli giriş sağlanmıştır.
- Giriş yapıldığında, kullanıcılar ilk olarak **Modüller Sayfası**na yönlendirilir.

#### Register Sayfası
- Kayıt olmayan kullanıcılar, eksiksiz bir form doldurarak kolayca kayıt olabilir.
- **Validasyon kontrolleri:**
  - Şifre en az 6 karakter uzunluğunda olmalıdır.
  - Aynı e-mail adresiyle birden fazla kayıt yapılamaz.
- Kayıt tamamlandığında, **Firestore** veritabanında kullanıcıya özel bir profil oluşturulur ve bilgileri saklanır.

### Modüller Sayfası
- Dijital farkındalığı artırmaya yönelik **eğitici modüller** bulunmaktadır.
- Konu başlıkları:
  - Siber Zorbalık
  - Kişisel Veri Koruma
  - Şifre Yönetimi
  - Dezenformasyon
- Kullanıcılar, modüllerdeki metinleri okuduktan sonra **"Modülü Tamamla"** butonuna basarak modül rozetlerini kazanır.
- Modül içerikleri, yapay zeka destekli olarak oluşturulmuş ve görsellerle desteklenmiştir.

### Oyunlar Sayfası
- Her modüle özel **doğru-yanlış oyunları** içerir.
- Özellikler:
  - Her soru için 30 saniyelik süre.
  - Kullanıcının toplam 3 hakkı vardır.
- Oyun kazanıldığında, başarım bilgisi **Firestore** veritabanına kaydedilir.

### Profil Sayfası
- Kullanıcının:
  - Kişisel bilgileri
  - Kazandığı rozetler
  - Başarımları görüntülenebilir.
- Sağ üstteki **"Düzenle"** butonu ile bilgiler güncellenebilir.
- Kullanıcı istediği zaman **Çıkış** butonuyla hesabından çıkış yapabilir.

---

## Kurulum ve Kullanım

### Gereksinimler
- Flutter SDK
- Firebase Projesi (Authentication ve Firestore Database yapılandırılmış olmalıdır)

### Projeyi Çalıştırmak
1. **Projeyi Klonla:**
   ```bash
   git clone https://github.com/kullanici-adi/digi_harmoni.git
   cd digi_harmoni

2. **Bağımlılıkları Yükle**

Projenin ihtiyaç duyduğu tüm bağımlılıkları yüklemek için aşağıdaki komutu çalıştırın:
    ```bash
    flutter pub get

3. **Firebase Yapılandırması**

Firebase servisini projeye entegre etmek için aşağıdaki adımları izleyin:

- Firebase üzerinde bir proje oluşturun.
- Uygulamanız için gerekli yapılandırma dosyalarını temin edin:
   - **Android**: `google-services.json` dosyasını `android/app/` dizinine ekleyin.
   - **iOS**: `GoogleService-Info.plist` dosyasını `ios/Runner/` dizinine ekleyin.
- Firebase Console'da uygulama ayarlarından doğru SHA-1 ve SHA-256 anahtarlarını eklemeyi unutmayın.
- Firebase'in Flutter ile uyumlu çalışabilmesi için gerekli paketleri projenize eklediğinizden emin olun:
   ```bash
   flutter pub add firebase_core
   flutter pub add firebase_auth
   flutter pub add cloud_firestore
   
4. **Uygulamayı Başlat**
    ```bash
   flutter run

---

## İletişim
Herhangi bir sorunuz, öneriniz veya geri bildiriminiz için benimle iletişime geçebilirsiniz:

- **GitHub:** [Kullanıcı Adınız](https://github.com/ozlemavci)
- **LinkedIn:** [LinkedIn Profiliniz](https://www.linkedin.com/in/ozlem-avci)

