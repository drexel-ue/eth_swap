import 'package:flutter_riverpod/all.dart';

class AllObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase provider, Object value) {
    super.didAddProvider(provider, value);
    print('Initialized: ${provider.runtimeType}');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object newValue) {
    super.didUpdateProvider(provider, newValue);
    print('New Value: ${provider.runtimeType} -> ${newValue.runtimeType}');
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    super.didDisposeProvider(provider);
    print('Disposed: ${provider.runtimeType}');
  }
}
