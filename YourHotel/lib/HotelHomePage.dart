import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/FirstPage.dart';
import 'package:yourhotel/GetStatisticsPage.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';


class HotelHomePage extends StatefulWidget{
  final user_map;   final user_id;    final user_ref;
  const HotelHomePage({super.key, required this.user_map, required this.user_id, required this.user_ref});

  @override
  State<StatefulWidget> createState() {
    return HotelHomePageState(this.user_map, this.user_id, this.user_ref);
  }

}

class HotelHomePageState extends State<HotelHomePage>{
  final user_map;   final user_id;    final user_ref;
  HotelHomePageState(this.user_map, this.user_id, this.user_ref);

  final ValueNotifier<bool> isScheduledPressed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAtHotelYes = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isVisitorLeftYes = ValueNotifier<bool>(false);

  String scheduledVisitorName = "";
  String scheduledVisitorMail = "";
  String scheduledCheckinDate = "";
  bool isNewReservation = false;
  bool isNewVisitor = false;
  bool isVisitorLeft = false;

  List<String> scheduledVisitorNames = ["A", "B", "C", "D"];
  List<String> scheduledVisitorMails = ["aaa@aaa.com", "bbb@bbb.com", "ccc@ccc.com", "ddd@ddd.com"];
  List<String> scheduledCheckinDates = ["1.1.2023", "1.2.2023", "1.3.2023", "1.4.2023", ];

