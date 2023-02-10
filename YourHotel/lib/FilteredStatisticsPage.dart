import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yourhotel/GetStatisticsPage.dart';


class FilteredStatisticsPage extends StatefulWidget{
  final user_map;   final user_id;    final user_ref;
  final country0;   final state0;    final city0;    final town0;
  final selectedAge;    final selectedGender;    final isSelected_married;    final selectedKid;
  const FilteredStatisticsPage({super.key, required this.user_map, required this.user_id, required this.user_ref,
    this.country0, this.state0, this.city0, this.town0, this.selectedAge, this.selectedGender,
    this.isSelected_married, this.selectedKid});

  @override
  State<StatefulWidget> createState() {
    return FilteredStatisticsPageState(user_map, user_id, user_ref, country0, state0, city0, town0, selectedAge,
        selectedGender, isSelected_married, selectedKid
    );
  }

}

class FilteredStatisticsPageState extends State<FilteredStatisticsPage>{
  final user_map;   final user_id;    final user_ref;
  final country0;   final state0;    final city0;    final town0;
  final selectedAge;    final selectedGender;    final isSelected_married;    final selectedKid;
  FilteredStatisticsPageState(this.user_map, this.user_id, this.user_ref,
      this.country0, this.state0, this.city0, this.town0, this.selectedAge, this.selectedGender,
      this.isSelected_married, this.selectedKid);


  List<String> filters_titles = ["ülke", "bölge", "şehir", "ilçe", "yaş aralığı", "cinsiyet", "evlilik", "çocuk sayısı"];
  List<dynamic> filterValues = [];
  List<String> filterKeys = ["country0", "state0", "city0", "town0", "selectedAge", "selectedGender",
    "isSelected_married", "selectedKid"];
  List<dynamic> filtersSelected = [];
  List<String> filtersSelected_keys = [];

  List<String> statistics_titles = ["Favori spor aktiviteleri: ", "Favori boş zaman etkinlikleri: ", "Favori yemek türleri: ",
    "Favori içecek türleri: ", "Favori atıştırmalıklar:", "Favori renkler: ", "Kronik rahatsızlıklar: ",];
  
  List<String> favouriteSports = [];
  List<String> favouriteSpares = [];
  List<String> favouriteFoods = [];
  List<String> favouriteDrinks = [];
  List<String> favouriteSnacks = [];
  List<String> favouriteColors = [];
  List<String> chronicDiseases = [];

  double favSportRange = 0;   double favSportPercent = 0;   String favSport = "";
  double favSpareRange = 0;   double favSparePercent = 0;   String favSpare = "";
  double favFoodRange = 0;   double favFoodPercent = 0;   String favFood = "";
  double favDrinkRange = 0;   double favDrinkPercent = 0;   String favDrink = "";
  double favSnackRange = 0;   double favSnackPercent = 0;   String favSnack = "";
  double favColorRange = 0;   double favColorPercent = 0;   String favColor = "";
  double chronicDiseaseRange = 0;   double chronicDiseasePercent = 0;   String chronicDisease = "";

  List<String> statistics_advices = [];
  List<String> statistics_ranges = [];


  @override
  Widget build(BuildContext context) {

    filterValues = [country0, state0, city0, town0, selectedAge, selectedGender, isSelected_married, selectedKid];

    for (int i=0; i<8; i++){
      if(filterValues[i] == null || filterValues[i] == ""){
        filtersSelected = filtersSelected;
      } else {
        if (!filtersSelected_keys.contains(filterKeys[i])){
          if(filterValues[i] == "evli"){
            filterValues[i] = true;
            filtersSelected.add(filterValues[i]);
          } else if (filterValues[i] == "bekar"){
            filterValues[i] = false;
            filtersSelected.add(filterValues[i]);
          } else {
            filtersSelected.add(filterValues[i]);
          }
          filtersSelected_keys.add(filterKeys[i]);
        }
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtrelerinize Göre İstatistikler: "),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStatisticsPage(
              user_map: user_map, user_id: user_id, user_ref: user_ref
            )));
          },
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Text("Filtreleriniz aşağıda verilmiştir.", style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black, fontSize: 20),
              ),
            ),
          ),
