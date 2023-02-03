import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FilteredStatisticsPage extends StatefulWidget{
  final user_map;   final user_id;    final user_ref;
  final country;   final state;    final city;    final town;
  final ageRange;    final gender;    final married;    final kidCount;
  const FilteredStatisticsPage({super.key, required this.user_map, required this.user_id, required this.user_ref,
    this.country, this.state, this.city, this.town, this.ageRange, this.gender, this.married, this.kidCount});

  @override
  State<StatefulWidget> createState() {
    return FilteredStatisticsPageState(this.user_map, this.user_id, this.user_ref,
        this.country, this.state, this.city, this.town, this.ageRange, this.gender, this.married, this.kidCount);
  }

}

class FilteredStatisticsPageState extends State<FilteredStatisticsPage>{
  final user_map;   final user_id;    final user_ref;
  final country;   final state;    final city;    final town;
  final ageRange;    final gender;    final married;    final kidCount;
  FilteredStatisticsPageState(this.user_map, this.user_id, this.user_ref,
      this.country, this.state, this.city, this.town, this.ageRange, this.gender, this.married, this.kidCount);


  List<String> filters_titles = ["ülke", "bölge", "şehir", "ilçe", "yaş aralığı", "cinsiyet", "evlilik", "çocuk sayısı"];
  List<dynamic> filters = [];

  List<String> statistics_titles = ["Favori spor aktiviteler: ", "Favori boş etkinlikler: ", "Favori yemek türleri: ",
    "Favori içecek türleri: ", "Favori atıştırmalıklar:", "Favori renkler: ", "Kronik rahatsızlıklar: ",];

  List<String> statistics_advices = ["Yürüyüş", "Kitap Okuma", "Et-Sebze Karışık", "Organik içecekler", "kuruyemiş",
    "yeşil", "bacak ağrıları",];

  List<String> statistics_ranges = ["%42", "%35", "%50,5", "%35", "%48", "%60", "%44",];

  @override
  Widget build(BuildContext context) {

    filters = [country, state, city, town, ageRange, gender, married, kidCount];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtrelerinize Göre İstatistikler: "),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card( elevation: 20, color: Colors.blue.shade100,
              child: SizedBox( height: 200,
                child: ListView.builder(
                  itemCount: filters.length,
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
                                  Text(filters_titles[index] + ": ",
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.deepOrange,
                                        fontSize: 15, fontStyle: FontStyle.italic),),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(filters[index].toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                                    fontSize: 20),),
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

          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Text("Filtrelerinize göre aşağıdaki veriler elde edilmiştir.", textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green ,
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
                      Card( elevation: 20, color: Colors.green.shade100,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 5,),
                                  Text(statistics_titles[index] + ": ",
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.deepOrange,
                                        fontSize: 15, fontStyle: FontStyle.italic),),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(statistics_advices[index].toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,
                                      fontSize: 18, decoration: TextDecoration.underline),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(": "+ statistics_ranges[index].toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                                      fontSize: 20),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }

}
