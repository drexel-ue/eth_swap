import 'package:eth_swap/ui/landing.dart';
import 'package:eth_swap/ui/private_key_entry.dart';
import 'package:flutter/material.dart';

class PathMatcher {
  static const landing = '/';
  static const privateKeyEntry = '/privatekeyentry';

  PathMatcher(String pattern, this.builder) : regExp = RegExp(pattern);

  final RegExp regExp;
  final Widget Function(BuildContext, String?) builder;

  static final matchers = [
    PathMatcher(privateKeyEntry, (context, match) => const PrivateKeyEntry()),
    PathMatcher(landing, (context, match) => const Landing()),
  ];
}
