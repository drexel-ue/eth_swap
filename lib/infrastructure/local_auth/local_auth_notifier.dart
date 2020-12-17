import 'package:eth_swap/common/constants/storage_constants.dart';
import 'package:eth_swap/infrastructure/storage/storage_repository.dart';
import 'package:flutter_riverpod/all.dart';

abstract class LocalAuthState {
  const LocalAuthState();
}

class LocalAuthInitial extends LocalAuthState {
  const LocalAuthInitial();
}

class KeyFound extends LocalAuthState {
  const KeyFound();
}

class KeyNotFound extends LocalAuthState {
  const KeyNotFound();
}

class KeyFailure extends LocalAuthState {
  const KeyFailure(this.message);

  final String message;
}

class SavingPIN extends LocalAuthState {
  const SavingPIN();
}

class PINSaved extends LocalAuthState {
  const PINSaved();
}

class PINInvalid extends LocalAuthState {
  const PINInvalid();
}

class PINValid extends LocalAuthState {
  const PINValid(this.privateKey);

  final String privateKey;
}

class VerifyingPIN extends LocalAuthState {
  const VerifyingPIN();
}

class PinFailure extends LocalAuthState {
  const PinFailure(this.message);

  final String message;
}

class LocalAuthNotifier extends StateNotifier<LocalAuthState> {
  StorageRepository _storageRepository;

  LocalAuthNotifier(this._storageRepository) : super(const LocalAuthInitial());

  Future<void> checkInitialStatus() async {
    await _storageRepository.removeAll();
    try {
      final storedKey = await _storageRepository.getString(StorageConstants.privateKey);
      final storedPIN = await _storageRepository.getString(StorageConstants.pin);
      state = storedKey != null && storedPIN != null ? KeyFound() : KeyNotFound();
    } catch (e) {
      state = KeyFailure(e.toString());
    }
  }

  Future<void> setPIN({required String pin, required String privateKey}) async {
    try {
      state = SavingPIN();
      await _storageRepository.setString(key: StorageConstants.pin, value: pin);
      await _storageRepository.setString(key: StorageConstants.privateKey, value: privateKey);
      state = PINSaved();
    } catch (e) {
      state = PinFailure(e.toString());
    }
  }

  Future<void> verifyPIN(String _pin) async {
    try {
      state = VerifyingPIN();
      final storedPIN = await _storageRepository.getString(StorageConstants.pin);
      state = storedPIN == _pin ? PINValid((await _storageRepository.getString(StorageConstants.privateKey)) ?? '') : PINInvalid();
    } catch (e) {
      state = PinFailure(e.toString());
    }
  }
}
