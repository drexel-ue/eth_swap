import 'package:flutter/widgets.dart';

class AlertAction {
  final void Function() function;
  final Widget widget;

  AlertAction(this.function, this.widget);
}
