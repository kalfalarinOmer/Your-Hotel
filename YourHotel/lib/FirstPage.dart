import 'package:flutter/material.dart';
import 'package:yourhotel/Helpers/MyInheritor.dart';
import 'package:yourhotel/RegisterLoginPage.dart';

class FirstPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }
}

class FirstPageState extends State<FirstPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Your Hotel",
          style: TextStyle(fontSize: 25),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 30,),
            Card(
              elevation: 50, color: Colors.blue.shade100, margin: const EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(20)),
                    child: Wrap(
                      children: [
                        SizedBox( height: 20,
                          child: Image.asset("assets/iconsTurkish.png"),
                        ),
                        const SizedBox(width: 5,),
                        const Text("Türkçe",
                          style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],),
                    onPressed: () {
                      MyInheritor.of(context)?.langEng = false;

                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(20)),
                    child: Wrap(
                      children: [
                        SizedBox( height: 20,
                          child: Image.asset("assets/iconsEnglish.png"),
                        ),
                        const SizedBox(width: 5,),
                        const Text("English",
                          style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],),
                    onPressed: () {
                      MyInheritor.of(context)?.langEng = true;

                      setState(() {});
                    },
                  ),
                ],),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Card( elevation: 20,
                child: Container(
                  height: 320, width: 240,
                  color: Colors.yellow,
                  child: Image.asset("assets/yourHotelLogo.jpeg", fit: BoxFit.fill,),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Card(
              elevation: 50, color: Colors.green.shade100, margin: const EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(20)),
                    child: Wrap(
                      children: [
                        const Icon(Icons.groups, color: Colors.indigo,),
                        const SizedBox(width: 5,),
                        Text( MyInheritor.of(context)?.langEng == true ? "Visitor" : "Ziyaretçi",
                          style: const TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],),
                    onPressed: () {
                      MyInheritor.of(context)?.isVisitor = true;
                      MyInheritor.of(context)?.isHotel = false;

                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterLoginPage()));
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(20)),
                    child: Wrap(
                      children: [
                        const Icon(Icons.holiday_village, color: Colors.indigo,),
                        const SizedBox(width: 5,),
                        Text(MyInheritor.of(context)?.langEng == true ? "Hotel" : "Otel",
                          style: const TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],),
                    onPressed: () {
                      MyInheritor.of(context)?.isVisitor = false;
                      MyInheritor.of(context)?.isHotel = true;

                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterLoginPage()));
                    },
                  ),
                ],),
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                AlertDialog alertDialog = AlertDialog(
                  title: const Text("TEFENNİCODERS - 2023: ", style: TextStyle(color: Colors.indigo),),
                  content: Container( height: 120, width: 400,
                    child: Column(
                      children: const [
                        Text("Ramazan TÜZÜN - Takım Kaptanı", style: TextStyle(fontFamily: "Play",
                            fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 15),),
                        Text("Elif İKİLER - üye", style: TextStyle(fontFamily: "Play",
                            fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 15),),
                        Text("Elif İsra YALÇIN - üye", style: TextStyle(fontFamily: "Play",
                            fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 15),),
                        Text("Nurgül KAYACAN - üye", style: TextStyle(fontFamily: "Play",
                            fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 15),),
                        SizedBox(height: 20,),
                        Text("Ömer KALFA - Danışman Öğretmen", style: TextStyle(fontFamily: "Play", fontSize: 15),),
                      ],
                    ),
                  ),
                  actions: [
                    Container( height: 70, width: 100,
//                      child: Image.asset("assets/takimLogo.png", fit: BoxFit.contain,),
                    ),
                  ],
                ); showDialog(context: context, builder: (_) => alertDialog);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Wrap( direction: Axis.vertical, spacing: 4, children: [
                    Wrap(direction: Axis.horizontal, spacing: 4, children: const [
                      Icon(Icons.copyright, size: 30, color: Colors.green),
                      Text("TEFENNİCODERS - 2023", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),),
                    ]),
                    const Text("Tefenni Anadolu İmam Hatip Lisesi", style: TextStyle(color: Colors.green, fontSize: 13),),
                    const Text("Tefenninin ilk kodlama, yazılım geliştirme ve robotik takımı",
                      style: TextStyle(color: Colors.indigo, fontSize: 10, fontStyle: FontStyle.italic),),
                    const Center(child: Text("iletişim: omerkalfa1@gmail.com",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),)),
                  ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container( height: 70, width: 100,
//                child: Image.asset("assets/takimLogo.png", fit: BoxFit.contain,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}