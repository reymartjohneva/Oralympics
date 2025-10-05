// ==================== FILE: home_screen.dart ====================
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'SpeakSmart',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Master Languages with AI',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tab Navigation
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Color(0xFF667eea),
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Speech'),
                    Tab(text: 'Practice'),
                    Tab(text: 'Listen'),
                    Tab(text: 'Games'),
                  ],
                ),
              ),
              
              // Content Area
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SpeechRecognitionTab(),
                      PronunciationTab(),
                      TextToSpeechTab(),
                      MiniGamesTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Speech Recognition Tab
class SpeechRecognitionTab extends StatefulWidget {
  @override
  _SpeechRecognitionTabState createState() => _SpeechRecognitionTabState();
}

class _SpeechRecognitionTabState extends State<SpeechRecognitionTab>
    with TickerProviderStateMixin {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  final List<String> _practiceWords = [
    'Hello, how are you today?',
    'The weather is beautiful outside.',
    'I love learning new languages.',
    'Practice makes perfect.',
    'Technology is amazing.',
  ];

  String _currentPracticeWord = '';
  int _currentWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _initSpeech();
    _currentPracticeWord = _practiceWords[_currentWordIndex];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (!available) {
      print('The user has denied the use of speech recognition.');
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _animationController.repeat(reverse: true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _animationController.stop();
      _speech.stop();
    }
  }

  void _nextWord() {
    setState(() {
      _currentWordIndex = (_currentWordIndex + 1) % _practiceWords.length;
      _currentPracticeWord = _practiceWords[_currentWordIndex];
      _text = '';
      _confidence = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speech Recognition',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Practice Word Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  'Practice Sentence:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _currentPracticeWord,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 30),
          
          // Microphone Button
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isListening ? _pulseAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: _listen,
                    child: Container(
                      width: 120,
                      height: 120,
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
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 30),
          
          // Recognition Result
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What you said:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _text.isEmpty ? 'Tap the microphone to start speaking...' : _text,
                  style: TextStyle(
                    fontSize: 16,
                    color: _text.isEmpty ? Colors.grey[500] : Colors.black87,
                  ),
                ),
                if (_text.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(
                    'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          Spacer(),
          
          // Next Word Button
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
                'Next Sentence',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pronunciation Scoring Tab
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

// Text-to-Speech Tab
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

// Mini Games Tab
class MiniGamesTab extends StatefulWidget {
  @override
  _MiniGamesTabState createState() => _MiniGamesTabState();
}

class _MiniGamesTabState extends State<MiniGamesTab> {
  int _selectedGame = 0;
  
  final List<Map<String, dynamic>> _games = [
    {
      'title': 'Word Matching',
      'description': 'Match words with their meanings',
      'icon': Icons.link,
      'color': Colors.blue,
    },
    {
      'title': 'Fill in the Blank',
      'description': 'Complete the sentences',
      'icon': Icons.edit,
      'color': Colors.green,
    },
    {
      'title': 'Synonyms',
      'description': 'Find words with similar meanings',
      'icon': Icons.compare,
      'color': Colors.orange,
    },
    {
      'title': 'Word Scramble',
      'description': 'Unscramble the letters',
      'icon': Icons.shuffle,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mini Games',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Game Selection
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGame = index;
                    });
                    _showGameDialog(context, game);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          game['color'].withOpacity(0.8),
                          game['color'],
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: game['color'].withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            game['icon'],
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            game['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            game['description'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showGameDialog(BuildContext context, Map<String, dynamic> game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  game['icon'],
                  size: 60,
                  color: game['color'],
                ),
                SizedBox(height: 15),
                Text(
                  game['title'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: game['color'],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  game['description'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildGameContent(game['title']),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showGameDialog(context, game);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: game['color'],
                        ),
                        child: Text('New Game', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameContent(String gameType) {
    switch (gameType) {
      case 'Word Matching':
        return _buildWordMatchingGame();
      case 'Fill in the Blank':
        return _buildFillInBlankGame();
      case 'Synonyms':
        return _buildSynonymsGame();
      case 'Word Scramble':
        return _buildWordScrambleGame();
      default:
        return Container();
    }
  }

  Widget _buildWordMatchingGame() {
    final words = ['Happy', 'Sad', 'Fast', 'Slow'];
    final meanings = ['Joyful', 'Unhappy', 'Quick', 'Not fast'];
    
    return Container(
      height: 200,
      child: Column(
        children: [
          Text('Match the words with their meanings:'),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: words.map((word) => 
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(word),
                      )
                    ).toList(),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: meanings.map((meaning) => 
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(meaning),
                      )
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFillInBlankGame() {
    return Container(
      height: 150,
      child: Column(
        children: [
          Text('Fill in the blank:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Text(
            'The weather is _____ today.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: ['beautiful', 'terrible', 'cold', 'hot'].map((word) =>
              ElevatedButton(
                onPressed: () {},
                child: Text(word),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.8),
                  foregroundColor: Colors.white,
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSynonymsGame() {
    return Container(
      height: 150,
      child: Column(
        children: [
          Text('Find the synonym for "Happy":', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: ['Sad', 'Joyful', 'Angry', 'Tired'].map((word) =>
              ElevatedButton(
                onPressed: () {},
                child: Text(word),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.withOpacity(0.8),
                  foregroundColor: Colors.white,
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordScrambleGame() {
    return Container(
      height: 150,
      child: Column(
        children: [
          Text('Unscramble the word:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'LEOPH',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your answer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}