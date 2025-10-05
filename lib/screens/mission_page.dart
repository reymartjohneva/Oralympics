import 'package:flutter/material.dart';

class MissionPage extends StatefulWidget {
  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final List<Map<String, dynamic>> _missions = [
    {
      'title': 'Daily Challenge',
      'description': 'Complete 3 pronunciation exercises',
      'progress': 2,
      'total': 3,
      'reward': 50,
      'icon': Icons.emoji_events,
      'color': Colors.orange,
      'isCompleted': false,
    },
    {
      'title': 'Weekly Goal',
      'description': 'Practice for 5 days this week',
      'progress': 3,
      'total': 5,
      'reward': 100,
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'isCompleted': false,
    },
    {
      'title': 'Speech Master',
      'description': 'Record 10 sentences perfectly',
      'progress': 7,
      'total': 10,
      'reward': 75,
      'icon': Icons.mic,
      'color': Colors.green,
      'isCompleted': false,
    },
    {
      'title': 'Vocabulary Builder',
      'description': 'Learn 20 new words',
      'progress': 20,
      'total': 20,
      'reward': 80,
      'icon': Icons.book,
      'color': Colors.purple,
      'isCompleted': true,
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
            'Missions & Challenges',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          
          // Mission list
          Expanded(
            child: ListView.builder(
              itemCount: _missions.length,
              itemBuilder: (context, index) {
                final mission = _missions[index];
                final progress = mission['progress'] / mission['total'];
                final isCompleted = mission['isCompleted'];
                
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: isCompleted 
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: mission['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              mission['icon'],
                              color: mission['color'],
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        mission['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (isCompleted)
                                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  mission['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${mission['progress']}/${mission['total']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isCompleted ? Colors.green : mission['color'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                '${mission['reward']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      if (!isCompleted) ...[
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Start mission action
                            },
                            child: Text('Continue Mission'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mission['color'],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
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
}