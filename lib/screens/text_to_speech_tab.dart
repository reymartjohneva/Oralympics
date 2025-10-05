import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechTab extends StatefulWidget {
  @override
  _TextToSpeechTabState createState() => _TextToSpeechTabState();
}

class _TextToSpeechTabState extends State<TextToSpeechTab> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController _textController = TextEditingController();
  bool _isSpeaking = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  
  final List<String> _sampleTexts = [
    "Hello! Welcome to our language learning app.",
    "The quick brown fox jumps over the lazy dog.",
    "Practice makes perfect when learning languages.",
    "Technology has revolutionized education today.",
    "Artificial intelligence helps us learn better.",
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _textController.text = _sampleTexts[0];
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(_speechRate);
    await flutterTts.setPitch(_pitch);
    
    flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  void _speak() async {
    if (_textController.text.isNotEmpty) {
      await flutterTts.speak(_textController.text);
    }
  }

  void _stop() async {
    await flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  void _loadSampleText() {
    setState(() {
      _textController.text = (_sampleTexts..shuffle()).first;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text-to-Speech',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Text Input
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _textController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Enter text to be spoken...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Sample Text Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _loadSampleText,
              icon: Icon(Icons.refresh),
              label: Text('Load Sample Text'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF667eea),
                side: BorderSide(color: Color(0xFF667eea)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          
          SizedBox(height: 30),
          
          // Speech Controls
          Text(
            'Speech Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),
          
          // Speech Rate Slider
          Row(
            children: [
              Icon(Icons.speed, color: Colors.grey[600]),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speed: ${(_speechRate * 2).toStringAsFixed(1)}x',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _speechRate,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      activeColor: Color(0xFF667eea),
                      onChanged: (value) async {
                        setState(() {
                          _speechRate = value;
                        });
                        await flutterTts.setSpeechRate(_speechRate);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Pitch Slider
          Row(
            children: [
              Icon(Icons.music_note, color: Colors.grey[600]),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pitch: ${_pitch.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _pitch,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      activeColor: Color(0xFF667eea),
                      onChanged: (value) async {
                        setState(() {
                          _pitch = value;
                        });
                        await flutterTts.setPitch(_pitch);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Spacer(),
          
          // Control Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSpeaking ? null : _speak,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Speak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSpeaking ? _stop : null,
                  icon: Icon(Icons.stop),
                  label: Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
