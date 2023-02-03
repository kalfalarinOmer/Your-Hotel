import 'package:flutter/material.dart';

class MyInheritor extends InheritedWidget{

  dynamic isVisitor;
  dynamic isHotel;
  dynamic userName;
  dynamic userMail;
  dynamic uid;
  dynamic langEng;


  MyInheritor({
    Key? key,
    required Widget child,

    this.isVisitor,
    this.isHotel,
    this.userMail,
    this.userName,
    this.uid,
    this.langEng,

  }) : super (key: key, child: child);

  static MyInheritor? of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<MyInheritor>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

}