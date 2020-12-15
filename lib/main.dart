import 'package:eth_swap/dynamic_router/dynamic_router.dart';
import 'package:eth_swap/infrastructure/all_observer.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_riverpod/all.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [AllObserver()],
      child: MaterialApp(
        title: 'EthSwap',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        onGenerateRoute: DynamicRouter.onGenerateRoute,
      ),
    );
  }
}
