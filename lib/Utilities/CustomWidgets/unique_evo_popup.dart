import 'package:flutter/material.dart';
import 'package:pokedex/Utilities/Functions/evo_detail_string.dart';
import 'package:pokedex/layouts/pokemon_details.dart';
import 'package:pokedex/pokeobjects/evo_details.dart';

int evoType = 0;
// there are a variety of unique evolution types
//        - 1
// 1 - 1 - 1   -> this will be type 1 (one to one to 2+)
//        - 1

//    - 1
// 1 - 1   -> this will be type 2 (one to 2+)
//

// 1 - 1 - 1
//   - 1 - 1    -> this will be type 3 (1 to 2+ to 2+)

// type 4 will be for applin since he has type 2 and type 3

// type 3 is only wurmple so i can hard code that same with type 4
bool isUniqueEvolution(String pokemon) {
  switch (pokemon) {
    case 'oddish':
      evoType = 1;
      return true;
    case 'poliwag':
      evoType = 1;
      return true;
    case 'slowpoke':
      evoType = 2;
      return true;
    case 'scyther':
      evoType = 2;
      return true;
    case 'eevee':
      evoType = 2;
      return true;
    case 'tyrogue':
      evoType = 2;
      return true;
    case 'wurmple':
      evoType = 3;
      return true;
    case 'ralts':
      evoType = 1;
      return true;
    case 'nincada':
      evoType = 2;
      return true;
    case 'snorunt':
      evoType = 2;
      return true;
    case 'clamperl':
      evoType = 2;
      return true;
    case 'burmy':
      evoType = 2;
      return true;
    case 'cosmog':
      evoType = 1;
      return true;
    case 'applin':
      evoType = 4;
      return true;
    case 'charcadet':
      evoType = 2;
      return true;
    case 'rockruff':
      evoType = 2;
      return true;
    case 'toxel':
      evoType = 2;
      return true;
    case 'kubfu':
      evoType = 2;
      return true;
    case 'tandemaus':
      evoType = 2;
      return true;
    default:
      return false;
  }
}

int customHeight(int numOfEvos) {
  if (numOfEvos <= 5) {
    return 3;
  } else if (numOfEvos < 8) {
    return 2;
  } else {
    return 1;
  }
}

List<String> modifyIfUnique(List<dynamic> evolutions) {
  List<String> newEvolutions = [];
  if (evolutions[0] == 'rockruff') {
    newEvolutions.add('rockruff');
    newEvolutions.add('lycanroc-midday');
    newEvolutions.add('lycanroc-midnight');
    newEvolutions.add('lycanroc-dusk');
  } else if (evolutions[0] == 'wishiwashi') {
    newEvolutions.add('wishiwashi-solo');
    newEvolutions.add('wishiwashi-school');
  } else if (evolutions[0] == 'minior') {
    newEvolutions.add('minior-red-meteor');
    newEvolutions.add('minior-orange-meteor');
    newEvolutions.add('minior-yellow-meteor');
    newEvolutions.add('minior-green-meteor');
    newEvolutions.add('minior-blue-meteor');
    newEvolutions.add('minior-indigo-meteor');
    newEvolutions.add('minior-violet-meteor');
    newEvolutions.add('minior-red-core');
    newEvolutions.add('minior-orange-core');
    newEvolutions.add('minior-yellow-core');
    newEvolutions.add('minior-green-core');
    newEvolutions.add('minior-blue-core');
    newEvolutions.add('minior-indigo-core');
    newEvolutions.add('minior-violet-core');
  } else if (evolutions[0] == 'burmy') {
    newEvolutions.add('burmy');
    newEvolutions.add('wormadam-plant');
    newEvolutions.add('wormadam-sandy');
    newEvolutions.add('wormadam-trash');
    newEvolutions.add('mothim');
  } else {
    newEvolutions = evolutions.cast<String>();
  }
  return newEvolutions;
}

