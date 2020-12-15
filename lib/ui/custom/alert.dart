import 'package:eth_swap/ui/custom/alert_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<AlertAction> actions;

  Alert._({Key? key, this.title, this.content, required this.actions}) : super(key: key);

  factory Alert.adaptive({Key? key, Widget? title, Widget? content, required List<AlertAction> actions}) => Alert._(key: key, title: title, content: content, actions: actions);

  @override
  Widget build(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS
      ? CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions.map((AlertAction action) => CupertinoDialogAction(onPressed: action.function, child: action.widget)).toList(),
        )
      : AlertDialog(
          title: title,
          content: content,
          actions: actions.map((AlertAction action) => FlatButton(onPressed: action.function, child: action.widget)).toList(),
        );
}
