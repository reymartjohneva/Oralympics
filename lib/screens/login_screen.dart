// ==================== FILE: login_screen.dart ====================
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF5B6FE8),
              Color(0xFF667eea),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  SizedBox(height: 60),
                  
                  // Logo Container
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.record_voice_over,
                        size: 70,
                        color: Color(0xFF667eea),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // App Title
                  Text(
                    'SpeakSmart',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Subtitle
                  Text(
                    'Read. Compete. Level Up.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Olympic Rings Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRing(Colors.blue),
                      _buildRing(Colors.yellow),
                      _buildRing(Colors.black),
                      _buildRing(Colors.green),
                      _buildRing(Colors.red),
                    ],
                  ),
                  
                  Spacer(),
                  
                  // Illustration Section
                  Container(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Stadium waves
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: CustomPaint(
                              painter: WavePainter(),
                            ),
                          ),
                        ),
                        // Year Badge
                        Positioned(
                          bottom: 50,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              '2025',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Trophy Icon
                        Positioned(
                          right: 40,
                          top: 20,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD700),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Login Buttons Container
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // School ID Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _navigateToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF667eea),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Color(0xFF667eea), width: 2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.badge, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  'Login with School ID',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 15),
                        
                        // Google Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _navigateToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEA4335),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata, size: 28),
                                SizedBox(width: 5),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 25),
                        
                        // Bottom Navigation Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBottomIcon(Icons.menu_book, 'Read'),
                            _buildBottomIcon(Icons.sports_esports, 'Compete'),
                            _buildBottomIcon(Icons.trending_up, 'Progress'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRing(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF667eea).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xFF667eea),
            size: 24,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Wave Effect
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Color(0xFFFFD54F).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Color(0xFFFFB74D).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.5);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.3,
      size.width * 0.5, size.height * 0.5,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.5,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.5, size.height * 0.7,
    );
    path2.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      size.width, size.height * 0.7,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}