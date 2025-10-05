import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Alex Johnson', 'points': 2850, 'rank': 1, 'avatar': Icons.person},
    {'name': 'Sarah Wilson', 'points': 2720, 'rank': 2, 'avatar': Icons.person},
    {'name': 'Mike Chen', 'points': 2650, 'rank': 3, 'avatar': Icons.person},
    {'name': 'You', 'points': 1420, 'rank': 12, 'avatar': Icons.person, 'isCurrentUser': true},
    {'name': 'Emma Davis', 'points': 1380, 'rank': 13, 'avatar': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Top 3 podium
          Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumItem(2, _leaderboard[1], 80),
                _buildPodiumItem(1, _leaderboard[0], 100),
                _buildPodiumItem(3, _leaderboard[2], 60),
              ],
            ),
          ),
          
          SizedBox(height: 30),
          
          // Leaderboard list
          Expanded(
            child: ListView.builder(
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final user = _leaderboard[index];
                final isCurrentUser = user['isCurrentUser'] ?? false;
                
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Color(0xFF667eea).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrentUser ? Border.all(color: Color(0xFF667eea), width: 2) : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        child: Text(
                          '#${user['rank']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser ? Color(0xFF667eea) : Colors.grey[600],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF667eea).withOpacity(0.1),
                        child: Icon(user['avatar'], color: Color(0xFF667eea)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user['name'],
                          style: TextStyle(
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                            color: isCurrentUser ? Color(0xFF667eea) : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        '${user['points']} pts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(int position, Map<String, dynamic> user, double height) {
    Color podiumColor;
    switch (position) {
      case 1:
        podiumColor = Colors.amber;
        break;
      case 2:
        podiumColor = Colors.grey[400]!;
        break;
      case 3:
        podiumColor = Colors.brown[300]!;
        break;
      default:
        podiumColor = Colors.grey;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: podiumColor.withOpacity(0.2),
          child: Icon(user['avatar'], color: podiumColor),
        ),
        SizedBox(height: 5),
        Text(
          user['name'],
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Text(
          '${user['points']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        Container(
          width: 50,
          height: height,
          decoration: BoxDecoration(
            color: podiumColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '$position',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}