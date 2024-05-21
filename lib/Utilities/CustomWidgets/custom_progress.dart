import 'package:flutter/material.dart';

Container customProgressIndicator(BuildContext context, Color color) {
  return Container(
    height: MediaQuery.of(context).size.height / 30,
    width: MediaQuery.of(context).size.width / 15,
    color: color,
    child: Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 20,
          width: MediaQuery.of(context).size.width / 20,
          child: const Center(child: CircularProgressIndicator())),
    ),
  );
}
