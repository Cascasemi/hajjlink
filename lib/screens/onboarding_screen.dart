import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to sign up screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F4C75), // Deep blue
              Color(0xFF3282B8), // Medium blue
              Color(0xFF0F3460), // Dark blue
              Color(0xFF16213E), // Navy blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with skip button
              _buildHeader(),
              
              // Progress bar
              _buildProgressBar(),
              
              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _fadeController.reset();
                    _slideController.reset();
                    _fadeController.forward();
                    _slideController.forward();
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(),
                  ],
                ),
              ),
              
              // Bottom navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'HajjLink',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Skip button
          TextButton(
            onPressed: _skipToEnd,
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index <= _currentPage
                    ? const Color(0xFFFFD700)
                    : Colors.white.withOpacity(0.3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPage1() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Islamic geometric decoration
              Container(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: IslamicStarPainter(const Color(0xFFFFD700)),
                  child: Center(
                    child: Icon(
                      Icons.connect_without_contact,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                'Smart Connection',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Connect with fellow pilgrims through smart wristbands and RFID technology. Never lose your way or your group again.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Arabic blessing
              Text(
                '• اللَّهُمَّ بَارِكْ لَنَا •',
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Blockchain illustration
              Container(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: BlockchainPainter(const Color(0xFFFFD700)),
                  child: Center(
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                'Secure Payments',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Experience cashless transactions with blockchain-powered digital wallet. Safe, transparent, and instant payments during your pilgrimage.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Arabic blessing
              Text(
                '• بَارَكَ اللَّهُ فِيكُم •',
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AI guidance illustration
              Container(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: AIGuidancePainter(const Color(0xFFFFD700)),
                  child: Center(
                    child: Icon(
                      Icons.psychology,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                'AI Guidance',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Get personalized AI-powered guidance for your spiritual journey. Real-time navigation, ritual instructions, and emergency assistance.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Arabic blessing
              Text(
                '• تَقَبَّلَ اللَّهُ مِنَّا وَمِنكُم •',
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentPage > 0)
            GestureDetector(
              onTap: _previousPage,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            )
          else
            const SizedBox(width: 50),
          
          // Page indicators
          Row(
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.3),
                ),
              );
            }),
          ),
          
          // Next/Get Started button
          GestureDetector(
            onTap: _nextPage,
            child: Container(
              width: _currentPage == 2 ? 120 : 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_currentPage == 2 ? 25 : 25),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: _currentPage == 2
                    ? Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for Islamic star pattern
class IslamicStarPainter extends CustomPainter {
  final Color color;
  
  IslamicStarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw 8-pointed Islamic star
    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi) / 8;
      final currentRadius = i % 2 == 0 ? radius : radius * 0.6;
      final x = center.dx + math.cos(angle) * currentRadius;
      final y = center.dy + math.sin(angle) * currentRadius;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Draw inner circle
    canvas.drawCircle(center, radius * 0.4, paint);
    
    // Draw decorative dots
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final x = center.dx + math.cos(angle) * (radius * 0.8);
      final y = center.dy + math.sin(angle) * (radius * 0.8);
      
      canvas.drawCircle(
        Offset(x, y), 
        3, 
        Paint()..color = color.withOpacity(0.6)
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for blockchain illustration
class BlockchainPainter extends CustomPainter {
  final Color color;
  
  BlockchainPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    // Draw connected hexagons (blockchain blocks)
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      _drawHexagon(canvas, Offset(x, y), 25, paint);
      
      // Draw connections
      if (i < 5) {
        final nextAngle = ((i + 1) * math.pi) / 3;
        final nextX = center.dx + math.cos(nextAngle) * radius;
        final nextY = center.dy + math.sin(nextAngle) * radius;
        
        canvas.drawLine(
          Offset(x, y), 
          Offset(nextX, nextY), 
          Paint()..color = color.withOpacity(0.2)..strokeWidth = 1
        );
      }
    }
    
    // Connect last to first
    final firstX = center.dx + math.cos(0) * radius;
    final firstY = center.dy + math.sin(0) * radius;
    final lastX = center.dx + math.cos((5 * math.pi) / 3) * radius;
    final lastY = center.dy + math.sin((5 * math.pi) / 3) * radius;
    
    canvas.drawLine(
      Offset(lastX, lastY), 
      Offset(firstX, firstY), 
      Paint()..color = color.withOpacity(0.2)..strokeWidth = 1
    );

    // Center hexagon
    _drawHexagon(canvas, center, 30, paint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for AI guidance illustration
class AIGuidancePainter extends CustomPainter {
  final Color color;
  
  AIGuidancePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    // Draw neural network pattern
    for (int layer = 0; layer < 3; layer++) {
      final layerRadius = radius - (layer * 40);
      final nodesInLayer = 6 - layer;
      
      for (int node = 0; node < nodesInLayer; node++) {
        final angle = (node * 2 * math.pi) / nodesInLayer;
        final x = center.dx + math.cos(angle) * layerRadius;
        final y = center.dy + math.sin(angle) * layerRadius;
        
        // Draw node
        canvas.drawCircle(
          Offset(x, y), 
          8, 
          Paint()..color = color.withOpacity(0.4)..style = PaintingStyle.fill
        );
        
        // Draw connections to inner layer
        if (layer < 2) {
          final innerLayerRadius = layerRadius - 40;
          final innerNodes = 6 - (layer + 1);
          
          for (int innerNode = 0; innerNode < innerNodes; innerNode++) {
            final innerAngle = (innerNode * 2 * math.pi) / innerNodes;
            final innerX = center.dx + math.cos(innerAngle) * innerLayerRadius;
            final innerY = center.dy + math.sin(innerAngle) * innerLayerRadius;
            
            canvas.drawLine(
              Offset(x, y),
              Offset(innerX, innerY),
              Paint()..color = color.withOpacity(0.2)..strokeWidth = 1,
            );
          }
        }
      }
    }

    // Draw outer circle
    canvas.drawCircle(center, radius + 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
