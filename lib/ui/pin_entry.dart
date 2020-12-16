import 'package:eth_swap/infrastructure/local_auth/local_auth_notifier.dart';
import 'package:eth_swap/infrastructure/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

class PINEntry extends StatefulWidget {
  const PINEntry({Key? key}) : super(key: key);

  @override
  _PINEntryState createState() => _PINEntryState();
}

class _PINEntryState extends State<PINEntry> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, watch, _) {
                  final localAuthState = watch(localAuthNotifierProvider.state);

                  return Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _controller..clear(),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onSubmitted: (_) {
                            if (localAuthState is! PINValid && localAuthState is! VerifyingPIN) {
                              context.read(localAuthNotifierProvider).verifyPIN(_controller.text.trim());
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'PIN',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            if (localAuthState is! PINValid && localAuthState is! VerifyingPIN) {
                              context.read(localAuthNotifierProvider).verifyPIN(_controller.text.trim());
                            }
                          },
                          color: localAuthState is KeyFound
                              ? Colors.blue
                              : localAuthState is VerifyingPIN
                                  ? Colors.blueGrey
                                  : localAuthState is PinFailure || localAuthState is PINInvalid
                                      ? Colors.red
                                      : Colors.green,
                          child: Icon(
                            localAuthState is KeyFound
                                ? Icons.arrow_forward_ios
                                : localAuthState is VerifyingPIN
                                    ? Icons.more_horiz
                                    : localAuthState is PinFailure || localAuthState is PINInvalid
                                        ? Icons.close
                                        : Icons.check,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
