import 'package:eth_swap/ui/landing.dart';
import 'package:flutter/material.dart';

class DynamicRouter {
  static Route onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (BuildContext context) => Landing(),
        settings: settings,
      );
}
