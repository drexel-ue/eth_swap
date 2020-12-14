// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

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
        return _FadeRoute((BuildContext context) => matcher.builder(context, match), settings);
      }
    }

    return _FadeRoute((context) => Landing(), settings);
  }
}

class _FadeRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  _FadeRoute(this.builder, RouteSettings settings)
      : super(
          settings: settings,
          pageBuilder: (context, __, ___) => builder(context),
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
