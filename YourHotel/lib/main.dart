// *visitorRegisterda formlar validate olmuyor, yaş ve cinsiyet seçimi zorunlu tutulacak.
// *hotelRegisterda sorun var. bişiler null dönüyor
//
// *VİSİTORHOMEPAGE
// *yeni rezervasyon ekle dendiğinde dialog içerisinde otelin mail adresi ve checkin date stenecek.
// eklendiğinde otel planlanmış rezervasyonlara eklenecek ve onay bildirimi gidecek.
// *geçmiş rezervasyonlarda otellerin adları listelenecek ve turist bunlara tıklayarak bakabilecek.
// *planlanmış rezervasyonlarda turist otele tıkladığında otelin sayfasına gidebilecek yada doğrudan
// mesaj atabilecek.
// *şuan bir oteldemisiniz evete tıklandığında önce dialog içerisinde planlanmış rezervasyonlardaki oteller gelecek.
// onların seçimi olabilecek. bir de liste dışından otel ekleme butonu getirilecek. liste dışından otel
// eklendiğinde eklenen otele de onay bildirimi gidecek. listeden otel seçildiğinde direkt iletişim
// butonları görünür hale gelecek yada yeni sayfaya geçilecek.
// *bildirimler yapılacak
//
//
// *HOTELHOMEPAGE
// *bildirimler
// *yeni ziyaretçi ekle
// *geçmiş ziyaretçilerin analizleri:
//   burada toplam gelen ziyaretçi sayısı, ülke, bölge, şehir, kasabalara ayrılarak verilecek.
//   Tüm talepler kategorize edilerek analizi verilecek.
// *gelecek ziyaretçiler:
//   geleceği kesinleşmiş ziyaretçilerin tamamı ayrı bir sayfada listelenecek. listeleme yaklaşan tarihe göre
//   yapılacak. mesaj gönderen turistin rengi farklı olacak. turiste tıklandığında kayıt esnasında girdiği bilgiler
//   gösterilecek yada profil sayfasına gidilecek. ayrıca filtrelere göre en çok bulunabileceği talepler
//   listesi verilecek.


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/FirstPage.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyInheritor(child: YourHotel()));
}

class YourHotel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Your Hotel",
      theme: ThemeData(),
      home: FirstPage(),
    );
  }
}