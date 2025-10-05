import 'package:flutter/material.dart';

class MiniGamesTab extends StatefulWidget {
  @override
  _MiniGamesTabState createState() => _MiniGamesTabState();
}

class _MiniGamesTabState extends State<MiniGamesTab> {
  
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
