import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/theme.dart';

import './screens/home.dart';
import './size_config.dart';
import './routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: ((_) => DummyData()),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig _size = SizeConfig();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: Home.routeName,
      routes: routes,
    );
  }
}
