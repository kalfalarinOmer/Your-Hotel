
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/FilteredStatisticsPage.dart';
import 'package:yourhotel/FirstPage.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';

class GetStatisticsPage extends StatefulWidget{
  final user_map;   final user_id;    final user_ref;
  const GetStatisticsPage({super.key, required this.user_map, required this.user_id, required this.user_ref});

  @override
  State<StatefulWidget> createState() {
    return GetStatisticsPageState(this.user_map, this.user_id, this.user_ref);
  }

}

class GetStatisticsPageState extends State<GetStatisticsPage>{
  final user_map;   final user_id;    final user_ref;
  GetStatisticsPageState(this.user_map, this.user_id, this.user_ref);

  final ValueNotifier<bool> isInfoPressed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCountrySelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isStateSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCitySelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isTownSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAgeSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isGenderSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isGenderMale = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMarriedSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMarried = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKidSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKid0 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKid1 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKid2 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKid3 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isKid4 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isUnSelected = ValueNotifier<bool>(true);

  List<String> filterCategories = ["ülke", "bölge", "şehir", "ilçe", "yaş aralığı","cinsiyet", "evililik", "çocuk sayısı",];
  List <int> filterSelectedIndexes = [];
  List<String> ageRange = ["-18", "18-23", "24-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "61-65",
    "66-70", "+70",];

  int selectedIndex = -1;
  bool isSelected_age = false;
  String selectedAge = "";
  bool isSelected_genderMale = false;
  bool isSelected_genderFemale = false;
  String selectedGender = "";
  bool isSelected_married = false;
  String marriedSelected = "";
  bool isSelected_kid = false;
  String selectedKid = "";

  final formKey_country = GlobalKey<FormState>();
  final formKey_state = GlobalKey<FormState>();
  final formKey_city = GlobalKey<FormState>();
  final formKey_town = GlobalKey<FormState>();
  TextEditingController countrier = TextEditingController();
  TextEditingController stater = TextEditingController();
  TextEditingController citier = TextEditingController();
  TextEditingController towner = TextEditingController();


  @override

