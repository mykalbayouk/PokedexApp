import 'package:flutter/material.dart';

/// A custom text widget. 
/// Displays text in a card with a specified style and alignment.
class CardText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const CardText(this.text, {super.key, required this.style, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
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

/// A custom button widget. 
/// Displays a button in a card with a specified text, onPressed function, and color.
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