void uniqueEvolutionPopUp(BuildContext context, List<dynamic> evolutions,
    List<EvoDetails> evoDetails, List<Image>? evoImages, String currentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (evoDetails.length != evolutions.length) {
        for (var i = 0; i < evolutions.length; i++) {
          evoDetails.add(evoDetails.last);
        }
      }
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
        content: evoType == 1
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height /
                    customHeight(evolutions.length),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        selectedMon(context, evolutions[0], currentId),
                      },
                      child: Image(
                        image: evoImages![0].image,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                          Text(
                            evoDetailAttr(evoDetails[0]),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        selectedMon(context, evolutions[1], currentId),
                      },
                      child: Image(
                        image: evoImages[1].image,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 2; i < evolutions.length; i++)
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).primaryColor,
                                      size: 50,
                                    ),
                                    Text(
                                      evoDetailAttr(evoDetails[i - 1]),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context).pop(),
                                    selectedMon(
                                        context, evolutions[i], currentId),
                                  },
                                  child: Image(
                                    image: evoImages[i].image,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              )
            : evoType == 2
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height /
                            customHeight(evolutions.length),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).pop(),
                                selectedMon(context, evolutions[0], currentId),
                              },
                              child: Image(
                                image: evoImages![0].image,
                              ),
                            ),
                            Column(
                              children: [
                                for (var i = 1; i < evolutions.length; i++)
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                            Text(
                                              evoDetailAttr(evoDetails[i - 1]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).pop(),
                                            selectedMon(context, evolutions[i],
                                                currentId),
                                          },
                                          child: Image(
                                            image: evoImages[i].image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        )),
                  )
                : evoType == 3
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height /
                              customHeight(evolutions.length),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context).pop(),
                                  selectedMon(
                                      context, evolutions[0], currentId),
                                },
                                child: Image(
                                  image: evoImages![0].image,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                            Text(
                                              evoDetailAttr(evoDetails[0]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "+ Personality \nValue",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w300,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).pop(),
                                            selectedMon(context, evolutions[1],
                                                currentId),
                                          },
                                          child: Image(
                                            image: evoImages[1].image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                            Text(
                                              evoDetailAttr(evoDetails[2]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "+ Personality \nValue",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w300,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).pop(),
                                            selectedMon(context, evolutions[3],
                                                currentId),
                                          },
                                          child: Image(
                                            image: evoImages[3].image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                            Text(
                                              evoDetailAttr(evoDetails[1]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).pop(),
                                            selectedMon(context, evolutions[2],
                                                currentId),
                                          },
                                          child: Image(
                                            image: evoImages[2].image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                            Text(
                                              evoDetailAttr(evoDetails[3]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).pop(),
                                            selectedMon(context, evolutions[4],
                                                currentId),
                                          },
                                          child: Image(
                                            image: evoImages[4].image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : evoType == 4
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height /
                                  customHeight(evolutions.length),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).pop(),
                                      selectedMon(
                                          context, evolutions[0], currentId),
                                    },
                                    child: Image(
                                      image: evoImages![0].image,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 50,
                                                ),
                                                Text(
                                                  evoDetailAttr(evoDetails[0]),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                Navigator.of(context).pop(),
                                                selectedMon(context,
                                                    evolutions[1], currentId),
                                              },
                                              child: Image(
                                                image: evoImages[1].image,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 50,
                                                ),
                                                Text(
                                                  evoDetailAttr(evoDetails[1]),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                Navigator.of(context).pop(),
                                                selectedMon(context,
                                                    evolutions[2], currentId),
                                              },
                                              child: Image(
                                                image: evoImages[2].image,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 30,
                                                ),
                                                Text(
                                                  'Syrupy Apple',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                Navigator.of(context).pop(),
                                                selectedMon(context,
                                                    evolutions[3], currentId),
                                              },
                                              child: Image(
                                                image: evoImages[3].image,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 30,
                                                ),
                                                Text(
                                                  'Level up \nwhile knowing \nDragon Cheer',
                                                  style: TextStyle(
                                                    fontSize: 6,
                                                    fontWeight: FontWeight.w300,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                Navigator.of(context).pop(),
                                                selectedMon(context,
                                                    evolutions[4], currentId),
                                              },
                                              child: Image(
                                                image: evoImages[4].image,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Text(
                            'Unknown Evolution Type. Please contact the developer.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
      );
    },
  );
}
