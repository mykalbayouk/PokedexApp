import 'package:flutter/material.dart';
import 'package:pokedex/api.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex App'),
      ),

      // this is here to see how to format pulled data but will be changed in future
      body:Center( child: const Text('PokedexAPP')),
            // child: FutureBuilder<Item>(
            //   future: fetchItem(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Column(
            //         children: [
            //           Text(snapshot.data!.name.toUpperCase()),
            //           Text("ID: ${snapshot.data!.id}"),
            //           Text("Height: ${snapshot.data!.category}"),
            //           Text("Weight: ${snapshot.data!.cost}"),
            //           Image(
            //             image: snapshot.data!.image.image,
            //           ),
            //         ],
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text('${snapshot.error}');
            //     }
            //     return const CircularProgressIndicator();
            //   },
            // ),
    );
  }
}