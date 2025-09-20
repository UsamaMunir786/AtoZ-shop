import 'package:a_to_z_user/firebase_options.dart';
import 'package:a_to_z_user/pages/home_page.dart';
import 'package:a_to_z_user/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildShrineTheme(){
    final ThemeData base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: kShrinePink400,
        onPrimary: kShrineBrown900,
        secondary: kShrineBrown900,
        error: kShrineErrorRed
      ),
      textTheme: _buildShrineTextTheme(GoogleFonts.ralewayTextTheme()),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: kShrinePink100
      )
    );
  }
  
  TextTheme _buildShrineTextTheme(TextTheme base){
    return base.copyWith(
      headlineSmall: base.headlineSmall!.copyWith(
        fontWeight: FontWeight.w500
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontSize: 18
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      bodyLarge: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ).apply(
      displayColor: kShrineBrown900,
      bodyColor: kShrineBrown900
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildShrineTheme(),
      home: const HomePage(),
    );
  }
}

