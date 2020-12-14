import 'package:eth_swap/common/constants/storage_constants.dart';
import 'package:eth_swap/infrastructure/storage/storage_repository.dart';
import 'package:flutter_riverpod/all.dart';

abstract class KeyStoredState {
  const KeyStoredState();
}

class KeyStoredInitial extends KeyStoredState {
  const KeyStoredInitial();
}

class KeyFound extends KeyStoredState {
  const KeyFound();
}

class KeyNotFound extends KeyStoredState {
  const KeyNotFound();
}

class KeyFailure extends KeyStoredState {
  const KeyFailure(this.message);

  final String message;
}

class KeyStoredNotifier extends StateNotifier<KeyStoredState> {
  StorageRepository _storageRepository;

  KeyStoredNotifier(this._storageRepository) : super(const KeyStoredInitial());

  Future<void> checkInitialStatus() async {
    try {
      final storedKey = await _storageRepository.getString(StorageConstants.privateKey);
      state = storedKey == null ? KeyNotFound() : KeyFound();
    } catch (e) {
      state = KeyFailure(e.toString());
    }
  }
}
