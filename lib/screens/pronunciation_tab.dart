import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math';

class PronunciationTab extends StatefulWidget {
  @override
  _PronunciationTabState createState() => _PronunciationTabState();
}

class _PronunciationTabState extends State<PronunciationTab> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  int _score = 0;
  
  final List<Map<String, dynamic>> _pronunciationWords = [
    {
      'word': 'pronunciation',
      'phonetic': '/prəˌnʌnsiˈeɪʃən/',
      'difficulty': 'Hard',
      'color': Colors.red,
    },
    {
      'word': 'beautiful',
      'phonetic': '/ˈbjuːtɪfʊl/',
      'difficulty': 'Medium',
      'color': Colors.orange,
    },
    {
      'word': 'hello',
      'phonetic': '/həˈloʊ/',
      'difficulty': 'Easy',
      'color': Colors.green,
    },
    {
      'word': 'technology',
      'phonetic': '/tɛkˈnɒlədʒi/',
      'difficulty': 'Hard',
      'color': Colors.red,
    },
  ];
  
  int _currentWordIndex = 0;
  Map<String, dynamic> _currentWord = {};
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
    _currentWord = _pronunciationWords[_currentWordIndex];
  }

  void _initSpeech() async {
    await _speech.initialize();
  }

  void _listen() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _spokenText = val.recognizedWords;
          _score = _calculateScore(_currentWord['word'], _spokenText);
        }),
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  int _calculateScore(String target, String spoken) {
    if (spoken.isEmpty) return 0;
    
    target = target.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    spoken = spoken.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    
    if (target == spoken) return 100;
    
    // Simple similarity scoring
    int matches = 0;
    int minLength = min(target.length, spoken.length);
    
    for (int i = 0; i < minLength; i++) {
      if (i < target.length && i < spoken.length && target[i] == spoken[i]) {
        matches++;
      }
    }
    
    return ((matches / target.length) * 100).round();
  }

  void _nextWord() {
    setState(() {
      _currentWordIndex = (_currentWordIndex + 1) % _pronunciationWords.length;
      _currentWord = _pronunciationWords[_currentWordIndex];
      _spokenText = '';
      _score = 0;
    });
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pronunciation Practice',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Word Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF5F5F5)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _currentWord['color'], width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _currentWord['color'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentWord['difficulty'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${_currentWordIndex + 1}/${_pronunciationWords.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _currentWord['word'],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _currentWord['phonetic'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 30),
          
          // Score Display
          if (_spokenText.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getScoreColor(_score).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _getScoreColor(_score)),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_score%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(_score),
                    ),
                  ),
                  Text(
                    'You said: "$_spokenText"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
          
          Spacer(),
          
          // Record Button
          Center(
            child: GestureDetector(
              onTap: _listen,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isListening 
                      ? [Colors.red, Colors.redAccent]
                      : [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 30),
          
          // Next Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _nextWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Next Word',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