  void dispose() {
    countrier.dispose();
    stater.dispose();
    citier.dispose();
    towner.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("İstatistikleri Al"),
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
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: TextButton.icon(
                icon: const Icon(Icons.info,
                    size: 30, color: Colors.indigo ),
                label: Text( MyInheritor.of(context)?.langEng != true ? "Bilgilendirme" : "Information",
                    style: const TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo,
                        fontSize: 18, decoration: TextDecoration.underline)),
                onPressed: (){
                  isInfoPressed.value = !isInfoPressed.value;
                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isInfoPressed,
            builder: (context, value, child){
              return Visibility( visible: isInfoPressed.value == true ? true : false,
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("* Bu sayfa otellere misafir edeceği turistler hakkında bazı istatistiki bilgileri "
                          "ve analizlerini sağlar.", textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 17))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("** Her otel bu sayfadan istediği filtrelerde aramalar yaparak turislerin sportif "
                          "aktiviteleri, boş zaman etkinlikleri, favori yemek türleri, favori içecek türleri, favori atıştırmalıkları, "
                          "favori renkleri, kronik rahatsızlıkları alanlarında veritabaındaki bilgilerin analiz sonuçlarını ve "
                          "tavsiyeleri alabilir.", textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 17))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("*** Bu sayfada hiçbir şekilde turistlerin kişisel bilgileri açıklanmaz. Otelinize "
                          "gelecek turistlere özel edinmek istediğiniz bilgilere misafirlerinizin uygulamada açtığı/açacağı "
                          "profil sayfalarından ulaşabilirsiniz.", textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 17))),
                    ),
                  ],
                ),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text("Aşağıda verilen kategorilerden filtreler seçerek arama yapabilirsiniz. "
                  "Her kategoriden en fazla 1 filtre seçebilirsiniz.", textAlign: TextAlign.center,
                  style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only( left: 20.0, right: 20),
            child: Card( elevation: 20,
              child: Container(height: 250, padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: filterCategories.length,
                  itemBuilder: (context, index){
                    return ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.indigo),
                      ),
                      onPressed: (){
                        selectedIndex = index;
                        print(index);
                        print(selectedIndex);

                        selectFilter(index);
                      },
                      child: Text( filterCategories[index],
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
//ülke
          ValueListenableBuilder(
            valueListenable: isCountrySelected,
            builder: (context, value, child){
              return Visibility( visible: isCountrySelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey_country,
                    child: TextFormField(
                      controller: countrier,
                      decoration: const InputDecoration(
                          labelText:  "ülke",
                          labelStyle: TextStyle(color: Colors.purple), border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "alanı doldurunuz"
                            : "alanı doldurunuz";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
//bölge
          ValueListenableBuilder(
            valueListenable: isStateSelected,
            builder: (context, value, child){
              return Visibility( visible: isStateSelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey_state,
                    child: TextFormField(
                      controller: stater,
                      decoration: const InputDecoration(
                          labelText:  "bölge",
                          labelStyle: TextStyle(color: Colors.purple), border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "alanı doldurunuz"
                            : "alanı doldurunuz";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
//şehir
          ValueListenableBuilder(
            valueListenable: isCitySelected,
            builder: (context, value, child){
              return Visibility( visible: isCitySelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey_city,
                    child: TextFormField(
                      controller: citier,
                      decoration: const InputDecoration(
                          labelText:  "şehir",
                          labelStyle: TextStyle(color: Colors.purple), border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "alanı doldurunuz"
                            : "alanı doldurunuz";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
//ilçe
          ValueListenableBuilder(
            valueListenable: isTownSelected,
            builder: (context, value, child){
              return Visibility( visible: isTownSelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey_town,
                    child: TextFormField(
                      controller: towner,
                      decoration: const InputDecoration(
                          labelText:  "ilçe",
                          labelStyle: TextStyle(color: Colors.purple), border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder( borderSide: BorderSide( color: Colors.purple))
                      ),
                      validator: (value) {
                        if(value == null){ return MyInheritor.of(context)?.langEng != true ? "alanı doldurunuz"
                            : "alanı doldurunuz";
                        } else { return null; }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
//yaş
          ValueListenableBuilder(
            valueListenable: isAgeSelected,
            builder: ( context, value, child) {
              return Visibility( visible: isAgeSelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Text( MyInheritor.of(context)?.langEng != true ? "Yaş aralığını seçiniz:"
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
                                print(index);

                                setState(() {
                                  isSelected_age = true;
                                  selectedIndex = index;
                                });
                                selectedAge = ageRange[index];
                                print(selectedAge);
                              },
                              child: Text( ageRange[index],
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: isSelected_age == true && index == selectedIndex ? 22 : 17,
                                    decoration: TextDecoration.underline,
                                    color: isSelected_age == true && index == selectedIndex
                                        ? Colors.green : Colors.blue),
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
//cinsiyet
          ValueListenableBuilder(
            valueListenable: isGenderSelected,
            builder: (context, value, child){
              return Visibility( visible: isGenderSelected.value == true ? true : false,
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
                          ValueListenableBuilder(
                              valueListenable: isGenderMale,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("Erkek",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isGenderMale.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isGenderMale.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isGenderMale.value = true;
                                    selectedGender = "erkek";
                                  },
                                );
                              }
                          ),

                          ValueListenableBuilder(
                              valueListenable: isGenderMale,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("Kadın",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isGenderMale.value == false ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isGenderMale.value == false ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isGenderMale.value = false;
                                    selectedGender = "kadın";
                                  },
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
//evlilik
          ValueListenableBuilder(
            valueListenable: isMarriedSelected,
            builder: (context, value, child){
              return Visibility( visible: isMarriedSelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Card( elevation: 10,
                    child: Center(
                      child: Wrap( spacing: 20,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text( "Evlilik: ",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                          ValueListenableBuilder(
                            valueListenable: isMarried,
                            builder: (context, value, child) {
                              return TextButton(
                                child: Text("Evet",
                                  style: TextStyle(fontWeight: FontWeight.w700,
                                      fontSize: isMarried.value == true ? 20 : 17,
                                      decoration: TextDecoration.underline,
                                      color: isMarried.value == true ? Colors.green : Colors.blue ),),
                                onPressed: () async {
                                  isMarried.value = true;
                                  marriedSelected = "evet";
                                },
                              );
                            }
                          ),

                          ValueListenableBuilder(
                              valueListenable: isMarried,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("Hayır",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isMarried.value == false ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isMarried.value == false ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isMarried.value = false;
                                    marriedSelected = "hayır";
                                  },
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
//çocuk
          ValueListenableBuilder(
            valueListenable: isKidSelected,
            builder: (context, value, child){
              return Visibility( visible: isKidSelected.value == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Card( elevation: 10,
                    child: Center(
                      child: Wrap( spacing: 10,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text( "Çocuk sayısı: ",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                          ),
                          ValueListenableBuilder(
                              valueListenable: isKid0,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("0",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isKid0.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isKid0.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isKid0.value = true;
                                    isKid1.value = false;
                                    isKid2.value = false;
                                    isKid3.value = false;
                                    isKid4.value = false;
                                    selectedKid = "0";
                                  },
                                );
                              }
                          ),
                          ValueListenableBuilder(
                              valueListenable: isKid1,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("1",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isKid1.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isKid1.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isKid0.value = false;
                                    isKid1.value = true;
                                    isKid2.value = false;
                                    isKid3.value = false;
                                    isKid4.value = false;
                                    selectedKid = "1";
                                  },
                                );
                              }
                          ),

                          ValueListenableBuilder(
                              valueListenable: isKid2,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("2",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isKid2.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isKid2.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isKid0.value = false;
                                    isKid1.value = false;
                                    isKid2.value = true;
                                    isKid3.value = false;
                                    isKid4.value = false;
                                    selectedKid = "2";
                                  },
                                );
                              }
                          ),
                          ValueListenableBuilder(
                              valueListenable: isKid3,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("3",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isKid3.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isKid3.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isKid0.value = false;
                                    isKid1.value = false;
                                    isKid2.value = false;
                                    isKid3.value = true;
                                    isKid4.value = false;
                                    selectedKid = "3";
                                  },
                                );
                              }
                          ),

                          ValueListenableBuilder(
                              valueListenable: isKid4,
                              builder: (context, value, child) {
                                return TextButton(
                                  child: Text("+4",
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: isKid4.value == true ? 20 : 17,
                                        decoration: TextDecoration.underline,
                                        color: isKid4.value == true ? Colors.green : Colors.blue ),),
                                  onPressed: () async {
                                    isKid0.value = false;
                                    isKid1.value = false;
                                    isKid2.value = false;
                                    isKid3.value = false;
                                    isKid4.value = true;
                                    selectedKid = "+4";
                                  },
                                );
                              }
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
            padding: const EdgeInsets.all(20),
            child: SizedBox( height: 40,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.graphic_eq, color: Colors.white, size: 40,),
                label: const Text("İstatistikleri Getir", textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                  elevation: MaterialStateProperty.all(50), ),
                onPressed: (){
                  getStatistics();
                },
              ),
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

  void selectFilter(int index) {

    if(filterSelectedIndexes.contains(index)){
      filterSelectedIndexes.remove(index);
    } else {
      filterSelectedIndexes.add(index);
    }

    index == 0 ? isCountrySelected.value = !isCountrySelected.value
        : index == 1 ? isStateSelected.value = !isStateSelected.value
        : index == 2 ? isCitySelected.value = !isCitySelected.value
        : index == 3 ? isTownSelected.value = !isTownSelected.value
        : index == 4 ? isAgeSelected.value = !isAgeSelected.value
        : index == 5 ? isGenderSelected.value = !isGenderSelected.value
        : index == 6 ? isMarriedSelected.value = !isMarriedSelected.value
        : index == 7 ? isKidSelected.value = !isKidSelected.value
        : null;

  }

  void getStatistics() async {
    dynamic country;   dynamic state;   dynamic city;    dynamic town;
    if(isCountrySelected.value == true){
      if (formKey_country.currentState!.validate()){
        formKey_country.currentState!.save();

        country = countrier.text.trim().toLowerCase();
      }
    }
    if(isStateSelected.value == true){
      if (formKey_state.currentState!.validate()){
        formKey_country.currentState!.save();

        state = stater.text.trim().toLowerCase();
      }
    }
    if(isCitySelected.value == true){
      if (formKey_city.currentState!.validate()){
        formKey_country.currentState!.save();

        city = citier.text.trim().toLowerCase();
      }
    }
    if(isTownSelected.value == true){
      if (formKey_town.currentState!.validate()){
        formKey_country.currentState!.save();

        town = towner.text.trim().toLowerCase();
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredStatisticsPage(
      user_map: user_map, user_id: user_id, user_ref: user_ref,
      country: country, state: state, city: city, town: town,
      ageRange: selectedAge, gender: selectedGender,
      married: marriedSelected, kidCount: selectedKid,)));

  }

}
