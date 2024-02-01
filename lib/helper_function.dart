import 'package:flutter/material.dart';

class TruncatedText extends StatelessWidget {
  final String fullText;
  final double fontSize;

  TruncatedText({required this.fullText, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    // Split the full text into words
    List<String> words = fullText.split(' ');

    // Take the first 10 words
    List<String> truncatedWords = words.take(30).toList();

    // Join the words back into a string
    String truncatedText = truncatedWords.join(' ');

    return Text(
      truncatedText,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontSize: fontSize
      ),
    );
  }
}