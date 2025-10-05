import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final String? spokenText;
  final String? originalPassage;
  final double? confidence;
  final int? readingTimeSeconds;

  const FeedbackPage({
    Key? key,
    this.spokenText,
    this.originalPassage,
    this.confidence,
    this.readingTimeSeconds,
  }) : super(key: key);

  // Calculate accuracy by comparing spoken text with original passage
  double _calculateAccuracy() {
    if (spokenText == null || originalPassage == null) return 0.85;
    
    final spokenWords = spokenText!.toLowerCase().split(' ');
    final originalWords = originalPassage!.toLowerCase().split(' ');
    
    int matchCount = 0;
    int totalWords = originalWords.length;
    
    for (int i = 0; i < spokenWords.length && i < originalWords.length; i++) {
      if (spokenWords[i].replaceAll(RegExp(r'[^\w]'), '') == 
          originalWords[i].replaceAll(RegExp(r'[^\w]'), '')) {
        matchCount++;
      }
    }
    
    return totalWords > 0 ? matchCount / totalWords : 0.0;
  }

  String _getAccuracyFeedback(double accuracy) {
    if (accuracy >= 0.9) return 'Excellent accuracy!';
    if (accuracy >= 0.8) return 'Very good accuracy';
    if (accuracy >= 0.7) return 'Good accuracy, keep practicing';
    if (accuracy >= 0.6) return 'Fair accuracy, room for improvement';
    return 'Keep practicing to improve accuracy';
  }

  String _generateTips(double overall, double accuracy, double pronunciation) {
    List<String> tips = [];
    
    if (accuracy < 0.8) {
      tips.add('• Try to speak more clearly and match the passage text');
    }
    if (pronunciation < 0.8) {
      tips.add('• Focus on pronouncing each word distinctly');
    }
    if (overall < 0.7) {
      tips.add('• Take your time and read slowly for better accuracy');
    }
    if (readingTimeSeconds != null && readingTimeSeconds! < 20) {
      tips.add('• Try reading a bit slower for better comprehension');
    }
    
    // Default positive tips if performance is good
    if (tips.isEmpty) {
      tips.addAll([
        '• Keep up the excellent work!',
        '• Try reading different types of texts to expand your skills',
        '• Practice daily for continued improvement',
      ]);
    }
    
    return tips.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    // If no recording data, show empty state
    if (spokenText == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'No Reading Analysis Yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Complete a reading session to see your performance analysis here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // Pop back to previous screen or show message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Go to the Read tab to start a reading session'),
                        backgroundColor: Color(0xFF2563eb),
                      ),
                    );
                  },
                  icon: Icon(Icons.mic),
                  label: Text('Start Reading'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563eb),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final accuracy = _calculateAccuracy();
    final overallScore = ((accuracy + (confidence ?? 0.85)) / 2);
    final pronunciationScore = confidence ?? 0.85;
    final pacingScore = readingTimeSeconds != null 
        ? (readingTimeSeconds! >= 30 && readingTimeSeconds! <= 90 ? 0.9 : 0.7)
        : 0.82;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Reading Complete!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Great job! Here\'s your performance analysis',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Text Comparison (if data available)
            if (spokenText != null && originalPassage != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Comparison',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Original Passage
                    Text(
                      'Original Passage:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        originalPassage!,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // What You Said
                    Text(
                      'What You Said:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Text(
                        spokenText!,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Accuracy Score
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: Colors.orange[600], size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Text Accuracy: ${(accuracy * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getAccuracyFeedback(accuracy),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            // Overall Score
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Overall Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: overallScore,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${(overallScore * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          Text(
                            overallScore >= 0.9 ? 'Excellent' : 
                            overallScore >= 0.8 ? 'Very Good' :
                            overallScore >= 0.7 ? 'Good' : 'Keep Practicing',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Performance Metrics
            Text(
              'Performance Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),

            // Pronunciation
            _buildMetricCard(
              'Pronunciation',
              pronunciationScore,
              Icons.record_voice_over,
              Color(0xFF2196F3),
              pronunciationScore >= 0.9 ? 'Excellent pronunciation!' :
              pronunciationScore >= 0.8 ? 'Very clear pronunciation' :
              'Good pronunciation, keep practicing',
            ),
            
            SizedBox(height: 12),

            // Pacing
            _buildMetricCard(
              'Pacing',
              pacingScore,
              Icons.speed,
              Color(0xFFFF9800),
              readingTimeSeconds != null 
                ? 'Reading time: ${readingTimeSeconds}s'
                : 'Good reading speed and rhythm',
            ),

            SizedBox(height: 12),

            // Intonation  
            _buildMetricCard(
              'Intonation',
              accuracy, // Use accuracy as a proxy for intonation
              Icons.trending_up,
              Color(0xFF9C27B0),
              accuracy >= 0.9 ? 'Excellent expression and tone' :
              accuracy >= 0.8 ? 'Good tone variation' :
              'Practice varying your tone',
            ),

            SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate back or to reading practice
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Practice Again'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFF4CAF50)),
                      foregroundColor: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share results or continue
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Tips Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tips for Improvement',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    _generateTips(overallScore, accuracy, pronunciationScore),
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, double score, IconData icon, Color color, String feedback) {
    int percentage = (score * 100).round();
    
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: score,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                SizedBox(height: 6),
                Text(
                  feedback,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}