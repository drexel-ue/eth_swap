import 'package:eth_swap/infrastructure/key_stored/key_stored_notifier.dart';
import 'package:eth_swap/infrastructure/providers.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    super.initState();
    context.read(keyStoredNotifierProvider).checkInitialStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProviderListener(
          provider: keyStoredNotifierProvider.state,
          onChange: (context, state) {
            // if(state is KeyNotFound)
          },
          child: Consumer(
            builder: (context, watch, child) {
              final state = watch(keyStoredNotifierProvider.state);

              if (state is KeyFound)
                return Icon(
                  Icons.check_circle,
                  color: Colors.green,
                );

              if (state is KeyNotFound)
                return Icon(
                  Icons.error,
                  color: Colors.red,
                );

              if (state is KeyFailure) return Text(state.message);

              return CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }
}