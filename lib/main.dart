import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MotoApp/providers/walkthrough_provider.dart';
import 'package:MotoApp/router.dart';
import 'package:MotoApp/styles/theme_data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => WalkthroughProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: ThemeScheme.light(),
        initialRoute: WalkthroughRoute,
      ),
    ),
  );
}
