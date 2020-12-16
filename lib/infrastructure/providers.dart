// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:eth_swap/infrastructure/local_auth/local_auth_notifier.dart';
import 'package:eth_swap/infrastructure/storage/storage_repository.dart';
import 'package:eth_swap/infrastructure/web3/web_3_notifier.dart';
import 'package:eth_swap/infrastructure/web3/web_3_repository.dart';
import 'package:flutter_riverpod/all.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) => StorageRepositoryImpl());

final _web3RepositoryProvider = Provider<Web3Repository>((ref) => Web3RepositoryImpl());

final web3NotifierProvider = StateNotifierProvider((ref) => Web3Notifier(ref.watch(_web3RepositoryProvider)));

final localAuthNotifierProvider = StateNotifierProvider((ref) => LocalAuthNotifier(ref.watch(storageRepositoryProvider)));
