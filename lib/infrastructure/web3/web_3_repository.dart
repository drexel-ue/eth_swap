// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

abstract class Web3Repository {
  Future<void> getCredentials(String _privateKey);
}

class Web3RepositoryImpl extends Web3Repository {
  static const String _rpcUrl = String.fromEnvironment('RPC_URL');
  static const String _wsUrl = String.fromEnvironment('WS_URL');

  late final Web3Client _client;
  late final Credentials _credentials;
  late final EthereumAddress _ownAddress;

  late final String _ethSwapAbiCode;
  late final EthereumAddress _ethSwapContractAddress;
  late final DeployedContract _ethSwapContract;
  late final ContractFunction _buyTokens;
  late final ContractFunction _sellTokens;
  late final ContractEvent _tokensPurchasedEvent;
  late final ContractEvent _tokensSoldEvent;

  late final String _tokenAbiCode;
  late final EthereumAddress _tokenContractAddress;
  late final DeployedContract _tokenContract;
  late final ContractFunction _approveSale;
  late final ContractEvent _saleApprovedEvent;

  Web3RepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );

    await _getAbi();
  }

  Future<void> _getAbi() async {
    String ethSwapAbiString = await rootBundle.loadString('src/abis/EthSwap.json');
    final ethSwapAbiJson = jsonDecode(ethSwapAbiString);
    _ethSwapAbiCode = jsonEncode(ethSwapAbiJson['abi']);
    _ethSwapContractAddress = EthereumAddress.fromHex(ethSwapAbiJson['networks']['5777']['address']);

    String tokenAbiString = await rootBundle.loadString('src/abis/Token.json');
    final tokenAbiJson = jsonDecode(tokenAbiString);
    _tokenAbiCode = jsonEncode(tokenAbiJson['abi']);
    _tokenContractAddress = EthereumAddress.fromHex(tokenAbiJson['networks']['5777']['address']);

    await _getDeployedContract();
  }

  @override
  Future<void> getCredentials(String _privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> _getDeployedContract() async {
    _ethSwapContract = DeployedContract(ContractAbi.fromJson(_ethSwapAbiCode, 'EthSwap'), _ethSwapContractAddress);
    _buyTokens = _ethSwapContract.function('buyTokens');
    _sellTokens = _ethSwapContract.function('sellTokens');
    _tokensSoldEvent = _ethSwapContract.event('TokensSold');
    _tokensPurchasedEvent = _ethSwapContract.event('TokensPurchsed');

    _tokenContract = DeployedContract(ContractAbi.fromJson(_tokenAbiCode, 'Token'), _tokenContractAddress);
    _approveSale = _tokenContract.function('approve');
    _saleApprovedEvent = _tokenContract.event('Approval');
  }
}
