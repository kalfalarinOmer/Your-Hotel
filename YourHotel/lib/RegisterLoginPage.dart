

import 'package:yourhotel/FirstPage.dart';
import 'package:yourhotel/VisitorHomePage.dart';
import 'package:yourhotel/HotelHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';

class RegisterLoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return RegisterLoginPageState();
  }
}

class RegisterLoginPageState extends State<RegisterLoginPage>{

  List<String> facilityTypes_T = ["Otel", "Butik Otel", "Motel", "Tatil Köyü", "Pansiyon", "Apart Otel",
    "Yurt", "Kamp Tesisi", "Villa-Ev-Daire", "Misafirhane"];
  List<String> facilityTypes_E = ["Hotel", "Butique Hotel", "Motel", "Resort", "Hostel", "Apart Hotel",
    "Dormitory", "Camping", "Village-House-Apartment", "Guest House"];

  List<String> serviceTypes_T = ["Sadece Konaklama", "Oda-Kahvaltı", "Yarım Pansiyon", "Tam Pansiyon",
    "Herşey Dahil", "Ultra Herşey Dahil"];
  List<String> serviceTypes_E = ["Just Bed", "Bed&Breakfast", "Half Board", "Full Board", "All Inclusive",
    "Ultra All Inclusive"];

  List<String> orgTypes_T = ["Kamu", "Belediye", "Vakıf", "Özel"];
  List<String> orgTypes_E = ["Official", "Municipality", "Foundation", "Private"];

  List<String> ageRange = ["-18", "18-23", "24-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "61-65",
    "66-70", "+70",];

  List<String> optionalZone_titles_T = ["Evli misiniz: ", "Çocuk sayısı: ", "Favori spor aktiviteleriniz: ",
    "Favori boş etkinlikleriniz: ", "Favori yemek türleriniz: ", "Favori içecek türlerinizi: ", "Favori atıştırmalıklarınız",
    "Favori renkleriniz: ", "Kronik rahatsızlıklarınız: ",];
  List<String> optionalZone_titles_E = ["You married?: ", "Kid Count: ", "Favourite Sport Activities: ",
    "Favourite Spare Time activities: ", "Favourite Food Types: ", "Favourite Drink Types: ", "Favourite Snacks",
    "Favourite colors: ", "Chronic Diseases: ",];

