import 'package:eth_swap/ui/custom/alert.dart';
import 'package:eth_swap/ui/custom/alert_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showTargetThemeAlert<T>(
  BuildContext context, {
  bool barrierDismissible = true,
  Widget? title,
  Widget? content,
  required List<AlertAction> actions,
}) =>
    Theme.of(context).platform == TargetPlatform.iOS
        ? showCupertinoDialog<T>(context: context, builder: (BuildContext context) => Alert.adaptive(title: title, content: content, actions: actions))
        : showDialog<T>(
            context: context, barrierDismissible: barrierDismissible, builder: (BuildContext context) => Alert.adaptive(title: title, content: content, actions: actions));
