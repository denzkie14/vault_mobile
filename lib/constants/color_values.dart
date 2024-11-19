import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

MaterialColor mainColor = Colors.blue;
//const Color textMainColor = Colors.white;
//const Color cardColor = ;
const textMainColor = Color.fromARGB(255, 33, 135, 182);
const cardColor = Color.fromARGB(179, 10, 7, 43);
const panelColor = Color.fromARGB(255, 41, 40, 40);

const Color backgroundColor = Colors.white;

const colorDefault = Colors.cyan;
//const colorDanger = Color.fromARGB(255, 131, 22, 22);
const colorDanger = Color.fromRGBO(241, 39, 39, 1);
const colorWarning = Color.fromRGBO(247, 126, 14, 1);
const colorWarningWithOpcaity = Color.fromARGB(164, 214, 110, 13);
//const colorWarning = Color.fromARGB(255, 148, 113, 16);
//const colorSuccess = Color.fromARGB(255, 34, 92, 36);
const colorSuccess = Color(0xff2dbe60);

class Themes {
  static final light = ThemeData(
      //  brightness: Brightness.light,
      scaffoldBackgroundColor: Color.fromARGB(255, 223, 223, 223),
      primarySwatch: mainColor,
      primaryColor: mainColor,
      primaryColorLight: Colors.blue,
      fontFamily: 'Roboto' //GoogleFonts.rubik().fontFamily
      );

  static final dark = ThemeData(
    primaryColor: mainColor,
    primarySwatch: mainColor,
    primaryColorLight: Colors.blue,
    fontFamily: 'Roboto', //GoogleFonts.rubik().fontFamily,
    brightness: Brightness.dark,
    //  scaffoldBackgroundColor: Color.fromARGB(255, 19, 18, 18),
    // backgroundColor: Colors.black,

    // buttonColor: Colors.red,
  );
}
