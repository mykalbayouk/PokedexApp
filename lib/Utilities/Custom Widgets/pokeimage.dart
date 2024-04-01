import 'package:flutter/material.dart';

class PokeImage extends StatelessWidget {
  final Image image;
  final double adjuster;
  const PokeImage(this.image, this.adjuster, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / (3 * adjuster),
        width: MediaQuery.of(context).size.width / (1.5 * adjuster),
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image(
                      image: image.image,
                    )),
              ),
              Center(
                child: Image(
                  image: const AssetImage('assets/images/pokedexFrame.png'),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}