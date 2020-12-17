import 'package:eth_swap/common/functions/show_target_theme_alert.dart';
import 'package:eth_swap/dynamic_router/path_matcher.dart';
import 'package:eth_swap/infrastructure/local_auth/local_auth_notifier.dart';
import 'package:eth_swap/infrastructure/providers.dart';
import 'package:eth_swap/infrastructure/web3/web_3_notifier.dart';
import 'package:eth_swap/ui/custom/alert_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

class PrivateKeyEntry extends StatefulWidget {
  const PrivateKeyEntry({Key? key}) : super(key: key);

  @override
  _PrivateKeyEntryState createState() => _PrivateKeyEntryState();
}

class _PrivateKeyEntryState extends State<PrivateKeyEntry> {
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
        child: ProviderListener(
          provider: localAuthNotifierProvider.state,
          onChange: (context, state) {
            if (state is PINSaved) Navigator.pushNamedAndRemoveUntil(context, PathMatcher.ethSwap, (_) => false);
          },
          child: ProviderListener(
            provider: web3NotifierProvider.state,
            onChange: (context, state) {
              if (state is PrivateKeyVerificationFailure)
                showTargetThemeAlert(
                  context,
                  content: Text(state.message),
                  actions: [
                    AlertAction(
                      () => Navigator.pop(context),
                      Text('OK'),
                    )
                  ],
                );
            },
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(
                    builder: (context, watch, _) {
                      final web3state = watch(web3NotifierProvider.state);
                      final localAuthState = watch(localAuthNotifierProvider.state);

                      if (web3state is VerifiedPrivateKey)
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
                                  if (localAuthState is! PINSaved && localAuthState is! SavingPIN)
                                    context.read(localAuthNotifierProvider).setPIN(
                                          pin: _controller.text.trim(),
                                          privateKey: web3state.privateKey,
                                        );
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
                                  if (localAuthState is! PINSaved && localAuthState is! SavingPIN)
                                    context.read(localAuthNotifierProvider).setPIN(
                                          pin: _controller.text.trim(),
                                          privateKey: web3state.privateKey,
                                        );
                                },
                                color: localAuthState is KeyNotFound
                                    ? Colors.blue
                                    : localAuthState is SavingPIN
                                        ? Colors.blueGrey
                                        : localAuthState is PinFailure
                                            ? Colors.red
                                            : Colors.green,
                                child: Icon(
                                  localAuthState is KeyNotFound
                                      ? Icons.arrow_forward_ios
                                      : localAuthState is SavingPIN
                                          ? Icons.more_horiz
                                          : localAuthState is PinFailure
                                              ? Icons.close
                                              : Icons.check,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        );

                      return Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (_) {
                                if (web3state is! VerifiedPrivateKey && web3state is! VerifyingPrivateKey)
                                  context.read(web3NotifierProvider).verifyPrivateKey(_controller.text.trim());
                              },
                              decoration: InputDecoration(
                                labelText: 'Private Key',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                if (web3state is! VerifiedPrivateKey && web3state is! VerifyingPrivateKey)
                                  context.read(web3NotifierProvider).verifyPrivateKey(_controller.text.trim());
                              },
                              color: web3state is Web3Initial
                                  ? Colors.blue
                                  : web3state is VerifyingPrivateKey
                                      ? Colors.blueGrey
                                      : web3state is PrivateKeyVerificationFailure
                                          ? Colors.red
                                          : Colors.green,
                              child: Icon(
                                web3state is Web3Initial
                                    ? Icons.arrow_forward_ios
                                    : web3state is VerifyingPrivateKey
                                        ? Icons.more_horiz
                                        : web3state is PrivateKeyVerificationFailure
                                            ? Icons.close
                                            : Icons.check,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
