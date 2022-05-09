import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, HighlightedWord> _highlights = {
    "flutter": HighlightedWord(
      onTap: () => print("flutter"),
      textStyle: const TextStyle(
        color: Colors.red,
        //fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    "saman": HighlightedWord(
      onTap: () => print("saman"),
      textStyle: const TextStyle(
        color: Colors.green,
        //fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    "like": HighlightedWord(
      onTap: () => print("like"),
      textStyle: const TextStyle(
        color: Colors.purpleAccent,
        //fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  stt.SpeechToText? _speech;
  bool _islestening = false;
  String _text = "press";
  double? _confidence = 1;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Text to Speech",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _islestening,
        glowColor: Colors.red,
        endRadius: 70,
        duration: const Duration(
          milliseconds: 2000,
        ),
        repeat: true,
        repeatPauseDuration: const Duration(
          milliseconds: 100,
        ),
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
            _islestening ? Icons.mic : Icons.mic_none,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            30,
            30,
            30,
            150,
          ),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_islestening) {
      bool available = await _speech!.initialize(
        onStatus: (value) => print("status is $value"),
        onError: (value) => print("error is  $value"),
      );
      if (available) {
        setState(() {
          _islestening = true;
        });
        _speech!.listen(onResult: (value) {
          return setState(() {
            _text = value.recognizedWords;
            if (value.hasConfidenceRating && value.confidence > 0) {
              _confidence = value.confidence;
            }
          });
        });
      }
    } else {
      setState(() => _islestening = false);
      _speech!.stop();
    }
  }
}
