import 'package:eth_swap/infrastructure/web3/web_3_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_riverpod/all.dart';

abstract class Web3State {
  const Web3State();
}

class Web3Initial extends Web3State {
  const Web3Initial();
}

class VerifyingPrivateKey extends Web3State {
  const VerifyingPrivateKey();
}

class VerifiedPrivateKey extends Web3State {
  const VerifiedPrivateKey();
}

class PrivateKeyVerificationFailure extends Web3State {
  const PrivateKeyVerificationFailure(this.message);

  final String message;
}

class RunningTransaction extends Web3State {
  const RunningTransaction();
}

class TransactionSuccessful extends Web3State {
  const TransactionSuccessful();
}

class TransactionUnsuccessful extends Web3State {
  const TransactionUnsuccessful();
}

class Web3Notifier extends StateNotifier<Web3State> {
  Web3Repository _web3repository;

  Web3Notifier(this._web3repository) : super(const Web3Initial());

  Future<void> verifyPrivateKey(String _privateKey) async {
    try {
      state = VerifyingPrivateKey();

      await _web3repository.getCredentials(_privateKey);

      state = VerifiedPrivateKey();
    } catch (_) {
      state = PrivateKeyVerificationFailure(_.toString());
    }
  }
}