//FİLTRELER KARTI
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card( elevation: 20, color: Colors.blue.shade100,
              child: SizedBox( height: 200,
                child: ListView.builder(
                  itemCount: filters_titles.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 5,),
                                  Text("${filters_titles[index]}: ",
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.deepOrange,
                                        fontSize: 15, fontStyle: FontStyle.italic),),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text( filterValues[index] == null || filterValues[index] == ""
                                    ? "girilmedi"
                                    : filterValues[index] == "male" ? "erkek" : filterValues[index] == "female" ? "kadın"
                                    : filterValues[index].toString(),
                                  style: filterValues[index] == null || filterValues[index] == ""
                                      ? const TextStyle(color: Colors.blueGrey, fontSize: 15)
                                      : const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20) ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 2, color: Colors.green, indent: 10, endIndent: 10,),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
//ANALİZ VE ÖNERİLER

          StreamBuilder(
            stream: filtersSelected.length == 1
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0]).snapshots()
                : filtersSelected.length == 2
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[1], isEqualTo: filtersSelected[1]).snapshots()
                : filtersSelected.length == 3
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[1], isEqualTo: filtersSelected[1])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2]).snapshots()
                : filtersSelected.length == 4
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[1], isEqualTo: filtersSelected[1])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2])
                .where(filtersSelected_keys[3], isEqualTo: filtersSelected[3]).snapshots()
                : filtersSelected.length == 5
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2])
                .where(filtersSelected_keys[3], isEqualTo: filtersSelected[3])
                .where(filtersSelected_keys[4], isEqualTo: filtersSelected[4]).snapshots()
                : filtersSelected.length == 6
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2])
                .where(filtersSelected_keys[3], isEqualTo: filtersSelected[3])
                .where(filtersSelected_keys[4], isEqualTo: filtersSelected[4])
                .where(filtersSelected_keys[5], isEqualTo: filtersSelected[5]).snapshots()
                : filtersSelected.length == 7
                ? FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2])
                .where(filtersSelected_keys[3], isEqualTo: filtersSelected[3])
                .where(filtersSelected_keys[4], isEqualTo: filtersSelected[4])
                .where(filtersSelected_keys[5], isEqualTo: filtersSelected[5])
                .where(filtersSelected_keys[6], isEqualTo: filtersSelected[6]).snapshots()
                : FirebaseFirestore.instance.collection("touristUsers")
                .where(filtersSelected_keys[0], isEqualTo: filtersSelected[0])
                .where(filtersSelected_keys[2], isEqualTo: filtersSelected[2])
                .where(filtersSelected_keys[3], isEqualTo: filtersSelected[3])
                .where(filtersSelected_keys[4], isEqualTo: filtersSelected[4])
                .where(filtersSelected_keys[5], isEqualTo: filtersSelected[5])
                .where(filtersSelected_keys[6], isEqualTo: filtersSelected[6])
                .where(filtersSelected_keys[7], isEqualTo: filtersSelected[7]).snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasError){ return const Center( child:Icon(Icons.warning_amber, size: 50,));}

              else if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                return const Center( child: CircularProgressIndicator());}

              else {

                final querySnapshot = snapshot.data;

                getFavSportStatistics(snapshot);

                getFavSpareStatistics(snapshot);

                getFavFoodStatistics(snapshot);

                getFavDrinkStatistics(snapshot);

                getFavSnackStatistics(snapshot);

                getFavColorStatistics(snapshot);

                getChronicDiseaseStatistics(snapshot);

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Text("Filtrelerinize göre ${querySnapshot?.size} adet veri elde edilmiştir. "
                            "Daha detaylı bilgi için ilgili karta tıklayın.", textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green ,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5, bottom: 20),
                      child: SizedBox( height: 600,
                        child: ListView.builder(
                          itemCount: statistics_titles.length,
                          itemBuilder: (context, index){
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: Card( elevation: 20, color: Colors.green.shade100,
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(height: 5,),
                                              Text("${statistics_titles[index]}: ",
                                                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.deepOrange,
                                                    fontSize: 15, fontStyle: FontStyle.italic),),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text( statistics_advices[index].toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,
                                                  fontSize: 18, decoration: TextDecoration.underline),),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text( ": %${statistics_ranges[index]}",
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                                                  fontSize: 20),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void getFavSportStatistics(AsyncSnapshot snapshot){

    List <String> favouriteSports_notSame = [];
    List <List<String>> favouriteSports_list = [];
    List <List<String>> favouriteSports_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedSports = favs.get("selectedSports");
      selectedSports.forEach((selectedSport) {
        favouriteSports.add(selectedSport.toString());
      });
    });
    print(favouriteSports);

    for (int i = 0; i < favouriteSports.length; i++){
      if (!favouriteSports_notSame.contains(favouriteSports[i])){
        favouriteSports_notSame.add(favouriteSports[i]);
      }
    }
    print(favouriteSports_notSame);

    for (int i = 0; i < favouriteSports_notSame.length; i++){
      List <String> favSports_notSame_i = favouriteSports
          .where((element) => element == favouriteSports_notSame[i]).toList();
      favouriteSports_list.add(favSports_notSame_i);
    }
    print(favouriteSports_list);
    favouriteSports_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteSports_list.length; i++){
      for (int j = 0; j<favouriteSports_list.length; j++){
        if(i!=j){
          if (favouriteSports_list[i].length > favouriteSports_list[j].length){
            favouriteSports_listOrdered.add(favouriteSports_list[i]);
          }
        }
      }
    }
    print(favouriteSports_listOrdered);

    favSportRange = favouriteSports_listOrdered[0].length / favouriteSports.length;
    favSportPercent = favSportRange*100;
    favSport = favouriteSports_listOrdered[0][0];

    statistics_advices.add(favSport);
    statistics_ranges.add(favSportPercent.toString());
  }

  void getFavSpareStatistics(AsyncSnapshot snapshot){

    List <String> favouriteSpares_notSame = [];
    List <List<String>> favouriteSpares_list = [];
    List <List<String>> favouriteSpares_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedSpares = favs.get("selectedSpares");
      selectedSpares.forEach((selectedSpare) {
        favouriteSpares.add(selectedSpare.toString());
      });
    });
    print(favouriteSpares);

    for (int i = 0; i < favouriteSpares.length; i++){
      if (!favouriteSpares_notSame.contains(favouriteSpares[i])){
        favouriteSpares_notSame.add(favouriteSpares[i]);
      }
    }
    print(favouriteSpares_notSame);

    for (int i = 0; i < favouriteSpares_notSame.length; i++){
      List <String> favSpares_notSame_i = favouriteSpares
          .where((element) => element == favouriteSpares_notSame[i]).toList();
      favouriteSpares_list.add(favSpares_notSame_i);
    }
    print(favouriteSpares_list);
    favouriteSpares_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteSpares_list.length; i++){
      for (int j = 0; j<favouriteSpares_list.length; j++){
        if(i!=j){
          if (favouriteSpares_list[i].length > favouriteSpares_list[j].length){
            favouriteSpares_listOrdered.add(favouriteSpares_list[i]);
          }
        }
      }
    }
    print(favouriteSpares_listOrdered);

    favSpareRange = favouriteSpares_listOrdered[0].length / favouriteSpares.length;
    favSparePercent = favSpareRange*100;
    favSpare = favouriteSpares_listOrdered[0][0];

    statistics_advices.add(favSpare);
    statistics_ranges.add(favSparePercent.toString());
  }

  void getFavFoodStatistics(AsyncSnapshot snapshot){

    List <String> favouriteFoods_notSame = [];
    List <List<String>> favouriteFoods_list = [];
    List <List<String>> favouriteFoods_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedFoods = favs.get("selectedFoods");
      selectedFoods.forEach((selectedFood) {
        favouriteFoods.add(selectedFood.toString());
      });
    });
    print(favouriteFoods);

    for (int i = 0; i < favouriteFoods.length; i++){
      if (!favouriteFoods_notSame.contains(favouriteFoods[i])){
        favouriteFoods_notSame.add(favouriteFoods[i]);
      }
    }
    print(favouriteFoods_notSame);

    for (int i = 0; i < favouriteFoods_notSame.length; i++){
      List <String> favFoods_notSame_i = favouriteFoods
          .where((element) => element == favouriteFoods_notSame[i]).toList();
      favouriteFoods_list.add(favFoods_notSame_i);
    }
    print(favouriteFoods_list);
    favouriteFoods_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteFoods_list.length; i++){
      for (int j = 0; j<favouriteFoods_list.length; j++){
        if(i!=j){
          if (favouriteFoods_list[i].length > favouriteFoods_list[j].length){
            favouriteFoods_listOrdered.add(favouriteFoods_list[i]);
          }
        }
      }
    }
    print(favouriteFoods_listOrdered);

    favFoodRange = favouriteFoods_listOrdered[0].length / favouriteFoods.length;
    favFoodPercent = favFoodRange*100;
    favFood = favouriteFoods_listOrdered[0][0];

    statistics_advices.add(favFood);
    statistics_ranges.add(favFoodPercent.toString());
  }

  void getFavDrinkStatistics(AsyncSnapshot snapshot){

    List <String> favouriteDrinks_notSame = [];
    List <List<String>> favouriteDrinks_list = [];
    List <List<String>> favouriteDrinks_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedDrinks = favs.get("selectedDrinks");
      selectedDrinks.forEach((selectedDrink) {
        favouriteDrinks.add(selectedDrink.toString());
      });
    });
    print(favouriteDrinks);

    for (int i = 0; i < favouriteDrinks.length; i++){
      if (!favouriteDrinks_notSame.contains(favouriteDrinks[i])){
        favouriteDrinks_notSame.add(favouriteDrinks[i]);
      }
    }
    print(favouriteDrinks_notSame);

    for (int i = 0; i < favouriteDrinks_notSame.length; i++){
      List <String> favDrinks_notSame_i = favouriteDrinks
          .where((element) => element == favouriteDrinks_notSame[i]).toList();
      favouriteDrinks_list.add(favDrinks_notSame_i);
    }
    print(favouriteDrinks_list);
    favouriteDrinks_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteDrinks_list.length; i++){
      for (int j = 0; j<favouriteDrinks_list.length; j++){
        if(i!=j){
          if (favouriteDrinks_list[i].length > favouriteDrinks_list[j].length){
            favouriteDrinks_listOrdered.add(favouriteDrinks_list[i]);
          }
        }
      }
    }
    print(favouriteDrinks_listOrdered);

    favDrinkRange = favouriteDrinks_listOrdered[0].length / favouriteDrinks.length;
    favDrinkPercent = favDrinkRange*100;
    favDrink = favouriteDrinks_listOrdered[0][0];

    statistics_advices.add(favDrink);
    statistics_ranges.add(favDrinkPercent.toString());
  }

  void getFavSnackStatistics(AsyncSnapshot snapshot){

    List <String> favouriteSnacks_notSame = [];
    List <List<String>> favouriteSnacks_list = [];
    List <List<String>> favouriteSnacks_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedSnacks = favs.get("selectedSnacks");
      selectedSnacks.forEach((selectedSnack) {
        favouriteSnacks.add(selectedSnack.toString());
      });
    });
    print(favouriteSnacks);

    for (int i = 0; i < favouriteSnacks.length; i++){
      if (!favouriteSnacks_notSame.contains(favouriteSnacks[i])){
        favouriteSnacks_notSame.add(favouriteSnacks[i]);
      }
    }
    print(favouriteSnacks_notSame);

    for (int i = 0; i < favouriteSnacks_notSame.length; i++){
      List <String> favSnacks_notSame_i = favouriteSnacks
          .where((element) => element == favouriteSnacks_notSame[i]).toList();
      favouriteSnacks_list.add(favSnacks_notSame_i);
    }
    print(favouriteSnacks_list);
    favouriteSnacks_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteSnacks_list.length; i++){
      for (int j = 0; j<favouriteSnacks_list.length; j++){
        if(i!=j){
          if (favouriteSnacks_list[i].length > favouriteSnacks_list[j].length){
            favouriteSnacks_listOrdered.add(favouriteSnacks_list[i]);
          }
        }
      }
    }
    print(favouriteSnacks_listOrdered);

    favSnackRange = favouriteSnacks_listOrdered[0].length / favouriteSnacks.length;
    favSnackPercent = favSnackRange*100;
    favSnack = favouriteSnacks_listOrdered[0][0];

    statistics_advices.add(favSnack);
    statistics_ranges.add(favSnackPercent.toString());
  }

  void getFavColorStatistics(AsyncSnapshot snapshot){

    List <String> favouriteColors_notSame = [];
    List <List<String>> favouriteColors_list = [];
    List <List<String>> favouriteColors_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedColors = favs.get("selectedColors");
      selectedColors.forEach((selectedColor) {
        favouriteColors.add(selectedColor.toString());
      });
    });
    print(favouriteColors);

    for (int i = 0; i < favouriteColors.length; i++){
      if (!favouriteColors_notSame.contains(favouriteColors[i])){
        favouriteColors_notSame.add(favouriteColors[i]);
      }
    }
    print(favouriteColors_notSame);

    for (int i = 0; i < favouriteColors_notSame.length; i++){
      List <String> favColors_notSame_i = favouriteColors
          .where((element) => element == favouriteColors_notSame[i]).toList();
      favouriteColors_list.add(favColors_notSame_i);
    }
    print(favouriteColors_list);
    favouriteColors_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<favouriteColors_list.length; i++){
      for (int j = 0; j<favouriteColors_list.length; j++){
        if(i!=j){
          if (favouriteColors_list[i].length > favouriteColors_list[j].length){
            favouriteColors_listOrdered.add(favouriteColors_list[i]);
          }
        }
      }
    }
    print(favouriteColors_listOrdered);

    favColorRange = favouriteColors_listOrdered[0].length / favouriteColors.length;
    favColorPercent = favColorRange*100;
    favColor = favouriteColors_listOrdered[0][0];

    statistics_advices.add(favColor);
    statistics_ranges.add(favColorPercent.toString());
  }

  void getChronicDiseaseStatistics(AsyncSnapshot snapshot){

    List <String> chronicDiseases_notSame = [];
    List <List<String>> chronicDiseases_list = [];
    List <List<String>> chronicDiseases_listOrdered = [];

    snapshot.data?.docs.forEach((favs) {
      List <dynamic> selectedDiseases = favs.get("selectedDeseases");
      selectedDiseases.forEach((selectedDisease) {
        chronicDiseases.add(selectedDisease.toString());
      });
    });
    print(chronicDiseases);

    for (int i = 0; i < chronicDiseases.length; i++){
      if (!chronicDiseases_notSame.contains(chronicDiseases[i])){
        chronicDiseases_notSame.add(chronicDiseases[i]);
      }
    }
    print(chronicDiseases_notSame);

    for (int i = 0; i < chronicDiseases_notSame.length; i++){
      List <String> chronicDiseases_notSame_i = chronicDiseases
          .where((element) => element == chronicDiseases_notSame[i]).toList();
      chronicDiseases_list.add(chronicDiseases_notSame_i);
    }
    print(chronicDiseases_list);
    chronicDiseases_list.forEach((element) {
      print(element);
    });

    for (int i = 0; i<chronicDiseases_list.length; i++){
      for (int j = 0; j<chronicDiseases_list.length; j++){
        if(i!=j){
          if (chronicDiseases_list[i].length > chronicDiseases_list[j].length){
            chronicDiseases_listOrdered.add(chronicDiseases_list[i]);
          }
        }
      }
    }
    print(chronicDiseases_listOrdered);

    chronicDiseaseRange = chronicDiseases_listOrdered[0].length / chronicDiseases.length;
    chronicDiseasePercent = chronicDiseaseRange*100;
    chronicDisease = chronicDiseases_listOrdered[0][0];

    statistics_advices.add(chronicDisease);
    statistics_ranges.add(chronicDiseasePercent.toString());
  }

}
