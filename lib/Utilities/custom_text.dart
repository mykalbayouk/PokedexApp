import 'package:flutter/material.dart';

class CardText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const CardText(this.text, {super.key, required this.style, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
        ),
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;

  const ButtonCard(this.text, {super.key, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () => onPressed(),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
    );
  }
}
