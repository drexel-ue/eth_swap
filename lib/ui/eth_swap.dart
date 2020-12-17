import 'package:eth_swap/infrastructure/providers.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:eth_swap/ui/breakpoints.dart';
import 'package:flutter/material.dart';

class EthSwap extends StatefulWidget {
  const EthSwap({Key? key}) : super(key: key);

  @override
  _EthSwapState createState() => _EthSwapState();
}

class _EthSwapState extends State<EthSwap> {
  @override
  void initState() {
    super.initState();
    context.read(web3NotifierProvider).balanceOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EthSwap'),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
        ),
      ),
    );
  }
}
