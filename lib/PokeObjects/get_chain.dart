import 'package:pokedex/pokeobjects/chain.dart';
/// A class that represents the chain of evolutions of a Pokemon.
class GetChain {
  final Chain chain;
  // final List<EvoDetails> details;

  GetChain({
    required this.chain,
  });

  factory GetChain.fromJson(Map<String, dynamic> json) {
    return GetChain(
      chain: Chain.fromJson(json['chain']),
    );  
  }
}