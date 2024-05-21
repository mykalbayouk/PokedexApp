  import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/pokeobjects/evo_details.dart';

String evoDetailAttr(EvoDetails evoDetails) {
    if (evoDetails.trigger == 'level-up') {
      String level = evoDetails.minLevel.toString();
      if (level == '') {
        if (evoDetails.minHappiness != '') {
          level = evoDetails.minHappiness.toString();
          return 'Happy: $level';
        } else if (evoDetails.location != '') {
          return 'Location: ${makePretty(evoDetails.location['name'].toString())}';
        } else {
          return 'Level: $level';
        }
      } else {
        return 'Level: $level';
      }
    } else if (evoDetails.trigger == 'use-item') {
      return makePretty(evoDetails.item['name']);
    } else if (evoDetails.trigger == 'trade') {
      return 'Trade';
    } else {
      return evoDetails.trigger;
    }
  }