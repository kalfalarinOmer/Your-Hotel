import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/FirstPage.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';

class VisitorHomePage extends StatefulWidget{
  final user_map;   final user_id;    final user_ref;
  const VisitorHomePage({super.key, required this.user_map, required this.user_id, required this.user_ref});

  @override
  State<StatefulWidget> createState() {
    return VisitorHomePageState(this.user_map, this.user_id, this.user_ref);
  }
}

class VisitorHomePageState extends State<VisitorHomePage>{

  final user_map;   final user_id;    final user_ref;
  VisitorHomePageState(this.user_map, this.user_id, this.user_ref);

  final ValueNotifier<bool> isScheduledPressed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAtHotelYes = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAtHotelConfirmed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isQuickDemandPressed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isQuickMessageToHotel = ValueNotifier<bool>(false);

  List<String> scheduledHotelNames = ["hotel a", "Hotel B", "Hotel C", "Hotel D"];
  List<String> scheduledHotelMails = ["aaa@aaa.com", "bbb@bbb.com", "ccc@ccc.com", "ddd@ddd.com"];
  List<String> scheduledCheckinDates = ["1.1.2023", "1.2.2023", "1.3.2023", "1.4.2023", ];
  List<String> demanCategories_E = ["room", "cooking", "drinking", "snacks","activities", "informing",
    "transport", "others"];
  List<String> roomDemandList_E = ["clean my room", "change my bedspreads", "i want snacks", "my fridge is empty",
    "internet problems", "TV problems", "elektric/light problems", "others"];

  String scheduledHotelName = "";
  String scheduledHotelMail = "";
  String scheduledCheckinDate = "";
  bool isNewReservation = false;
  bool isNewHotel = false;

