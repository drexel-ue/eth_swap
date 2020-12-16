import 'package:eth_swap/ui/eth_swap.dart';
import 'package:eth_swap/ui/landing.dart';
import 'package:eth_swap/ui/pin_entry.dart';
import 'package:eth_swap/ui/private_key_entry.dart';
import 'package:flutter/material.dart';

class PathMatcher {
  static const landing = '/';
  static const privateKeyEntry = '/private_key_entry';
  static const pinEntry = '/pin_entry';
  static const ethSwap = '/eth_swap';

  PathMatcher(String pattern, this.builder) : regExp = RegExp(pattern);

  final RegExp regExp;
  final Widget Function(BuildContext, String?) builder;

  static final matchers = [
    PathMatcher(ethSwap, (context, match) => const EthSwap()),
    PathMatcher(pinEntry, (context, match) => const PINEntry()),
    PathMatcher(privateKeyEntry, (context, match) => const PrivateKeyEntry()),
    PathMatcher(landing, (context, match) => const Landing()),
  ];
}
