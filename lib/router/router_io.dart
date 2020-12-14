import 'dart:io';

import 'package:eth_swap/router/path_matcher.dart';
import 'package:eth_swap/ui/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Router {
  static const home = '/';
  static const aboutUs = '/aboutus';
  static const heroes = '/heroes';
  static const princesses = '/princesses';

  static Route onGenerateRoute(RouteSettings settings) {
    for (final matcher in PathMatcher.matchers) {
      if (matcher.regExp.hasMatch(settings.name?.toLowerCase())) {
        final firstMatch = matcher.regExp.firstMatch(settings.name?.toLowerCase());
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;

        return Platform.isIOS
            ? CupertinoPageRoute(
                builder: (BuildContext context) => matcher.builder(context, match),
                settings: settings,
              )
            : MaterialPageRoute(
                builder: (BuildContext context) => matcher.builder(context, match),
                settings: settings,
              );
      }
    }

    return Platform.isIOS
        ? CupertinoPageRoute(
            builder: (BuildContext context) => Landing(),
            settings: settings,
          )
        : MaterialPageRoute(
            builder: (BuildContext context) => Landing(),
            settings: settings,
          );
  }
}