  final _formKey_newHotel = GlobalKey<FormState>();
  final _formKey_messageToHotel = GlobalKey<FormState>();
  TextEditingController newHotel_namer = TextEditingController();
  TextEditingController newHotel_mailer = TextEditingController();
  TextEditingController newHotel_dater = TextEditingController();
  TextEditingController messageToHotel_titler = TextEditingController();
  TextEditingController messageToHotel_texter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user_map["userName"]} HomePage"),
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
          TextButton.icon(
            icon: const Icon(Icons.notification_important,
                size: 30, color: Colors.blueGrey ),
            label: Text( MyInheritor.of(context)?.langEng != true ? "Bildirimler" : "Notifications",
                style: const TextStyle( fontWeight: FontWeight.bold,
                color: Colors.blueGrey, fontSize: 18, decoration: TextDecoration.underline)),
            onPressed: (){

            },
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text( MyInheritor.of(context)?.langEng != true ? "* Okunmamış bildirimleriniz bulunmaktadır!"
                  : "* You have unread notifications",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 15),),
            ),
          ),
          Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox( height: 80, width: 180,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white, size: 30,),
                    label: Text( MyInheritor.of(context)?.langEng != true ? "Yeni Rezervasyon Ekle"
                        : "Add New Resarvation", textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                    style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                      elevation: MaterialStateProperty.all(50), ),
                    onPressed: () {
                      isNewReservation = true;
                      isNewHotel = false;
//REZERVASYON EKLENMESİ İÇİN ÖNCE OTEL MAİL VE CHECKIN TUTUYOR MU KONTROL ET.
                      addNewHotel();
                    }
                  ),
                ),
                SizedBox( height: 80, width: 180,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.timelapse, color: Colors.white, size: 30,),
                    label: Text(MyInheritor.of(context)?.langEng != true ? "Geçmiş Rezervasyonlarım"
                        : "My Past Reservations ", textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),),
                    style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                      elevation: MaterialStateProperty.all(50), ),
                    onPressed: (){

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
                label: Text(MyInheritor.of(context)?.langEng != true ? "Planlanmış Rezervasyonlarım"
                    : "My Scheduled Reservations ", textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
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
                    elevation: 50, color: Colors.indigo,
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
                                  itemCount: scheduledHotelNames.length,
                                  itemBuilder: (context, index){
                                    return Card(
                                      elevation: 10, shadowColor: Colors.white, color: Colors.blue.shade100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.blue.shade100,
                                          title: Text(scheduledHotelNames[index],
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
          ValueListenableBuilder(
            valueListenable: isScheduledPressed,
            builder: (context, value, child){
              return Padding(
                padding: EdgeInsets.only(
                    top: isScheduledPressed.value == true ? 10.0 : 50,
                    right: 20, left: 20,),
                child: Card(
                  elevation: 10,
                  child: ValueListenableBuilder(
                    valueListenable: isAtHotelConfirmed,
                    builder: (context, value, child){
                      return ListTile(
                        trailing: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: isAtHotelConfirmed.value == false ?
                            MaterialStateProperty.all<Color>(Colors.greenAccent.shade700)
                                : MaterialStateProperty.all<Color>(Colors.orange),
                            elevation:  MaterialStateProperty.all<double>(20),
                          ),
                          child: Text( MyInheritor.of(context)?.langEng != true
                              ? isAtHotelConfirmed.value == false
                              ?  "Evet" : "Ayrıldım"
                              : isAtHotelConfirmed.value == false
                              ? "Yes" : "I LEFT",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          onPressed: (){

                            if (isAtHotelYes.value == false) {
                              if (isAtHotelConfirmed.value == false){
                                isAtHotelYes.value = true;
                              }
                            } else {
                              if (isAtHotelConfirmed.value == true){
                                isAtHotelYes.value = false;
                                isAtHotelConfirmed.value = false;
                                isQuickDemandPressed.value = false;
                              }
                            }

                          },
                        ),
                        tileColor: isAtHotelConfirmed.value != true ? Colors.green : Colors.orange,
                        title: Text( isAtHotelConfirmed.value != true
                            ? MyInheritor.of(context)?.langEng != true ? "Şu an bir otelde konaklıyor musunuz?"
                            : "Are you currently staying in a hotel?"
                            : MyInheritor.of(context)?.langEng != true ? "Şu an Hotel A otelinde konaklamaktasınız."
                            : "You are currently staying in Hotel A.",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,
                            decoration: TextDecoration.underline,),),
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Text( isAtHotelConfirmed.value != true
                                ? MyInheritor.of(context)?.langEng != true ? "Otel ile daha hızlı iletişim kurabilmek için "
                                "*EVET* butonuna tıklayınız."
                                : "Click on the *YES* button to comminucate with the hotel faster."
                                : MyInheritor.of(context)?.langEng != true
                                ? "Otelden ayrıldıysanız *AYRILDIM* butonuna tıklayınız."
                                : "Click on the *I LEFT* button if you have left the hotel",
                              style: const TextStyle(color: Colors.black, fontSize: 15,),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                        onTap: (){},
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isAtHotelYes,
            builder: (context, value, child){
//isAtHotelConfirmed true ise visibility false olacak
              return ValueListenableBuilder(
                valueListenable: isAtHotelConfirmed,
                builder: (context, value, child){
                  return Visibility( visible: isAtHotelYes.value == false ? false
                      : isAtHotelConfirmed.value == false ? true : false,
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
//buraya StreamBuilder ile rezervasyonlar eklenecek.
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 15.0,),
                                  child: SizedBox( height: 200,
                                    child: SizedBox( height: 180,
                                      child: ListView.builder(
                                        itemCount: scheduledHotelNames.length,
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
                                                    child: Text( MyInheritor.of(context)?.langEng != true ? "Yeni Otel Ekle"
                                                        : "Add New Hotel",
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                    onPressed: (){
                                                      isNewReservation = false;
                                                      isNewHotel = true;

                                                      addNewHotel();
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  tileColor: Colors.green.shade100,
                                                  title: Text(scheduledHotelNames[index],
                                                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700,
                                                        decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
                                                  subtitle: Wrap(
                                                      children: [
                                                         Padding(
                                                          padding: const EdgeInsets.only(top: 8.0),
                                                          child: Text(MyInheritor.of(context)?.langEng != true
                                                              ? "E-mail adresi: ": "E-mail adress: ",),
                                                        ),
                                                        Text(scheduledHotelMails[index],
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
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isAtHotelConfirmed,
            builder: (context, value, builder){
              return Visibility( visible: isAtHotelConfirmed.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox( height: 80, width: 180,
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.question_answer, color: Colors.white, size: 30,),
                              label: Text( MyInheritor.of(context)?.langEng != true ? "Hızlı Talep"
                                  : "Quick Demand", textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                              style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                elevation: MaterialStateProperty.all(50), ),
                              onPressed: () {
                                isQuickMessageToHotel.value = false;
                                isQuickDemandPressed.value = !isQuickDemandPressed.value;
                              }
                          ),
                        ),
                        SizedBox( height: 80, width: 180,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.outgoing_mail, color: Colors.white, size: 30,),
                            label: Text(MyInheritor.of(context)?.langEng != true ? "Mesaj Gönder"
                                : "Send Message", textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),),
                            style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              elevation: MaterialStateProperty.all(50), ),
                            onPressed: (){
                              isQuickDemandPressed.value = false;
                              isQuickMessageToHotel.value = !isQuickMessageToHotel.value;
                            },
                          ),
                        ),
                      ]
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isQuickDemandPressed,
            builder: (context, value, child){
              return Visibility( visible: isQuickDemandPressed.value == true ? true: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Card(
                    color: Colors.orange,
                    elevation: 10,
                    child: ListTile(
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                          child: Text( MyInheritor.of(context)?.langEng != true ? "Aşağıdaki hızlı taleplerden birini seçin:"
                              : "Choose one of these quick demands:",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                        ),
                      ),
                      subtitle: Container(height: 250,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                          itemCount: demanCategories_E.length,
                          itemBuilder: (context, index){
                            return ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Colors.indigo),
                              ),
                              onPressed: (){
                                index == 0 ? getDemandList(index) : updateAlert();
                              },
                              child: Text( demanCategories_E[index],
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: isQuickMessageToHotel,
            builder: (context, value, child){
              return Visibility( visible: isQuickMessageToHotel.value == true ? true: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Card(
                    color: Colors.orange,
                    elevation: 10,
                    child: ListTile(
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10, top: 10),
                          child: Text( MyInheritor.of(context)?.langEng != true ? "Aşağıdaki forma iletmek istediğiniz "
                              "mesajınızı yazınız."
                              : "Write the message you want to send in the form below.",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                        ),
                      ),
                      subtitle: SizedBox(
                        child: Container(height: 150,
                          child: ListView(
                            children: [
                              Form(
                                key: _formKey_messageToHotel,
                                child: Card( color: Colors.white, elevation: 20,
                                  child: TextFormField(
                                    controller: messageToHotel_texter,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      labelText: MyInheritor.of(context)?.langEng != true ? "mesajınzda sade ve kibar olunuz."
                                          : "be simple and polite in your message.",
                                        labelStyle: TextStyle( fontStyle: FontStyle.italic, backgroundColor: Colors.white),
                                      border: OutlineInputBorder()
                                    ),
                                    validator: (value){
                                      if (value == null){
                                        return MyInheritor.of(context)?.langEng != true ? "mesaj alanı boş bırakılamaz."
                                            : "Message field can't be left empty.";
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Align( alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(Icons.send, color: Colors.indigo, size: 30,),
                                  onPressed: (){},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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

  void updateAlert() {
    AlertDialog alertDialog = const AlertDialog(
      title: Text("Bu özellik şimdilik aktif değildir. Yeni güncellemeleri bekleyiniz."),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void scheduledReservationPressed(int index) {

  }

  void addNewHotel() async {

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Yeni Otel Ekle"),
      content: Form(
        key: _formKey_newHotel,
        child: SizedBox( height: 250, width: 400,
          child: Column(
            children: [
              TextFormField(
                controller: newHotel_namer,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true ? "otelin adı"
                        : "The Hotel Name",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true ? "otelin adını girin"
                      : "type the hotel name";
                  } else { return null; }
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: newHotel_mailer,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true ? "otelin mail e-adresi"
                        : "the hotel e-mail adress",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true ? "otelin e-mailini girin"
                      : "type the hotel e-mail adress";
                  } else { return null; }
                },
              ),const SizedBox(height: 20,),
              TextFormField(
                controller: newHotel_dater,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText:  MyInheritor.of(context)?.langEng != true ? "checkin tarihi gg.aa.yy"
                        : "the checkin date mm.dd.yy",
                    labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                ),
                validator: (value) {
                  if(value == null){ return MyInheritor.of(context)?.langEng != true ? "checkin tarihi giriniz"
                      : "type the checkin date";
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
            if (_formKey_newHotel.currentState!.validate()){
              _formKey_newHotel.currentState!.save();
              scheduledHotelName = newHotel_namer.text.trim().toLowerCase();
              scheduledHotelMail = newHotel_mailer.text.trim().toLowerCase();
              scheduledCheckinDate = newHotel_dater.text.trim().toLowerCase();

              print(scheduledHotelName);

              if (isNewReservation == true){

                print(scheduledHotelMail);

                await FirebaseFirestore.instance.collection("touristUsers").doc(user_id).collection("reservations").add({
                  "hotelName": scheduledHotelName, "hotelMail": scheduledHotelMail,
                  "scheduledCheckinDate_S": scheduledCheckinDate, "addedDate_S": DateTime.now(),
                });

                if (scheduledHotelMails.contains(scheduledHotelMail) && scheduledCheckinDate.contains(scheduledCheckinDate)){

                  AlertDialog alertDialog = const AlertDialog(
                    title: Text("otel ve checkin tarihi aynı olan bir rezervasyonunuz zaten bulunmaktadır. rezervasyonda "
                        "hata olduğunu düşünüyorsanız ekli olanın bilgilerini güncelleyebilirsiniz."),
                  ); showDialog(context: context, builder: (_) => alertDialog);

                } else {
                  print(scheduledCheckinDate);

                  scheduledHotelNames.add(scheduledHotelName);
                  scheduledHotelMails.add(scheduledHotelMail);
                  scheduledCheckinDates.add(scheduledCheckinDate);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("rezervasyon başarıyla eklendi.")));
                }

              }

              isAtHotelConfirmed.value = true;
              Navigator.of(context, rootNavigator: true).pop("dialog");
            }

          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void atHotelPressed(int index) {
    AlertDialog alertDialog = AlertDialog(
      title: Center(
        child: Text( MyInheritor.of(context)?.langEng != true ? "Bilgileri onaylayın. Otelin de sizi "
            "onaylamasının ardından otel ile uygulama üzerinden kolayca iletişime geçebilirsiniz."
            : "Confirm the infos. You can communicate with the hotel easily after it confirms you, too.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      content: SizedBox( height: 80,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.green.shade100,
              title: Text(scheduledHotelNames[index],
                style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline, fontStyle: FontStyle.italic),),
              subtitle: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text( MyInheritor.of(context)?.langEng != true ? "E-mail adresi: ": "E-mail adress: "),
                    ),
                    Text(scheduledHotelMails[index],
                      style: const TextStyle(fontSize: 20),)
                  ]),
              onTap: (){
                atHotelPressed(index);
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent.shade700)
          ),
          child: Text( MyInheritor.of(context)?.langEng != true ? "Onayla" : "Confirm"),
          onPressed: (){
            isAtHotelConfirmed.value = true;
            Navigator.of(context, rootNavigator: true).pop("dialog");
          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }


  void getDemandList(int index) async {

    Widget DemandList() {
      return Container(
        height: 300, width: 500,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2
          ),
          itemCount: roomDemandList_E.length,
          itemBuilder: (context, index){
            return SizedBox(
              child: Center(
                child: TextButton(
                  child: Text(roomDemandList_E[index], textAlign: TextAlign.center,
                    style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),),
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop("dialog");

                    AlertDialog alertDialog = AlertDialog(
                      title: Center(
                        child: Text( MyInheritor.of(context)?.langEng != true
                            ? "*${roomDemandList_E[index]}* talebiniz başarıyla iletilmiştir. Yoğunluğa göre en kısa sürede "
                            "talebinizi yerine getireceğiz. Aksi durumda yada gerekli görüldüğü takdirde size mesajla "
                            "cevap verilecektir."
                            : "your *${roomDemandList_E[index]}* demand has been sent succesfully. Depending on the density, "
                            "we will make it as soon as possible. Otherwise, or if it is necessary, you will be "
                            "responded by a message.",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                      ),
                    ); showDialog(context: context, builder: (_) => alertDialog);
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    AlertDialog alertdialog = AlertDialog(
      title: Center(
        child: Text( MyInheritor.of(context)?.langEng != true ? "Hızlı talep listesi"
            : "Quick demand List", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      content: DemandList(),
    ); showDialog(context: context, builder: (_) => alertdialog);
  }


}