  final _formKey_newVisitor = GlobalKey<FormState>();
  final _formKey_messageToVisitor = GlobalKey<FormState>();
  TextEditingController newVisitor_namer = TextEditingController();
  TextEditingController newVisitor_mailer = TextEditingController();
  TextEditingController newVisitor_dater = TextEditingController();
  TextEditingController messageToVisitor_texter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user_map["userName"]} Homepage"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logOut();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only( top: 20.0, bottom: 20),
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.notification_important,
                      size: 30, color: Colors.blueGrey ),
                  label: Text( MyInheritor.of(context)?.langEng != true ? "Bildirimler" : "Notifications",
                      style: const TextStyle( fontWeight: FontWeight.bold,
                          color: Colors.blueGrey, fontSize: 18, decoration: TextDecoration.underline)),
                  onPressed: (){

                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.message_outlined,
                      size: 30, color: Colors.blueGrey ),
                  label: Text( MyInheritor.of(context)?.langEng != true ? "Mesajlar" : "Messages",
                      style: const TextStyle( fontWeight: FontWeight.bold,
                          color: Colors.blueGrey, fontSize: 18, decoration: TextDecoration.underline)),
                  onPressed: (){

                  },
                ),
              ],
            ),
          ),

          Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox( height: 80, width: 180,
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white, size: 30,),
                      label: Text( MyInheritor.of(context)?.langEng != true ? "Yeni Rezervasyon Ekle"
                          : "Add New Visitor", textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                      style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        elevation: MaterialStateProperty.all(50), ),
                      onPressed: () {
                        isNewReservation= true;
                        isNewVisitor = false;
                        isVisitorLeft = false;

                        addNewVisitor();
                      }
                  ),
                ),
                SizedBox( height: 80, width: 180,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.query_stats_sharp, color: Colors.white, size: 30,),
                    label: Text(MyInheritor.of(context)?.langEng != true ? "İstatistikleri al"
                        : "Get Statistics", textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                    style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                      elevation: MaterialStateProperty.all(50), ),
                    onPressed: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context) => GetStatisticsPage(
                        user_map: user_map, user_id: user_id, user_ref: user_ref,
                      )));
                    },
                  ),
                ),
              ]
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: SizedBox( height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month, color: Colors.white, size: 40,),
                label: Text(MyInheritor.of(context)?.langEng != true ? "Gelen Rezervasyonlar"
                    : "Reservations Incoming", textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  elevation: MaterialStateProperty.all(50), ),
                onPressed: (){
                  isScheduledPressed.value = !isScheduledPressed.value;
                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isScheduledPressed,
            builder: (context, value, child){
              return Visibility( visible: isScheduledPressed.value == true ? true : false,
                child: Padding(
                  padding:const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                  child: Card(
                    elevation: 50, color: Colors.green.shade800,
                    child: SizedBox( height: 310,
                      child: ListView(
                        children: [

                          const SizedBox(height: 20,),
                          ListTile(
                            title: Center(
                              child: Text( MyInheritor.of(context)?.langEng != true ? "Planlanmış rezervasyonlarınız "
                                  "gösterilmektedir. İşlem yapmak istediğiniz rezervasyonunuza tıklayınız."
                                  : "Your scheduled reservations are being shown. Click on the reservation that you "
                                  "want work on.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
//buraya StreamBuilder ile rezervasyonlar eklenecek.
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0,),
                              child: SizedBox( height: 200,
                                child: ListView.builder(
                                  itemCount: scheduledVisitorNames.length,
                                  itemBuilder: (context, index){
                                    return Card(
                                      elevation: 10, shadowColor: Colors.white, color: Colors.green.shade100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.green.shade100,
                                          title: Text(scheduledVisitorNames[index],
                                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
                                          subtitle: Wrap(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text( MyInheritor.of(context)?.langEng != true ? "Giriş Tarihi: "
                                                      : "Checkin Date: "),
                                                ),
                                                Text(scheduledCheckinDates[index], style: const TextStyle(fontSize: 20),)
                                              ]),
                                          onTap: (){
                                            scheduledReservationPressed(index);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              title: Center(
                child: Text("Otelinize giriş yapan son ziyaretçi olarak ${user_map["lastVisitor_checkIn"].toString().toUpperCase()} "
                    "kişisini bildirdiniz.", textAlign: TextAlign.center,
                  style: TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo)
                ),
              )
            ),
          ),

          ValueListenableBuilder(
            valueListenable: isScheduledPressed,
            builder: (context, value, child){
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  right: 20, left: 20,),
                child: Card( elevation: 10,
                  child: ListTile(
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent.shade700),
                        elevation:  MaterialStateProperty.all<double>(20),
                      ),
                      child: Text( MyInheritor.of(context)?.langEng != true
                          ? "Evet": "Yes",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      onPressed: (){
                        isAtHotelYes.value = !isAtHotelYes.value;
                      },
                    ),
                    tileColor: Colors.green,
                    title: Text( MyInheritor.of(context)?.langEng != true ? "Yeni ziyaretçileriniz mi var?"
                        : "New visitors to Your Hotel?",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,
                        decoration: TextDecoration.underline,),),
                    subtitle: Column(
                      children: [
                        Text( MyInheritor.of(context)?.langEng != true ? "Yeni ziyaretçilerinizi ekleyerek onlarla daha "
                            "hızlı iletişim kurabilmek için *EVET* butonuna tıklayınız."
                            : "Click the *YES* button to add your new visitors and communicate with them faster.",
                          style: const TextStyle(color: Colors.black, fontSize: 15,),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                    onTap: (){},
                  ),

                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isAtHotelYes,
            builder: (context, value, child){
              return Visibility( visible: isAtHotelYes.value == false ? false : true,
                child: Padding(
                  padding:const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                  child: Card(
                    elevation: 50, color: Colors.green.shade800,
                    child: SizedBox( height: 310,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Center(
                              child: Text( MyInheritor.of(context)?.langEng != true
                                  ? "Planlanmış rezervasyonlarınız gösterilmektedir. Bulunduğunuz otel "
                                  "listede ise seçiniz, değilse *Yeni Otel Ekle* butonundan eklebilirsiniz."
                                  : "Your scheduled reservations are being shown. Select the hotel you are staying "
                                  "if it is on the list, if not you can add the hotel using *Add New Hotel* button.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
//buraya StreamBuilder ile ezervasyonlar eklenecek.
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0,),
                              child: SizedBox( height: 200,
                                child: SizedBox( height: 180,
                                  child: ListView.builder(
                                    itemCount: scheduledVisitorNames.length,
                                    itemBuilder: (context, index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Visibility( visible: index == 0 ? true : false,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty
                                                      .all<Color>(Colors.greenAccent.shade700),
                                                  elevation:  MaterialStateProperty.all<double>(15),
                                                ),
                                                child: Text( MyInheritor.of(context)?.langEng != true ? "Yeni Ziyaretçi Ekle"
                                                    : "Add New Hotel",
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                onPressed: (){
                                                  isNewReservation = false;
                                                  isNewVisitor = true;
                                                  isVisitorLeft = false;

                                                  addNewVisitor();
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              tileColor: Colors.green.shade100,
                                              title: Text(scheduledVisitorNames[index],
                                                style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
                                              subtitle: Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Text(MyInheritor.of(context)?.langEng != true
                                                          ? "E-mail adresi: ": "E-mail adress: ",),
                                                    ),
                                                    Text(scheduledVisitorMails[index],
                                                      style: const TextStyle(fontSize: 20),)
                                                  ]),
                                              onTap: (){
                                                atHotelPressed(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                      },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 50, right: 50),
            child: SizedBox( height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.groups, color: Colors.white, size: 40,),
                label: Text(MyInheritor.of(context)?.langEng != true ? "Mevcut Ziyaretçiler"
                    : "Current Visitors", textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                  elevation: MaterialStateProperty.all(50), ),
                onPressed: (){
                  isScheduledPressed.value = !isScheduledPressed.value;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only( top: 20, right: 20, left: 20,),
            child: Card( elevation: 10,
              child: ListTile(
                trailing: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    elevation:  MaterialStateProperty.all<double>(20),
                  ),
                  child: Text( MyInheritor.of(context)?.langEng != true
                      ? "Evet": "Yes",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  onPressed: (){
                    isVisitorLeftYes.value = !isVisitorLeftYes.value;
                  },
                ),
                tileColor: Colors.orange,
                title: Text( MyInheritor.of(context)?.langEng != true ? "Ayrılan ziyaretçileriniz mi var?"
                    : "You got visitors who has left?",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,
                    decoration: TextDecoration.underline,),),
                subtitle: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text( MyInheritor.of(context)?.langEng != true ? "Ziyaretçilerinizin ayrıldığını bildirmek için *EVET*"
                        "butonuna tıklayın."
                        : "Click the *YES* button to let us know that your visitors has left.",
                      style: const TextStyle(color: Colors.black, fontSize: 15,),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
                onTap: (){

                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isVisitorLeftYes,
            builder: (context, value, child){
              return Visibility( visible: isVisitorLeftYes.value == false ? false : true,
                child: Padding(
                  padding:const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                  child: Card(
                    elevation: 50, color: Colors.orange.shade800,
                    child: SizedBox( height: 310,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Center(
                              child: Text( MyInheritor.of(context)?.langEng != true
                                  ? "Mevcut ziyaretçileriniz gösterilmektedir. Ayrılan ziyaretçi "
                                  "listede ise seçiniz, değilse *Ayrılan Ziyaretçi Ekle* butonundan eklebilirsiniz."
                                  : "Your current visitors are being shown. Select the visitor that has left "
                                  "if it is on the list, if not you can add the one using *Add the Visitor Left* button.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
//buraya StreamBuilder ile ezervasyonlar eklenecek.
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0,),
                              child: SizedBox( height: 200,
                                child: SizedBox( height: 180,
                                  child: ListView.builder(
                                    itemCount: scheduledVisitorNames.length,
                                    itemBuilder: (context, index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Visibility( visible: index == 0 ? true : false,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty
                                                      .all<Color>(Colors.orange),
                                                  elevation:  MaterialStateProperty.all<double>(15),
                                                ),
                                                child: Text( MyInheritor.of(context)?.langEng != true ? "Ayrılan Ziyaretçi Ekle"
                                                    : "Add the Visitor Left",
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                onPressed: (){
                                                  isNewReservation = false;
                                                  isNewVisitor = false;
                                                  isVisitorLeft = true;

                                                  addNewVisitor();
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              tileColor: Colors.orange.shade100,
                                              title: Text(scheduledVisitorNames[index],
                                                style: TextStyle(color:Colors.orange.shade800, fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
                                              subtitle: Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Text(MyInheritor.of(context)?.langEng != true
                                                          ? "E-mail adresi: ": "E-mail adress: ",),
                                                    ),
                                                    Text(scheduledVisitorMails[index],
                                                      style: const TextStyle(fontSize: 20),)
                                                  ]),
                                              onTap: (){
                                                isVisitorLeft = true;

                                                atHotelPressed(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
                title: Center(
                  child: Text("Otelinizden çıkış yapan son ziyaretçi olarak "
                      "${user_map["lastVisitor_checkOut"].toString().toUpperCase()} "
                      "kişisini bildirdiniz.", textAlign: TextAlign.center,
                      style: TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo)
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();

    MyInheritor.of(context)?.isVisitor == null;
    MyInheritor.of(context)?.isHotel == null;
    MyInheritor.of(context)?.userName = null;
    MyInheritor.of(context)?.userMail = null;
    MyInheritor.of(context)?.uid = null;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FirstPage()));
  }

  void scheduledReservationPressed(int index) {}

  void addNewVisitor() async {

    AlertDialog alertDialog = AlertDialog(
      title: Text( isVisitorLeft != true ? "Yeni Ziyaretçi Ekle" : "Ayrılan Ziyaretçi Ekle"),
      content: Form(
        key: _formKey_newVisitor,
        child: SizedBox( height: 250, width: 400,
          child: Column(
            children: [
              TextFormField(
                controller: newVisitor_namer,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true ? "ziyaretçinin adı"
                        : "The visitor Name",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true ? "ziyaretçinin adını girin"
                      : "type the visitor name";
                  } else { return null; }
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: newVisitor_mailer,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true ? "ziyaretçinin mail e-adresi"
                        : "the visitor e-mail adress",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true ? "ziyaretçinin e-mailini girin"
                      : "type the visitor e-mail adress";
                  } else { return null; }
                },
              ),const SizedBox(height: 20,),
              TextFormField(
                controller: newVisitor_dater,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true
                        ? isVisitorLeft == false ? "checkin tarihi gg.aa.yy olarak giriniz"
                        : "checkout tarihini gg.aa.yy olarak giriniz"
                        : isVisitorLeft == false ? "type the checkin like date mm.dd.yy": "type the checkout like date mm.dd.yy",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true
                      ? isVisitorLeft == false ? "checkin tarihini girin" : "checkout tarihini gg.aa.yy girin"
                      : isVisitorLeft == false ? "type the checkin date": "type the checkout date";
                  } else { return null; }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent.shade700)
          ),
          child: Text( MyInheritor.of(context)?.langEng != true ? "Onayla" : "Confirm"),
          onPressed: () async {
            if (_formKey_newVisitor.currentState!.validate()){
              _formKey_newVisitor.currentState!.save();
              scheduledVisitorName = newVisitor_namer.text.trim().toLowerCase();
              scheduledVisitorMail = newVisitor_mailer.text.trim().toLowerCase();
              scheduledCheckinDate = newVisitor_dater.text.trim().toLowerCase();

              print(scheduledVisitorName);

              if (isNewReservation == true){

                print(scheduledVisitorMail);

                await FirebaseFirestore.instance.collection("hotelUsers").doc(user_id).collection("reservations").add({
                  "hotelName": scheduledVisitorName, "hotelMail": scheduledVisitorName,
                  "scheduledCheckinDate_S": scheduledCheckinDate, "addedDate_S": DateTime.now(),
                });

                if (scheduledVisitorMails.contains(scheduledVisitorMail) && scheduledCheckinDate.contains(scheduledCheckinDate)){

                  AlertDialog alertDialog = const AlertDialog(
                    title: Text("otel ve checkin tarihi aynı olan bir rezervasyonunuz zaten bulunmaktadır. rezervasyonda "
                        "hata olduğunu düşünüyorsanız ekli olanın bilgilerini güncelleyebilirsiniz."),
                  ); showDialog(context: context, builder: (_) => alertDialog);

                } else {
                  print(scheduledCheckinDate);

                  scheduledVisitorNames.add(scheduledVisitorName);
                  scheduledVisitorMails.add(scheduledVisitorMail);
                  scheduledCheckinDates.add(scheduledCheckinDate);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("rezervasyon başarıyla eklendi.")));
                }

                isAtHotelYes.value = false;
              }
            }

          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void atHotelPressed(int index) {
    AlertDialog alertDialog = AlertDialog(
      title: Center(
        child: Text( MyInheritor.of(context)?.langEng != true
            ? isVisitorLeft == false ? "Bilgileri onaylayın. Ziyaretçinin de sizi"
            " onaylamasının ardından zayaretçi ile kolayca iletişim geçebilirsiniz."
            : "Bilgileri verilen ziyaretçinin ayrıldığını onaylayın."
            : isVisitorLeft == false ? "Confirm the infos. You can communicate with the hotel easily after it confirms "
            "you, too.": "Confirm the visitor whose infos given has left.",
          textAlign: TextAlign.center,
          style: TextStyle( color: isVisitorLeft == false ? Colors.green.shade800: Colors.orange.shade800,
              fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      content: SizedBox( height: 80,
        child: Column(
          children: [
            ListTile(
              tileColor: isVisitorLeft == false ? Colors.green.shade100: Colors.orange.shade100,
              title: Text(scheduledVisitorNames[index],
                style: TextStyle(color: isVisitorLeft == false ? Colors.green.shade800: Colors.orange.shade800,
                    fontWeight: FontWeight.w700, decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
              subtitle: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text( MyInheritor.of(context)?.langEng != true ? "E-mail adresi: ": "E-mail adress: "),
                    ),
                    Text(scheduledVisitorMails[index],
                      style: const TextStyle(fontSize: 20),)
                  ]),
              onTap: (){

              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: isVisitorLeft == false ? MaterialStateProperty.all<Color>(Colors.greenAccent.shade700)
                  : MaterialStateProperty.all<Color>(Colors.orange.shade700),
          ),
          child: Text( MyInheritor.of(context)?.langEng != true ? "Onayla" : "Confirm"),
          onPressed: (){
            isAtHotelYes.value = false;
            isVisitorLeft = false;
            Navigator.of(context, rootNavigator: true).pop("dialog");
          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

}
