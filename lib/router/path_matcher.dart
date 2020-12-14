import 'package:flutter/material.dart';

class PathMatcher {
  static const landing = '/';

  PathMatcher(String pattern, this.builder) : regExp = RegExp(pattern);

  final RegExp regExp;
  final Widget Function(BuildContext, String) builder;

  static final matchers = [];
}
