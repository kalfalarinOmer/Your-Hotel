import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitorsReservationsPage extends StatefulWidget{
  final user_map; final user_id; final user_ref; final goReservations; final goCurrentVisitors; final goVisitorsLeft;
  const VisitorsReservationsPage({super.key, required this.user_map, required this.user_id, required this.user_ref,
    this.goReservations, this.goCurrentVisitors, this.goVisitorsLeft
  });

  @override
  State<StatefulWidget> createState() {
    return VisitorsReservationsPageState(this.user_map, this.user_id, this.user_ref,
        this.goReservations, this.goCurrentVisitors, this.goVisitorsLeft
    );
  }

}

class VisitorsReservationsPageState extends State<VisitorsReservationsPage>{
  final user_map; final user_id; final user_ref; final goReservations; final goCurrentVisitors; final goVisitorsLeft;
  VisitorsReservationsPageState( this.user_map, this.user_id, this.user_ref,
      this.goReservations, this.goCurrentVisitors, this.goVisitorsLeft
      );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(goReservations == true ? "Gelen Rezervasyonlarınız" : goCurrentVisitors == true ? "Mevcut Ziyaretçileriniz"
            : "Ayrılan Ziyaretçileriniz"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Tüm mevcut ziyaretçileriniz eklenme tarih sıralmasına göre sondan başa doğru listelenmektedir. "
                "Görmek yada işlem yapmak istediğiniz ziyaretçinin üzerine tıklayınız.",
              style: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: StreamBuilder(
              stream: goReservations == true
                  ? FirebaseFirestore.instance.collection("hotelUsers").doc(user_id).collection("reservations")
                  .orderBy("addedDate_S", descending: true).snapshots()
                  : goCurrentVisitors == true
                  ? FirebaseFirestore.instance.collection("hotelUsers").doc(user_id).collection("currentVisitors")
                  .orderBy("checkinDate_S", descending: true).snapshots()
                  : FirebaseFirestore.instance.collection("hotelUsers").doc(user_id).collection("currentVisitors")
                  .where("isLeft", isEqualTo: true).orderBy("addedDate_S", descending: true).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasError){ return const Center( child:Icon(Icons.warning_amber, size: 50,));}

                else if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                  return const Center( child: CircularProgressIndicator());}

                else {
                  QuerySnapshot querySnapshot = snapshot.data!;

                  return SizedBox( height: 600,
                    child: ListView.builder(
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index){

                        dynamic vis_map = querySnapshot.docs[index].data()!;
                        dynamic vis_id = querySnapshot.docs[index].id!;

                        return Card( elevation: 10,
                          child:ListTile(
                              tileColor: Colors.white,
                              title: Text(vis_map["visitorName"],
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
                              subtitle: Padding(padding: const EdgeInsets.all(5.0),
                                child: Wrap(direction: Axis.vertical, spacing: 5,
                                    children: [
                                      Wrap(children: [
                                        const Text("ziyaretçi mail: "),
                                        Text(vis_map["visitorMail"],
                                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15,
                                              fontWeight: FontWeight.w600),)
                                      ]),
                                      Wrap(children: [
                                        const Text("checkin tarihi: "),
                                        Text(vis_map["checkinDate_S"],
                                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15,
                                              fontWeight: FontWeight.w600),)
                                      ]),
                                      Wrap(children: [
                                        const Text("checkout tarihi: "),
                                        Text(vis_map["checkinDate_S"],
                                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15,
                                              fontWeight: FontWeight.w600),)
                                      ]),
                                    ]),
                              ),
                              trailing: Card( color: Colors.white, elevation: 4,
                                  child: Text(vis_map["addedDate_S"].toString().substring(0, 16))),
                              onTap: () async {
                                onVisitorPressed();
                              }
                          ),
                        );
                      },
                    ),
                  );

                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void onVisitorPressed() {
    AlertDialog alertDialog = AlertDialog(
      title: Center(child: Text("Yapacağınız işleme tıklayınız: ", textAlign: TextAlign.center,)),
      actions: [
        Wrap( spacing: 10,
          children: [
            ElevatedButton(
              child: Text("Profili Gör", style: TextStyle(fontSize: 17),),
              onPressed: (){
                updateAlert();
              },
            ),
            ElevatedButton(
              child: Text("Ayrılan Ziyaretçilere Ekle", style: TextStyle(fontSize: 15),),
              onPressed: (){},
            ),
          ],
        ),
        Wrap( spacing: 10,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.notification_add_outlined),
              label: Text("Bildirim Gönder", style: TextStyle(fontSize: 13),),
              onPressed: (){
                updateAlert();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.outgoing_mail),
              label: Text("Mesaj Gönder", style: TextStyle(fontSize: 13),),
              onPressed: (){
                updateAlert();
              },
            ),
          ],
        ),

      ],
    ); showDialog(context: context, builder: (_) => alertDialog );
  }

  void updateAlert() {
    AlertDialog alertDialog = const AlertDialog(
      title: Text("Bu özellik şimdilik aktif değildir. Yeni güncellemeleri bekleyiniz."),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

}