  List<List<String>> optionalZone_answers_T = [
    ["Evet", "Hayır"],
    ["0", "1", "2", "3", "+4"],
    ["Yüzme", "Dalış", "Koşu", "Yürüyüş", "Tırmanma", "Bisiklete binme", "Futbol", "Basketbol", "Voleybol",
      "Jimnastik", "Yoga", "Pilates", "Diğerleri"],
    ["Spor Aktiviteleri", "Kitap Okuma", "Bilgisayar aktiviteleri", "Akıllı Telefon aktiviteleri", "Fotoğrafçılık",
      "TV izleme", "Alışveriş", "Balıkçılık", "Avlanma", "Diğerleri", ],
    ["Et Türleri", "Sebze Türleri", "Balık Türleri", "Tavuk Türleri", "Et-Sebze Karışık", "Fast Food", ],
    ["Alkollü içecekler", "Bira", "Kola", "Meyve Suları", "Enerji içecekleri", "Kahve", "Çay", "Yeşil Çay",
      "Organik içecekler"],
    ["Çikolata Barlar", "Gofretler", "Bisküviler", "Krakerler", "kuruyemiş", "Dondurma", "kurabiye", "cips",
      "kek-pasta", "kuru meyve"],
    ["kırmızı", "mavi", "yeşil", "pembe", "siyah", "gri", "kahverengi", "beyaz", "sarı"],
    ["baş ağrısı", "bel problemleri", "sırt ağrısı", "boyun ağrısı", "nefes problemleri", "böbrek hastalıkları",
      "boğaz hastalıkları", "bacak ağrıları", "ayak ağrıları", "karaciğer hastalıkları", "kalp hastalıkları",
      "diyabet", "düzensiz tansiyon", "migren"],
  ];
  List<List<String>> optionalZone_answers_E = [
    ["Yes", "No"],
    ["0", "1", "2", "3", "+4"],
    ["Swimming", "Diving", "Running", "Walking", "Climbing", "Riding Bike", "Football", "Basketball", "Voleyball",
      "Gymnastics", "Yoga", "Pilates", "Others"],
    ["Sport activities", "Reading", "Computure activities", "Smartphone activities", "Taking Photos", "Watching",
      "Shopping", "Fishing", "Haunting", "Others", ],
    ["Meat Types", "Vegetable Types", "Fish Types", "Chicken Types", "Meat-Vegetable Mixed", "Fast Food", ],
    ["Drinks with Alcohol", "Beer", "Cola", "Fruit Juice", "Energy Drink", "Cofee", "Tea", "Green Tea", "Organic Drinks"],
    ["Chocolate bars", "wafers", "biscuits", "crackers", "nuts", "ice creams", "cookies", "chips", "cakes", "dry fruits"],
    ["red", "blue", "green", "pink", "black", "grey", "brown", "white", "yellow"],
    ["headache", "low-back problems", "backache", "neck pain", "breathing problems", "kidney diseases", "stomach diseases",
      "leg diseases", "foot diseases", "liver diseases", "heart diseases", "diabetes", "disordered tension", "migraine"],
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namer = TextEditingController();
  final TextEditingController _mailer = TextEditingController();
  final TextEditingController _passworder = TextEditingController();
  final TextEditingController _countrier = TextEditingController();
  final TextEditingController _stater = TextEditingController();
  final TextEditingController _citier = TextEditingController();
  final TextEditingController _towner = TextEditingController();
  final TextEditingController _adresser = TextEditingController();

  final ScrollController _optionalListTitlesController = ScrollController();
  final ScrollController _answerController_0 = ScrollController();
  final ScrollController _answerController_1 = ScrollController();
  final ScrollController _answerController_2 = ScrollController();
  final ScrollController _answerController_3 = ScrollController();
  final ScrollController _answerController_4 = ScrollController();
  final ScrollController _answerController_5 = ScrollController();
  final ScrollController _answerController_6 = ScrollController();
  final ScrollController _answerController_7 = ScrollController();
  final ScrollController _answerController_8 = ScrollController();

  List<ScrollController> _optionalListAnswersController = [];

  bool isRegister = false;    bool isLogin = false;

  bool isHotel = false;   bool isButique = false;   bool isMotel = false;   bool isResort = false;
  bool isHostel = false;    bool isApart = false;   bool isDorm = false;    bool isCamping = false;
  bool isVha = false;   bool isGuestHouse = false;
  String facilityType = "";

  bool isJB = false;   bool isBB = false;   bool isHB = false;    bool isFB = false;
  bool isAI = false;    bool isUAI = false;
  String serviceType = "";

  bool isOfficial = false;    bool isMunicipality = false;    bool isFoundation = false;
  bool isPrivate = false;
  String orgType = "";

  String country0 = ""; String state0 = "";  String city0 = "";  String town0 = "";  String adress = "";

  bool isSelected_age = false;
  String selectedAge = "";
  bool isSelected_genderMale = false;
  bool isSelected_genderFemale = false;
  String selectedGender = "";

  bool isSelected_married = false;
  bool isSelected_kid = false;
  String selectedKid = "";
  bool isSelected_sport = false;
  List<String> selectedSports = [];
  bool isSelected_spare = false;
  List<String> selectedSpares = [];
  bool isSelected_food = false;
  List<String> selectedFoods = [];
  bool isSelected_drink = false;
  List<String> selectedDrinks = [];
  bool isSelected_snack = false;
  List<String> selectedSnacks = [];
  bool isSelected_color = false;
  List<String> selectedColors = [];
  bool isSelected_desease = false;
  List<String> selectedDeseases = [];

  int selectedIndex = 0;
  int selectedIndex_facility = 0;
  int selectedIndex_service = 0;
  int selectedIndex_org = 0;

  int selectedIndex_title = 0;
  int selectedIndex_answer = 0;

  List<String> selectedIndexes_optionalZone = [];

  @override
  Widget build(BuildContext context) {

    _optionalListAnswersController = [ _answerController_0, _answerController_1,
      _answerController_2, _answerController_3, _answerController_4, _answerController_5,
      _answerController_6, _answerController_7, _answerController_8
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade800,
        title: Center( child: Text(
          MyInheritor.of(context)?.langEng != true
              ? MyInheritor.of(context)?.isVisitor == true
              ? "Ziyaretçi Kayıt/Giriş" : "Otel Kayıt/Giriş"
              : MyInheritor.of(context)?.isVisitor == true
              ? "Visitor Register/Login" : "Hotel Register/Login"
        )),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              logOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Form( key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 50,),
//UserName
                Visibility( visible: isRegister == false && isLogin == false ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _namer,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: MyInheritor.of(context)?.isHotel == true
                              ? MyInheritor.of(context)?.langEng != true ? "Otelinizin adı" : "Your Hotel Name"
                              : MyInheritor.of(context)?.langEng != true ? "Ad-Soyadınız" : "Your Name-Surname",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return MyInheritor.of(context)?.isHotel == true
                              ? MyInheritor.of(context)?.langEng != true ? "Otelinizin adını girmelisiniz"
                              : "You should type your Hotel name."
                              : MyInheritor.of(context)?.langEng != true ? "Ad-Soyad girmelisiniz"
                              : "You should type your name-surname";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//mail
                Visibility( visible: isRegister == false && isLogin == false ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _mailer,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: MyInheritor.of(context)?.isHotel == true
                              ? MyInheritor.of(context)?.langEng != true ? "Otelin E-mail adresi"
                              : "Hotel E-mail adress"
                              : MyInheritor.of(context)?.langEng != true ? "E-mail adresiniz"
                              : "Your E-mail adress",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return MyInheritor.of(context)?.isHotel == true
                              ? MyInheritor.of(context)?.langEng != true ? "Otelin E-mail adresini girmelisiniz."
                              : "You shold type Hotel E-mail adress"
                              : MyInheritor.of(context)?.langEng != true ? "E-mail adresinizi girmelisiniz"
                              : "You should type E-mail adress";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//password
                Visibility( visible: isRegister == false && isLogin == false ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _passworder,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: MyInheritor.of(context)?.langEng != true ? "Şifre" : "Password",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          hintText: MyInheritor.of(context)?.langEng != true
                              ? "en az 6 karakter girilmelidir ve boşluk kullanmayınız"
                              : "At least 6 characters should be typed and don't use space.",
                          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value!.isEmpty){ return MyInheritor.of(context)?.langEng != true ? "Şifrenizi girmelisiniz"
                            : "you should a password.";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//işletme türü seçimi
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isHotel == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text( MyInheritor.of(context)?.langEng != true ? "Tesis Türünüzü Seçiniz:"
                                : "Choose your facility type:",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                        ),
                        subtitle: Container(height: 300,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 2.8,),
                            itemCount: facilityTypes_T.length,
                            itemBuilder: (context, index){
                              return TextButton(
                                onPressed: (){
                                  chooseTheFacilityType(index);
                                },
                                child: Text( MyInheritor.of(context)?.langEng != true ? facilityTypes_T[index]
                                    : facilityTypes_E[index],
                                  style: TextStyle(fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      fontSize: index == selectedIndex_facility ? 22 : 17,
                                      color: index == selectedIndex_facility ? Colors.green : Colors.blue),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//hizmet türü seçimi
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isHotel == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text( MyInheritor.of(context)?.langEng != true ? "Hizmet Türünüzü Seçiniz:"
                                : "Choose your service type:",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                        ),
                        subtitle: Container(height: 200,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 2.8, mainAxisSpacing: 5),
                            itemCount: serviceTypes_T.length,
                            itemBuilder: (context, index){
                              return TextButton(
                                onPressed: (){
                                  chooseTheServiceType(index);
                                },
                                child: Text( MyInheritor.of(context)?.langEng != true ? serviceTypes_T[index]
                                    : serviceTypes_E[index],
                                  style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline,
                                      fontSize: index == selectedIndex_service ? 22 : 17,
                                      color: index == selectedIndex_service ? Colors.green : Colors.blue),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//kurum seçimi
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isHotel == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text( MyInheritor.of(context)?.langEng != true ? "Kurum Türünüzü Seçiniz:"
                                : "Choose your organization type:",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                        ),
                        subtitle: Container(height: 150,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 2.8, mainAxisSpacing: 5),
                            itemCount: orgTypes_T.length,
                            itemBuilder: (context, index){
                              return TextButton(
                                onPressed: (){
                                  chooseTheOrgType(index);
                                },
                                child: Text( MyInheritor.of(context)?.langEng != true ? orgTypes_T[index]
                                    : orgTypes_E[index],
                                  style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline,
                                      fontSize: index == selectedIndex_org ? 22 : 17,
                                      color: index == selectedIndex_org ? Colors.green : Colors.blue),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),

                Visibility( visible: isRegister == true ? true : false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                      child: Text(MyInheritor.of(context)?.langEng != true ? "Adresinizi giriniz:"
                          : "Type your adress",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                    ),
                  ),
                ),
//ÜLKE GİRİŞİ
                Visibility( visible: isRegister == true ? true : false,
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: _countrier,
                        onTap: (){
                          if (MyInheritor.of(context)?.isHotel == true){
                            AlertDialog alertDialog = AlertDialog(
                                title: Text( MyInheritor.of(context)?.langEng != true
                                    ? "Your Hotel uygulaması sadece Türkiye'deki oteller için kullanılabilirdir. "
                                    "Bu yüzden ülkeniz varsayılan olarak Türkiye seçilmiştir ve değiştirilemez."
                                    : "Your Hotel App is only used for the hotels in Turkey. Therefore Your Country has been "
                                    "chosen as Turkey as default and it can't be changed.",
                                  style: TextStyle(color: Colors.red, fontSize: 18), textAlign: TextAlign.justify,)
                            ); showDialog(context: context, builder: (_)=>alertDialog);
                          }
                        },
                        readOnly: MyInheritor.of(context)?.isHotel == true ? true : false,
                        decoration: InputDecoration(
                            labelText:  MyInheritor.of(context)?.langEng != true
                                ? MyInheritor.of(context)?.isVisitor != true ? "Türkiye"
                                : "ülke"
                                : MyInheritor.of(context)?.isVisitor == true ? "Your Country"
                                : "Turkey",
                            hintText: MyInheritor.of(context)?.langEng != true
                                ? MyInheritor.of(context)?.isVisitor != true ? "Türkiye"
                                : "ülke"
                                : MyInheritor.of(context)?.isVisitor == true ? "Your Country"
                                : "Turkey",
                            labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                        ),
                        validator: (value) {
                          if (MyInheritor.of(context)?.isHotel == true) {
                            MyInheritor.of(context)?.langEng != true ? value = "Türkiye" : "Turkey";
                          } else {
                            if(value == null){ return MyInheritor.of(context)?.langEng != true ? "ülkenizi giriniz"
                                : "type your country";
                            } else { return null; }
                          }

                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//BÖLGE GİRİŞİ
                Visibility( visible: isRegister == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _stater,
                      decoration: InputDecoration(
                          labelText:  MyInheritor.of(context)?.langEng != true ? "Bölgeniz"
                              : "Your State",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "bölge adını giriniz"
                            : "type your state";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//ŞEHİR GİRİŞİ
                Visibility( visible: isRegister == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _citier,
                      decoration: InputDecoration(
                          labelText:  MyInheritor.of(context)?.langEng != true ? "Şehriniz"
                              : "Your City",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "şehir adını giriniz"
                            : "type your adress";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//İLÇE GİRİŞ
                Visibility( visible: isRegister == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _towner,
                      decoration: InputDecoration(
                          labelText: MyInheritor.of(context)?.langEng != true ? "İlçe adını giriniz"
                              : "Type your town",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "ilçe adını giriniz"
                            : "type your town";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
//OTEL AÇIK ADRESİ GİRİŞİ
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isHotel == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _adresser,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: MyInheritor.of(context)?.langEng != true
                              ? "Adresinizin kalan kısmını mahalle, sokak, no ... giriniz"
                              : "Type the rest of your adress such as district, street, no ...",
                          hintText: MyInheritor.of(context)?.langEng != true
                              ? "Göynük mahallesi, 102. sk, no:3 ... gibi"
                              : "Goynuk district, 102. street, no: 3 ... etc.",
                          labelStyle: const TextStyle(color: Colors.purple), border: const OutlineInputBorder(),
                          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          focusedBorder: const OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return "Adresinizin kalan kısmını girmelisiniz.";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isHotel == true ? true : false,
                    child: const SizedBox(height: 30,)),
//YAŞ ARALIĞI GİRİŞİ
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isVisitor == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text( MyInheritor.of(context)?.langEng != true ? "Yaş aralığınızı seçiniz:"
                                : "Choose your age range:",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                        ),
                        subtitle: Container(height: 180,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 2.8,),
                            itemCount: ageRange.length,
                            itemBuilder: (context, index){
                              return TextButton(
                                onPressed: (){
                                  setState(() {
                                    isSelected_age = true;
                                    selectedIndex = index;
                                  });
                                  selectedAge = ageRange[index];
                                },
                                child: Text( ageRange[index],
                                  style: TextStyle(fontWeight: FontWeight.w700,
                                      fontSize: isSelected_age == true && index == selectedIndex ? 22 : 17,
                                      decoration: TextDecoration.underline,
                                      color: isSelected_age == true && index == selectedIndex ? Colors.green : Colors.blue),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//CİNSİYET GİRİŞİ
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isVisitor == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                    child: Card( elevation: 10,
                      child: Center(
                        child: Wrap( spacing: 20,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text( MyInheritor.of(context)?.langEng != true ? "Cinsiyet: ": "Gender: ",
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                            ),
                            TextButton(
                              child: Text( MyInheritor.of(context)?.langEng != true ? "Erkek": "Male",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: isSelected_genderMale == true ? 20 : 17,
                                    decoration: TextDecoration.underline,
                                    color: isSelected_genderMale == true ? Colors.green : Colors.blue ),),
                              onPressed: () async {
                                setState(() {
                                  isSelected_genderMale = true;
                                  isSelected_genderFemale = false;
                                });
                                selectedGender = "male";
                              },
                            ),

                            TextButton(
                              child: Text( MyInheritor.of(context)?.langEng != true ? "Kadın": "Female",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: isSelected_genderFemale == true ? 20 : 17,
                                    decoration: TextDecoration.underline,
                                    color: isSelected_genderFemale == true ? Colors.green : Colors.blue ),),
                              onPressed: () async {
                                setState(() {
                                  isSelected_genderMale = false;
                                  isSelected_genderFemale = true;
                                });
                                selectedGender = "female";
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
//OPSİYONEL GİRİŞLER
                Visibility( visible: isRegister == true && MyInheritor.of(context)?.isVisitor == true ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 20),
                    child: Card( color: Colors.greenAccent,
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: Text( MyInheritor.of(context)?.langEng != true ? "Bu alanı doldurmanız opsiyoneldir. "
                                "Fakat buradaki bilgileriniz ile otelinizden daha kaliteli ve size özel hizmet almanız "
                                "mümkündür."
                                : "This zone is optional. However you can get more qualified and more personalized "
                                "service with your informations here from your hotel.", textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 15),),
                          ),
                        ),
                        subtitle: Container(height: 600,
                          child: Scrollbar(
                            thumbVisibility: true, controller: _optionalListTitlesController,
                            child: ListView.builder(
                              controller: _optionalListTitlesController,
                              itemCount: optionalZone_titles_T.length,
                              itemBuilder: (context, i){
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0, left: 5, right: 15, bottom: 8,),
                                  child: Card( elevation: 10,
                                    child: ListTile(
                                      title: Text( MyInheritor.of(context)?.langEng != true
                                          ? optionalZone_titles_T[i]: optionalZone_titles_E[i],
                                        style: const TextStyle(fontWeight: FontWeight.bold),),
                                      subtitle: SizedBox(
                                        height: i == 0 ? 50 : i == 1 ? 100 : 200,
                                        child: Scrollbar(
                                          controller: _optionalListAnswersController[i], thumbVisibility: true,
                                          child: GridView.builder(
                                            controller: _optionalListAnswersController[i],
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: i == 1 || i == 7 ? 3 : 2,
                                              childAspectRatio: 2,),
                                            itemCount: optionalZone_answers_T[i].length,
                                            itemBuilder: (context, j){
                                              return TextButton(
                                                onPressed: (){

                                                  onOptionalZonePressed(i, j);

                                                },
                                                child: Text( MyInheritor.of(context)?.langEng != true
                                                    ? optionalZone_answers_T[i][j]: optionalZone_answers_E[i][j],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle( fontWeight: FontWeight.w700,
                                                      decoration: TextDecoration.underline,
                                                      fontSize: selectedIndexes_optionalZone
                                                          .contains("${i.toString()}${j.toString()}") ? 22: 17,
                                                      color: selectedIndexes_optionalZone
                                                          .contains("${i.toString()}${j.toString()}") ? Colors.green: Colors.blue),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//KAYIT/GİRİŞ BUTONLARI
                Center(
                  child: Wrap( spacing: 20,
                    children: [
                      Visibility( visible: isLogin == true ? false : true,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.green,
                          heroTag: "kaydol",
                          icon: const Icon(Icons.add),
                          label: Text( MyInheritor.of(context)?.langEng != true ? "KAYDOL": "REGISTER",
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                          onPressed: () async {

                            if (isRegister == false) {
                              setState(() {
                                isRegister = true;
                                isLogin = false;
                              });
                            } else if (isRegister == true) {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                if (MyInheritor.of(context)?.isVisitor == true){
                                  register();
                                } else if (MyInheritor.of(context)?.isHotel == true){
                                  register();
                                  print(facilityType);
                                }
                              }
                            }
                          },
                        ),
                      ),

                      Visibility( visible: isRegister == true ? false : true,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.blue,
                          heroTag: "giris",
                          icon: const Icon(Icons.login),
                          label: Text( MyInheritor.of(context)?.langEng != true ? "GİRİŞ YAP"
                              : "LOGIN",
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (isLogin == false) {
                                setState(() {
                                  isRegister = false;
                                  isLogin = true;
                                });
                              } else if (isLogin == true) {
                                logIn();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
//ŞİFREMİ SIFIRLA BUTONU
                Visibility( visible: isLogin == false ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Align( alignment: Alignment.centerRight,
                      child: MaterialButton(
                        child: Text( MyInheritor.of(context)?.langEng != true ? "Şifremi Sıfırla"
                            : "Reset My Password",
                          style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, fontSize: 20),),
                        onPressed: () async {
/*
                          Widget setupAlertDialogContainer() {
                            return Container(
                              height: 200, width: 300,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("users").where("userName",
                                      isEqualTo: _namer.text.trim()).snapshots(),
                                  builder: (context, snapshot){
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator(),);
                                    } else if (snapshot.hasError) {
                                      return Center(child: Icon(Icons.error, size: 40),);
                                    } else if (snapshot.data == null) {
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                    final querySnapshot = snapshot.data;
                                    return Container(
                                      child: querySnapshot.size == 0 ? Center(
                                        child: ListTile(
                                          leading: Icon(Icons.warning, color: Colors.red,),
                                          title: Text( MyInheritor.of(context).langEng != true ?
                                          "Kullanıcı adı bulunamadı. Lütfen forma girdiğiniz kullanıcı adınızı"
                                              "kontrol ediniz."
                                              : "Username can not be found. Please check your username that you typed"
                                              " in the Form.",
                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,),
                                        ),
                                      ):
                                      ListView.builder(
                                          itemCount: querySnapshot.size,
                                          itemBuilder: (BuildContext context, int index){
                                            final map = querySnapshot.docs[index].data();
                                            final id = querySnapshot.docs[index].id;
                                            return Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(_namer.text.trim(),
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                                                    onTap: ()async{
                                                      Navigator.of(context, rootNavigator: true).pop("dialog");

                                                      print(map["userMail"]);
                                                      reset_password(_namer.text.trim(), map, id);

                                                    },),
                                                  Divider(thickness: 1,),]);
                                          }),
                                    );

                                  }),
                            );
                          }
                          showDialog(context: context, builder: (_) {
                            return AlertDialog(
                              title: Column(children: [
                                Text( MyInheritor.of(context).langEng != true ? "ŞİFREMİ SIFIRLA " : "RESET MY PASSWORD"),
                                SizedBox(height: 10,),
                                Text( MyInheritor.of(context).langEng != true ?
                                "Kullanıcı adınıza tıklayarak şifre sıfırlama işleminizi başlatabilirsiniz."
                                    : "You can start your password reset process by clicking on your username.",
                                  style: TextStyle(color: Colors.orange, fontSize: 15, ),),
                              ]),
                              content: setupAlertDialogContainer(),
                            );
                          });

 */
                        },
                      ),
                    ),
                  ),
                ),
              ],)
        ),
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

  void register() async {

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _mailer.text.trim(), password: _passworder.text.trim()
      );

      final User? user = userCredential.user;

      if (user != null){

        MyInheritor.of(context)?.userName = _namer.text.trim();
        MyInheritor.of(context)?.userMail = _mailer.text.trim();
        MyInheritor.of(context)?.uid = user.uid;

        country0 = _countrier.text.trim().toLowerCase();
        state0 = _stater.text.trim().toLowerCase();
        city0 = _citier.text.trim().toLowerCase();
        town0 = _towner.text.trim().toLowerCase();

        if (MyInheritor.of(context)?.isVisitor == true) {

          DocumentReference ref_user = await FirebaseFirestore.instance.collection("touristUsers").add({
            "userName": MyInheritor.of(context)?.userName, "userMail": user.email, "registerDate": DateTime.now(),
            "userAuthid": user.uid, "country0": country0, "state0": state0, "city0": city0, "town0": town0,
            "selectedAge": selectedAge, "selectedGender": selectedGender, "isSelected_married": isSelected_married,
            "selectedKid": selectedKid, "selectedSports": selectedSports, "selectedSpares": selectedSpares,
            "selectedFoods": selectedFoods, "selectedDrinks": selectedDrinks, "selectedSnacks": selectedSnacks,
            "selectedColors": selectedColors, "selectedDeseases": selectedDeseases,
          });

        } else if (MyInheritor.of(context)?.isHotel == true) {

          adress = _adresser.text.trim().toLowerCase();

          DocumentReference ref_user = await FirebaseFirestore.instance.collection("hotelUsers").add({
            "userName": MyInheritor.of(context)?.userName, "userMail": user.email, "registerDate": DateTime.now(),
            "userAuthid": user.uid, "country0": country0, "state0": state0, "city0": city0, "town0": town0,
            "adress": adress, "facilityType": facilityType, "serviceType": serviceType, "orgType": orgType,
          });
        }

        logOut();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, elevation: 50,
          content: Text( MyInheritor.of(context)?.langEng != true ? "KAYDINIZ BAŞARIYLA GERÇEKLEŞTİRİLDİ. "
              "ŞİMDİ UYGULAMAYA TEKRAR GİRİŞ YAPARAK KULLANMAYA BAŞLAYABİLRİSNİZ.": "YOUR REGISTRATION HAS BEEN "
              "SUCCESFULLY COMPLETED. NOW YOU CAN USE THE APPLICATION BY LOGIN AGAIN.",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          duration: const Duration(seconds: 15),
          action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
        ));
      }

    } catch (e) {

      AlertDialog alertDialog = AlertDialog(
        title: const Text("Error"),
        content: Text(e.toString(), style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ); showDialog(context: context, builder: (_) => alertDialog);
    }

  }

  void logIn() async {
    dynamic user_map;   dynamic user_id;    dynamic user_ref;

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _mailer.text.trim(), password: _passworder.text.trim()
      );
      final User? user = userCredential.user;

      if (user != null) {
        MyInheritor.of(context)?.userName = _namer.text.trim();
        MyInheritor.of(context)?.userMail = _mailer.text.trim();
        MyInheritor.of(context)?.uid = user.uid;

        if (MyInheritor.of(context)?.isVisitor) {

          await FirebaseFirestore.instance.collection("touristUsers").where("userMail",
              isEqualTo: MyInheritor.of(context)?.userMail ).get().then((users) => users.docs.forEach((_user) {
            user_map = _user.data();
            user_id = _user.id;
            user_ref = _user.reference;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                VisitorHomePage(user_map: user_map, user_id: user_id, user_ref: user_ref,)));

          }));

        } else if (MyInheritor.of(context)?.isHotel) {

          await FirebaseFirestore.instance.collection("hotelUsers").where("userMail",
              isEqualTo: MyInheritor.of(context)?.userMail ).get().then((users) => users.docs.forEach((_user) {
            user_map = _user.data();
            user_id = _user.id;
            user_ref = _user.reference;

            _user.reference.collection("takenNotifications").where("isAnswered", isEqualTo: false).get()
                .then((givers) => givers.docs.forEach((giver) {

            }));

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                HotelHomePage(user_map: user_map, user_id: user_id, user_ref: user_ref)));

          }));

        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, elevation: 50,
          content: Text( MyInheritor.of(context)?.langEng != true ? "Hoşgeldiniz ${MyInheritor.of(context)?.userName}"
              : "Welcome ${MyInheritor.of(context)?.userName}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          duration: const Duration(seconds: 15),
          action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
        ));

      }

    } catch (e) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text("Error"),
        content: Text(e.toString(), style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ); showDialog(context: context, builder: (_) => alertDialog);
    }

  }

  void updateAlert() {
    AlertDialog alertDialog = const AlertDialog(
      title: Text("Bu özellik şimdilik aktif değildir. Yeni güncellemeleri bekleyiniz."),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void onOptionalZonePressed(int i, int j) {

    if(selectedIndexes_optionalZone.contains("${i.toString()}${j.toString()}")){
      selectedIndexes_optionalZone.remove("${i.toString()}${j.toString()}");
      print(selectedIndexes_optionalZone);
    } else {
      selectedIndexes_optionalZone.add("${i.toString()}${j.toString()}");
      print(selectedIndexes_optionalZone);
    }

    selectedIndex_title = i;
    selectedIndex_answer = j;

    if (MyInheritor.of(context)?.langEng == true) {
      if (i == 0){
        j == 0 ? isSelected_married = true : false;
      }
      if (i == 1){
        j == 0 ? selectedKid = "0"
            : j == 1 ? selectedKid = "1"
            : j == 2 ? selectedKid = "2"
            : j == 3 ? selectedKid = "3"
            : "+4";
      }
      if (i == 2){
        if (j == 0){ !selectedSports.contains("swimming") ? selectedSports.add("swimming")
            : selectedSports.remove("swimming"); }
        if (j == 1){ !selectedSports.contains("diving") ? selectedSports.add("diving")
            : selectedSports.remove("diving"); }
        if (j == 2){ !selectedSports.contains("running") ? selectedSports.add("running")
            : selectedSports.remove("running"); }
        if (j == 3){ !selectedSports.contains("walking") ? selectedSports.add("walking")
            : selectedSports.remove("walking"); }
        if (j == 4){ !selectedSports.contains("climbing") ? selectedSports.add("climbing")
            : selectedSports.remove("climbing"); }
        if (j == 5){ !selectedSports.contains("riding bike") ? selectedSports.add("riding bike")
            : selectedSports.remove("riding bike"); }
        if (j == 6){ !selectedSports.contains("football") ? selectedSports.add("football")
            : selectedSports.remove("football"); }
        if (j == 7){ !selectedSports.contains("basketball") ? selectedSports.add("basketball")
            : selectedSports.remove("basketball"); }
        if (j == 8){ !selectedSports.contains("voleyball") ? selectedSports.add("voleyball")
            : selectedSports.remove("voleyball"); }
        if (j == 9){ !selectedSports.contains("gymnastics") ? selectedSports.add("gymnastics")
            : selectedSports.remove("gymnastics"); }
        if (j == 10){ !selectedSports.contains("yoga") ? selectedSports.add("yoga"): selectedSports.remove("yoga"); }
        if (j == 11){ !selectedSports.contains("pilates") ? selectedSports.add("pilates"): selectedSports.remove("pilates"); }
        if (j == 12){ !selectedSports.contains("others") ? selectedSports.add("others")
            : selectedSports.remove("others"); }

      }
      if (i == 3){
        if (j == 0){ !selectedSpares.contains("sport activities") ? selectedSpares.add("sport activities")
            : selectedSpares.remove("sport activities"); }
        if (j == 1){ !selectedSpares.contains("reading") ? selectedSpares.add("reading")
            : selectedSpares.remove("reading"); }
        if (j == 2){!selectedSpares.contains("computer activities") ? selectedSpares.add("computer activities")
            : selectedSpares.remove("computer activities"); }
        if (j == 3){ !selectedSpares.contains("smartphone activities") ? selectedSpares.add("smartphone activities")
            : selectedSpares.remove("smartphone activities"); }
        if (j == 4){!selectedSpares.contains("taking photos") ? selectedSpares.add("taking photos")
            : selectedSpares.remove("taking photos"); }
        if (j == 5){ !selectedSpares.contains("watching") ? selectedSpares.add("watching")
            : selectedSpares.remove("watching"); }
        if (j == 6){ !selectedSpares.contains("shopping") ? selectedSpares.add("shopping")
            : selectedSpares.remove("shopping"); }
        if (j == 7){ !selectedSpares.contains("fishing") ? selectedSpares.add("fishing")
            : selectedSpares.remove("fishing"); }
        if (j == 8){ !selectedSpares.contains("haunting") ? selectedSpares.add("haunting")
            : selectedSpares.remove("haunting"); }
        if (j == 9){ !selectedSpares.contains("others") ? selectedSpares.add("others")
            : selectedSpares.remove("others"); }
      }
      if (i == 4){
        if (j == 0){ !selectedFoods.contains("meat types") ? selectedFoods.add("meat types")
            : selectedFoods.remove("meat types"); }
        if (j == 1){ !selectedFoods.contains("vegatable types") ? selectedFoods.add("vegatable types")
            : selectedFoods.remove("vegatable types"); }
        if (j == 2){ !selectedFoods.contains("fish types") ? selectedFoods.add("fish types")
            : selectedFoods.remove("fish types"); }
        if (j == 3){ !selectedFoods.contains("chicken types") ? selectedFoods.add("chicken types")
            : selectedFoods.remove("chicken types"); }
        if (j == 4){ !selectedFoods.contains("meat-vegetable mixed") ? selectedFoods.add("meat-vegetable mixed")
            : selectedFoods.remove("meat-vegetable mixed"); }
        if (j == 5){ !selectedFoods.contains("fast food") ? selectedFoods.add("fast food")
            : selectedFoods.remove("fast food"); }
      }
      if (i == 5){
        if (j == 0){ !selectedDrinks.contains("drinks with alcohol") ? selectedDrinks.add("drinks with alcohol")
            : selectedDrinks.remove("drinks with alcohol"); }
        if (j == 1){ !selectedDrinks.contains("beer") ? selectedDrinks.add("beer")
            : selectedDrinks.remove("beer"); }
        if (j == 2){ !selectedDrinks.contains("cola") ? selectedDrinks.add("cola")
            : selectedDrinks.remove("cola"); }
        if (j == 3){ !selectedDrinks.contains("fruit juice") ? selectedDrinks.add("fruit juice")
            : selectedDrinks.remove("fruit juice"); }
        if (j == 4){ !selectedDrinks.contains("energy drink") ? selectedDrinks.add("energy drink")
            : selectedDrinks.remove("energy drink"); }
        if (j == 5){ !selectedDrinks.contains("cofee") ? selectedDrinks.add("cofee") : selectedDrinks.remove("cofee"); }
        if (j == 6){ !selectedDrinks.contains("tea") ? selectedDrinks.add("tea") : selectedDrinks.remove("tea"); }
        if (j == 7){ !selectedDrinks.contains("green tea") ? selectedDrinks.add("green tea")
            : selectedDrinks.remove("green tea"); }
        if (j == 8){ !selectedDrinks.contains("organic drinks") ? selectedDrinks.add("organic drinks")
            : selectedDrinks.remove("organic drinks"); }
      }
      if (i == 6){
        if (j == 0){ !selectedSnacks.contains("chocolate bars") ? selectedSnacks.add("chocolate bars")
            : selectedSnacks.remove("chocolate bars"); }
        if (j == 1){ !selectedSnacks.contains("wafers") ? selectedSnacks.add("wafers")
            : selectedSnacks.remove("wafers"); }
        if (j == 2){ !selectedSnacks.contains("biscuits") ? selectedSnacks.add("biscuits")
            : selectedSnacks.remove("biscuits"); }
        if (j == 3){ !selectedSnacks.contains("crakers") ? selectedSnacks.add("crakers")
            : selectedSnacks.remove("crakers"); }
        if (j == 4){ !selectedSnacks.contains("nuts") ? selectedSnacks.add("nuts")
            : selectedSnacks.remove("nuts"); }
        if (j == 5){ !selectedSnacks.contains("ice creams") ? selectedSnacks.add("ice creams")
            : selectedSnacks.remove("ice creams"); }
        if (j == 6){ !selectedSnacks.contains("cookies") ? selectedSnacks.add("cookies")
            : selectedSnacks.remove("cookies"); }
        if (j == 7){ !selectedSnacks.contains("chips") ? selectedSnacks.add("chips") : selectedSnacks.add("chips"); }
        if (j == 8){ !selectedSnacks.contains("cakes") ? selectedSnacks.add("cakes")
            : selectedSnacks.remove("cakes"); }
        if (j == 9){ !selectedSnacks.contains("dry fruits") ? selectedSnacks.add("dry fruits")
            : selectedSnacks.remove("dry fruitse"); }
      }
      if (i == 7){
        if (j == 0){ !selectedColors.contains("red") ? selectedColors.add("red") : selectedColors.remove("red"); }
        if (j == 1){ !selectedColors.contains("blue") ? selectedColors.add("blue") : selectedColors.remove("blue"); }
        if (j == 2){ !selectedColors.contains("green") ? selectedColors.add("green") : selectedColors.remove("green"); }
        if (j == 3){ !selectedColors.contains("pink") ? selectedColors.add("pink") : selectedColors.remove("pink"); }
        if (j == 4){ !selectedColors.contains("black") ? selectedColors.add("black") : selectedColors.remove("black"); }
        if (j == 5){ !selectedColors.contains("grey") ? selectedColors.add("grey") : selectedColors.remove("grey"); }
        if (j == 6){ !selectedColors.contains("brown") ? selectedColors.add("brown")
            : selectedColors.remove("brown"); }
        if (j == 7){ !selectedColors.contains("white") ? selectedColors.add("white") : selectedColors.remove("white"); }
        if (j == 8){ !selectedColors.contains("yellow") ? selectedColors.add("yellow") : selectedColors.remove("yellow"); }
      }
      if (i == 8){
        if (j == 0){ !selectedDeseases.contains("headache") ? selectedDeseases.add("headache")
            : selectedDeseases.remove("headache"); }
        if (j == 1){ !selectedDeseases.contains("low-back problems") ? selectedDeseases.add("low-back problems")
            : selectedDeseases.remove("low-back problems"); }
        if (j == 2){ !selectedDeseases.contains("backache") ? selectedDeseases.add("backache")
            : selectedDeseases.remove("backache"); }
        if (j == 3){ !selectedDeseases.contains("neck pain") ? selectedDeseases.add("neck pain")
            : selectedDeseases.remove("neck pain"); }
        if (j == 4){ !selectedDeseases.contains("breathing problems") ? selectedDeseases.add("breathing problems")
            : selectedDeseases.remove("breathing problems"); }
        if (j == 5){ !selectedDeseases.contains("kidney diseases") ? selectedDeseases.add("kidney diseases")
            : selectedDeseases.remove("kidney diseases"); }
        if (j == 6){ !selectedDeseases.contains("stomach diseases") ? selectedDeseases.add("stomach diseases")
            : selectedDeseases.remove("stomach diseases"); }
        if (j == 7){ !selectedDeseases.contains("leg diseases") ? selectedDeseases.add("leg diseases")
            : selectedDeseases.remove("leg diseases"); }
        if (j == 8){ !selectedDeseases.contains("leg diseases") ? selectedDeseases.add("leg diseases")
            : selectedDeseases.remove("leg diseases"); }
        if (j == 9){ !selectedDeseases.contains("liver diseases") ? selectedDeseases.add("liver diseases")
            : selectedDeseases.remove("liver diseases"); }
        if (j == 10){ !selectedDeseases.contains("heart diseases") ? selectedDeseases.add("heart diseases")
            : selectedDeseases.remove("heart diseases"); }
        if (j == 11){ !selectedDeseases.contains("diabetes") ? selectedDeseases.add("diabetes")
            : selectedDeseases.remove("diabetes"); }
        if (j == 12){ !selectedDeseases.contains("disordered tension") ? selectedDeseases.add("disordered tension")
            : selectedDeseases.remove("disordered tension"); }
        if (j == 13){ !selectedDeseases.contains("migraine") ? selectedDeseases.add("migraine")
            : selectedDeseases.remove("migraine"); }
      }
    } else {
      if (i == 0){
        j == 0 ? isSelected_married = true : false;
      }
      if (i == 1){
        j == 0 ? selectedKid = "0"
            : j == 1 ? selectedKid = "1"
            : j == 2 ? selectedKid = "2"
            : j == 3 ? selectedKid = "3"
            : "+4";
      }
      if (i == 2){
        if (j == 0){ !selectedSports.contains("yüzme") ? selectedSports.add("yüzme"): selectedSports.remove("yüzme"); }
        if (j == 1){ !selectedSports.contains("dalış") ? selectedSports.add("dalış"): selectedSports.remove("dalış"); }
        if (j == 2){ !selectedSports.contains("koşu") ? selectedSports.add("koşu"): selectedSports.remove("koşu"); }
        if (j == 3){ !selectedSports.contains("yürüyüş") ? selectedSports.add("yürüyüş"): selectedSports.remove("yürüyüş"); }
        if (j == 4){ !selectedSports.contains("tırmanma") ? selectedSports.add("tırmanma")
            : selectedSports.remove("tırmanma"); }
        if (j == 5){ !selectedSports.contains("bisiklete binme") ? selectedSports.add("bisiklete binme")
            : selectedSports.remove("bisiklete binme"); }
        if (j == 6){ !selectedSports.contains("futbol") ? selectedSports.add("futbol"): selectedSports.remove("futbol"); }
        if (j == 7){ !selectedSports.contains("basketbol") ? selectedSports.add("basketbol")
            : selectedSports.remove("basketbol"); }
        if (j == 8){ !selectedSports.contains("voleybol") ? selectedSports.add("voleybol")
            : selectedSports.remove("voleybol"); }
        if (j == 9){ !selectedSports.contains("jimnastik") ? selectedSports.add("jimnastik")
            : selectedSports.remove("jimnastik"); }
        if (j == 10){ !selectedSports.contains("yoga") ? selectedSports.add("yoga"): selectedSports.remove("yoga"); }
        if (j == 11){ !selectedSports.contains("pilates") ? selectedSports.add("pilates"): selectedSports.remove("pilates"); }
        if (j == 12){ !selectedSports.contains("diğerleri") ? selectedSports.add("diğerleri")
            : selectedSports.remove("diğerleri"); }

      }
      if (i == 3){
        if (j == 0){ !selectedSpares.contains("spor aktiviteleri") ? selectedSpares.add("spor aktiviteleri")
            : selectedSpares.remove("spor aktiviteleri"); }
        if (j == 1){ !selectedSpares.contains("kitap okuma") ? selectedSpares.add("kitap okuma")
            : selectedSpares.remove("kitap okuma"); }
        if (j == 2){!selectedSpares.contains("bilgisayar aktiviteleri") ? selectedSpares.add("bilgisayar aktiviteleri")
            : selectedSpares.remove("bilgisayar aktiviteleri"); }
        if (j == 3){ !selectedSpares.contains("akıllı telefon aktiviteleri") ? selectedSpares.add("akıllı telefon aktiviteleri")
            : selectedSpares.remove("akıllı telefon aktiviteleri"); }
        if (j == 4){!selectedSpares.contains("fotoğrafçılık") ? selectedSpares.add("fotoğrafçılık")
            : selectedSpares.remove("fotoğrafçılık"); }
        if (j == 5){ !selectedSpares.contains("tv izleme") ? selectedSpares.add("tv izleme")
            : selectedSpares.remove("tv izleme"); }
        if (j == 6){ !selectedSpares.contains("alışveriş") ? selectedSpares.add("alışveriş")
            : selectedSpares.remove("alışveriş"); }
        if (j == 7){ !selectedSpares.contains("balıkçılık") ? selectedSpares.add("balıkçılık")
            : selectedSpares.remove("balıkçılık"); }
        if (j == 8){ !selectedSpares.contains("avlanma") ? selectedSpares.add("avlanma")
            : selectedSpares.remove("avlanma"); }
        if (j == 9){ !selectedSpares.contains("diğerleri") ? selectedSpares.add("diğerleri")
            : selectedSpares.remove("diğerleri"); }
      }
      if (i == 4){
        if (j == 0){ !selectedFoods.contains("et türleri") ? selectedFoods.add("et türleri")
            : selectedFoods.remove("et türleri"); }
        if (j == 1){ !selectedFoods.contains("sebze türleri") ? selectedFoods.add("sebze türleri")
            : selectedFoods.remove("sebze türleri"); }
        if (j == 2){ !selectedFoods.contains("balık türleri") ? selectedFoods.add("balık türleri")
            : selectedFoods.remove("balık türleri"); }
        if (j == 3){ !selectedFoods.contains("tavuk türleri") ? selectedFoods.add("tavuk türleri")
            : selectedFoods.remove("tavuk türleri"); }
        if (j == 4){ !selectedFoods.contains("et-sebze karışık") ? selectedFoods.add("et-sebze karışık")
            : selectedFoods.remove("et-sebze karışık"); }
        if (j == 5){ !selectedFoods.contains("fast food") ? selectedFoods.add("fast food")
            : selectedFoods.remove("fast food"); }
      }
      if (i == 5){
        if (j == 0){ !selectedDrinks.contains("alkollü içecekler") ? selectedDrinks.add("alkollü içecekler")
            : selectedDrinks.remove("alkollü içecekler"); }
        if (j == 1){ !selectedDrinks.contains("bira") ? selectedDrinks.add("bira")
            : selectedDrinks.remove("bira"); }
        if (j == 2){ !selectedDrinks.contains("kola") ? selectedDrinks.add("kola")
            : selectedDrinks.remove("kola"); }
        if (j == 3){ !selectedDrinks.contains("meyve suları") ? selectedDrinks.add("meyve suları")
            : selectedDrinks.remove("meyve suları"); }
        if (j == 4){ !selectedDrinks.contains("enerji içecekleri") ? selectedDrinks.add("enerji içecekleri")
            : selectedDrinks.remove("enerji içecekleri"); }
        if (j == 5){ !selectedDrinks.contains("kahve") ? selectedDrinks.add("kahve") : selectedDrinks.remove("kahve"); }
        if (j == 6){ !selectedDrinks.contains("çay") ? selectedDrinks.add("çay") : selectedDrinks.remove("çay"); }
        if (j == 7){ !selectedDrinks.contains("yeşil çay") ? selectedDrinks.add("yeşil çay")
            : selectedDrinks.remove("yeşil çay"); }
        if (j == 8){ !selectedDrinks.contains("organik içecekler") ? selectedDrinks.add("organik içecekler")
            : selectedDrinks.remove("organik içecekler"); }
      }
      if (i == 6){
        if (j == 0){ !selectedSnacks.contains("çikolata barlar") ? selectedSnacks.add("çikolata barlar")
            : selectedSnacks.remove("çikolata barlar"); }
        if (j == 1){ !selectedSnacks.contains("gofretler") ? selectedSnacks.add("gofretler")
            : selectedSnacks.remove("gofretler"); }
        if (j == 2){ !selectedSnacks.contains("bisküviler") ? selectedSnacks.add("bisküviler")
            : selectedSnacks.remove("bisküviler"); }
        if (j == 3){ !selectedSnacks.contains("krakerler") ? selectedSnacks.add("krakerler")
            : selectedSnacks.remove("krakerler"); }
        if (j == 4){ !selectedSnacks.contains("kuruyemiş") ? selectedSnacks.add("kuruyemiş")
            : selectedSnacks.remove("kuruyemiş"); }
        if (j == 5){ !selectedSnacks.contains("dondurma") ? selectedSnacks.add("dondurma")
            : selectedSnacks.remove("dondurma"); }
        if (j == 6){ !selectedSnacks.contains("kurabiye") ? selectedSnacks.add("kurabiye")
            : selectedSnacks.remove("kurabiye"); }
        if (j == 7){ !selectedSnacks.contains("cips") ? selectedSnacks.add("cips") : selectedSnacks.add("cips"); }
        if (j == 8){ !selectedSnacks.contains("kek-pasta") ? selectedSnacks.add("kek-pasta")
            : selectedSnacks.remove("kek-pasta"); }
        if (j == 9){ !selectedSnacks.contains("kuru meyve") ? selectedSnacks.add("kuru meyve")
            : selectedSnacks.remove("kuru meyve"); }
      }
      if (i == 7){
        if (j == 0){ !selectedColors.contains("kırmızı") ? selectedColors.add("kırmızı") : selectedColors.remove("kırmızı"); }
        if (j == 1){ !selectedColors.contains("mavi") ? selectedColors.add("mavi") : selectedColors.remove("mavi"); }
        if (j == 2){ !selectedColors.contains("yeşil") ? selectedColors.add("yeşil") : selectedColors.remove("yeşil"); }
        if (j == 3){ !selectedColors.contains("pembe") ? selectedColors.add("pembe") : selectedColors.remove("pembe"); }
        if (j == 4){ !selectedColors.contains("siyah") ? selectedColors.add("siyah") : selectedColors.remove("siyah"); }
        if (j == 5){ !selectedColors.contains("gri") ? selectedColors.add("gri") : selectedColors.remove("gri"); }
        if (j == 6){ !selectedColors.contains("kahverengi") ? selectedColors.add("kahverengi")
            : selectedColors.remove("kahverengi"); }
        if (j == 7){ !selectedColors.contains("beyaz") ? selectedColors.add("beyaz") : selectedColors.remove("beyaz"); }
        if (j == 8){ !selectedColors.contains("sarı") ? selectedColors.add("sarı") : selectedColors.remove("sarı"); }
      }
      if (i == 8){
        if (j == 0){ !selectedDeseases.contains("baş ağrısı") ? selectedDeseases.add("baş ağrısı")
            : selectedDeseases.remove("baş ağrısı"); }
        if (j == 1){ !selectedDeseases.contains("bel problemleri") ? selectedDeseases.add("bel problemleri")
            : selectedDeseases.remove("bel problemleri"); }
        if (j == 2){ !selectedDeseases.contains("sırt ağrısı") ? selectedDeseases.add("sırt ağrısı")
            : selectedDeseases.remove("sırt ağrısı"); }
        if (j == 3){ !selectedDeseases.contains("boyun ağrısı") ? selectedDeseases.add("boyun ağrısı")
            : selectedDeseases.remove("boyun ağrısı"); }
        if (j == 4){ !selectedDeseases.contains("nefes problemleri") ? selectedDeseases.add("nefes problemleri")
            : selectedDeseases.remove("nefes problemleri"); }
        if (j == 5){ !selectedDeseases.contains("böbrek hastalıkları") ? selectedDeseases.add("böbrek hastalıkları")
            : selectedDeseases.remove("böbrek hastalıkları"); }
        if (j == 6){ !selectedDeseases.contains("boğaz hastalıkları") ? selectedDeseases.add("boğaz hastalıkları")
            : selectedDeseases.remove("boğaz hastalıkları"); }
        if (j == 7){ !selectedDeseases.contains("bacak ağrıları") ? selectedDeseases.add("bacak ağrıları")
            : selectedDeseases.remove("bacak ağrıları"); }
        if (j == 8){ !selectedDeseases.contains("ayak ağrıları") ? selectedDeseases.add("ayak ağrıları")
            : selectedDeseases.remove("ayak ağrıları"); }
        if (j == 9){ !selectedDeseases.contains("karaciğer hastalıkları") ? selectedDeseases.add("karaciğer hastalıkları")
            : selectedDeseases.remove("karaciğer hastalıkları"); }
        if (j == 10){ !selectedDeseases.contains("kalp hastalıkları") ? selectedDeseases.add("kalp hastalıkları")
            : selectedDeseases.remove("kalp hastalıkları"); }
        if (j == 11){ !selectedDeseases.contains("diyabet") ? selectedDeseases.add("diyabet")
            : selectedDeseases.remove("diyabet"); }
        if (j == 12){ !selectedDeseases.contains("düzensiz tansiyon") ? selectedDeseases.add("düzensiz tansiyon")
            : selectedDeseases.remove("düzensiz tansiyon"); }
        if (j == 13){ !selectedDeseases.contains("migren") ? selectedDeseases.add("migren")
            : selectedDeseases.remove("migren"); }
      }
    }

    setState(() {});

  }

  void chooseTheFacilityType(int index) {

    if ( MyInheritor.of(context)?.langEng == true ){
      index == 0 ? { isHotel = true,  facilityType = "hotel" }
          : index == 1 ? { isButique = true,  facilityType = "butique hotel" }
          : index == 2 ?  { isMotel = true,  facilityType = "motel" }
          : index == 3 ? { isResort = true,  facilityType = "resort" }
          : index == 4 ? { isHostel = true,  facilityType = "hostel" }
          : index == 5 ? { isApart = true,  facilityType = "apart hotel" }
          : index == 6 ? { isDorm = true,  facilityType = "dormitory" }
          : index == 7 ? { isCamping = true,  facilityType = "camping" }
          : index == 8 ? { isVha = true,  facilityType = "villa-house-apartment" }
          : index == 9 ? { isGuestHouse = true,  facilityType = "guest house" }
          : null;
    } else {
      index == 0 ? { isHotel = true,  facilityType = "otel" }
          : index == 1 ? { isButique = true,  facilityType = "butik otel" }
          : index == 2 ?  { isMotel = true,  facilityType = "motel" }
          : index == 3 ? { isResort = true,  facilityType = "tatil köyü" }
          : index == 4 ? { isHostel = true,  facilityType = "pansiyon" }
          : index == 5 ? { isApart = true,  facilityType = "apart otel" }
          : index == 6 ? { isDorm = true,  facilityType = "yurt" }
          : index == 7 ? { isCamping = true,  facilityType = "kamp tesisi" }
          : index == 8 ? { isVha = true,  facilityType = "villa-ev-daire" }
          : index == 9 ? { isGuestHouse = true,  facilityType = "misafirhane" }
          : null;
    }

    setState(() {
      selectedIndex_facility = index;
    });
  }

  void chooseTheServiceType(int index) {

    if ( MyInheritor.of(context)?.langEng == true ){
      index == 0 ? { isJB = true,  serviceType = "just bed" }
          : index == 1 ? { isBB = true,  serviceType = "bed&breakfast" }
          : index == 2 ? { isHB = true,  serviceType = "half board" }
          : index == 3 ? { isFB = true,  serviceType = "full board" }
          : index == 4 ? { isAI = true,  serviceType = "all inclusive" }
          : index == 5 ? { isUAI = true,  serviceType = "ultra all inclusive" }
          : null;
    } else {
      index == 0 ? { isJB = true,  serviceType = "sadece konaklama" }
          : index == 1 ? { isBB = true,  serviceType = "oda-kahvaltı" }
          : index == 2 ? { isHB = true,  serviceType = "yarım pansiyon" }
          : index == 3 ? { isFB = true,  serviceType = "tam pansiyon" }
          : index == 4 ? { isAI = true,  serviceType = "herşey dahil" }
          : index == 5 ? { isUAI = true,  serviceType = "ultra herşey dahil" }
          : null;
    }

    setState(() {
      selectedIndex_service = index;
    });
  }

  void chooseTheOrgType(int index) {

    if ( MyInheritor.of(context)?.langEng == true ) {
      index == 0 ? { isOfficial = true,  orgType = "official" }
          : index == 1 ? { isMunicipality = true,  orgType = "municipality" }
          : index == 2 ? { isFoundation = true,  orgType = "foundation" }
          : index == 3 ? { isPrivate = true,  orgType = "private" }
          : null;
    } else {
      index == 0 ? { isOfficial = true,  orgType = "kamu" }
          : index == 1 ? { isMunicipality = true,  orgType = "belediye" }
          : index == 2 ? { isFoundation = true,  orgType = "vakıf" }
          : index == 3 ? { isPrivate = true,  orgType = "özel" }
          : null;
    }

    setState(() {
      selectedIndex_org = index;
    });
  }

}





