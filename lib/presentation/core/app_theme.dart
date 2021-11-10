import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';

class AppTheme {
  static int _primaryValue = 0xff1762AB;

  static ThemeData get defaultTheme {
    return ThemeData(
      dialogTheme: dialogTheme,
      pageTransitionsTheme: transitionTheme,
      cardTheme: cardTheme,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          primary: Color(_primaryValue),
          primaryVariant: primarySwatch[900]!,
          onPrimary: Colors.white,
          secondary: Color(0xff17ABAA),
          secondaryVariant: Color(0xff126C6C),
          onSecondary: Colors.white,
          background: Color(0xffc2c2c2),
          onBackground: Colors.black,
          surface: Color(0xffD6D8D8),
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light),
      /*primarySwatch: primarySwatch,
       accentColor: Color(0xff17ABAA),
       scaffoldBackgroundColor: Color(0xffD4D8DB),*/
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      dialogTheme: dialogTheme,
      pageTransitionsTheme: transitionTheme,
      cardTheme: cardTheme,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
          primary: Color(0xff0E79DE),
          primaryVariant:Color(0xff1B3E5F),
          onPrimary: Colors.white,
          secondary: Color(0xff107A79),
          secondaryVariant: Color(0xff126C6C),
          onSecondary: Colors.white,
          background: Color(0xff2a2a2a),
          onBackground: Colors.white,
          surface: Color(0xff1B3E5F),
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,),
      /*primarySwatch: primarySwatch,
       accentColor: Color(0xff17ABAA),
       scaffoldBackgroundColor: Color(0xffD4D8DB),*/
    );
  }

  static CardTheme cardTheme = CardTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.CARD_BORDER_RADIUS)));

  static DialogTheme dialogTheme = DialogTheme(
      elevation: Constants.DIALOG_ELEVATION,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.DIALOG_BORDER_RADIUS)));

  static PageTransitionsTheme transitionTheme = PageTransitionsTheme(
      builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()});

  static MaterialColor primarySwatch = MaterialColor(_primaryValue, {
    50: Color(0xff2694FE),
    100: Color(0xff2286E7),
    200: Color(0xff1D76CC),
    300: Color(0xff196BBB),
    400: Color(0xff1D6EBC),
    500: Color(_primaryValue),
    600: Color(0xff135696),
    700: Color(0xff0D4D8A),
    800: Color(0xff0B4780),
    900: Color(0xff083E71)
  });

}
