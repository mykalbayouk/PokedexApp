// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/custom_text.dart';
import 'package:pokedex/Utilities/pokeimage.dart';
import 'package:pokedex/Utilities/string_extension.dart';
import 'package:provider/provider.dart';

class DetailAppState extends ChangeNotifier {
  bool isPressed = false;

  void changePressed() {
    isPressed = !isPressed;
    notifyListeners();
  }


}

class PokeDetails extends StatefulWidget {
  AsyncSnapshot<Pokemon> snapshot;

  PokeDetails({super.key, required this.snapshot});

  @override
  State<PokeDetails> createState() => _PokeDetailsState();
}

class _PokeDetailsState extends State<PokeDetails> {
  
  void detailsPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CardText(
            "Details",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(            
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Height: ${widget.snapshot.data!.height}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Weight: ${widget.snapshot.data!.weight}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<DetailAppState>();
    bool isPressed = appState.isPressed;
    var sprite = isPressed ? widget.snapshot.data!.shinySprite : widget.snapshot.data!.sprite;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.snapshot.data!.name.capitalize(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(            
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColorLight),
                          elevation: MaterialStateProperty.all<double>(0),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          splashFactory: NoSplash.splashFactory,
                          animationDuration: Duration.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          enableFeedback: false,
                          // i want to remove the color change when the button is pressed
                        ),
                        onPressed: () => {                          
                          setState(() {
                            appState.changePressed();
                          })                         
                        },
                        child: PokeImage(sprite, 2.5)),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          size: 30,
                          color: Theme.of(context).primaryColorDark,
                          ),
                        onPressed: () => {
                          detailsPopUp(context)
                        }
                      ),
                    ],
                  ),                
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  CardText(
                    'ID: ${widget.snapshot.data!.id}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text('Types: ${widget.snapshot.data!.types[0]['type']['name']} ${widget.snapshot.data!.types.length > 1 ? 'and ${widget.snapshot.data!.types[1]['type']['name']}' : ''}'),
            ],
          ),
        ),
      ),
    );
  }
}
