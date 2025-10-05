import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'feedback_page.dart';

class SpeechRecognitionTab extends StatefulWidget {
  @override
  _SpeechRecognitionTabState createState() => _SpeechRecognitionTabState();
}

class _SpeechRecognitionTabState extends State<SpeechRecognitionTab>
    with TickerProviderStateMixin {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isRecording = false;
  String _text = '';
  double _confidence = 1.0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  // Timer variables
  Timer? _timer;
  int _seconds = 0;
  
  // Reading progress
  double _readingProgress = 0.45; // Example: 45% completed
  
  final String _todayPassage = '''In the heart of the bustling city, where the sounds of traffic and conversation blend into a symphony of urban life, there stands a small bookshop that has remained unchanged for decades. The worn wooden shelves are filled with books that tell stories of adventure, romance, and mystery. Each morning, the elderly owner opens the door with a gentle smile, welcoming readers who seek refuge from the fast-paced world outside.''';
  
  final List<String> _readingTips = [
    'Take your time - good pronunciation is more important than speed',
    'Pause at commas and periods to improve your pacing',
    'Emphasize important words to show understanding',
    'Practice breathing exercises before reading aloud',
    'Read with emotion to make your speech more engaging',
  ];
  
  int _currentTipIndex = 0;

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
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleRecording() async {
    if (!_isRecording) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isRecording = true);
        _startTimer();
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
      setState(() => _isRecording = false);
      _stopTimer();
      _animationController.stop();
      _speech.stop();
    }
  }

  void _nextTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % _readingTips.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Reading Practice',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563eb),
            ),
          ),
          SizedBox(height: 20),

          // Reading Progress Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Color(0xFF10b981), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Reading Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${(_readingProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10b981),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _readingProgress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10b981)),
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Text(
                  'Keep going! You\'re doing great.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Today's Passage
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Color(0xFF2563eb), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Today\'s Passage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  _todayPassage,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Reading Tip
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFFFE69C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xFFFF8C00), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Reading Tip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _nextTip,
                      child: Icon(Icons.refresh, color: Color(0xFFFF8C00), size: 18),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _readingTips[_currentTipIndex],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Timer Display
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatTime(_seconds),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isRecording ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Recording Button
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isRecording ? _pulseAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : Color(0xFF2563eb),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 30),

          // Control Buttons (Play, Pause, Stop)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play Button
              GestureDetector(
                onTap: _isRecording ? null : _toggleRecording,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.grey[300] : Color(0xFF64B5F6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              // Pause Button
              GestureDetector(
                onTap: _isRecording ? _toggleRecording : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isRecording ? Color(0xFF64B5F6) : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.pause,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              // Stop Button
              GestureDetector(
                onTap: (_isRecording || _text.isNotEmpty) ? () {
                  if (_isRecording) {
                    _toggleRecording();
                  }
                  _resetTimer();
                  setState(() {
                    _text = '';
                    _confidence = 1.0;
                  });
                } : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (_isRecording || _text.isNotEmpty) ? Color(0xFF64B5F6) : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.stop,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Recording Status Indicator
          if (_text.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Recording completed! Ready for analysis.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: Icon(Icons.refresh),
                  label: Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Color(0xFF2563eb)),
                    foregroundColor: Color(0xFF2563eb),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _text.isNotEmpty ? () {
                    // Navigate to feedback page with recording data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(
                          spokenText: _text,
                          originalPassage: _todayPassage,
                          confidence: _confidence,
                          readingTimeSeconds: _seconds,
                        ),
                      ),
                    );
                  } : null,
                  icon: Icon(Icons.check),
                  label: Text('Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10b981),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
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