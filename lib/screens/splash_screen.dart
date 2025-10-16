import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    _particleController.repeat();
    
    await Future.delayed(const Duration(milliseconds: 3000));
    _fadeController.forward().then((_) {
      // Navigate to home screen
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen())
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
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
              child: Stack(
                children: [
                  // Floating particles background
                  _buildParticleBackground(),
                  
                  // Islamic geometric pattern overlay
                  _buildGeometricPattern(),
                  
                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo section
                        _buildLogo(),
                        
                        const SizedBox(height: 40),
                        
                        // App name with elegant typography
                        _buildAppName(),
                        
                        const SizedBox(height: 20),
                        
                        // Tagline
                        _buildTagline(),
                        
                        const SizedBox(height: 60),
                        
                        // Loading indicator
                        _buildLoadingIndicator(),
                      ],
                    ),
                  ),
                  
                  // Bottom branding
                  _buildBottomBranding(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(_particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildGeometricPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: CustomPaint(
          painter: IslamicPatternPainter(),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: const Color(0xFFFFD700),
      child: Text(
        'HajjLink',
        style: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'Connecting Pilgrims Worldwide',
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
              letterSpacing: 1,
            ),
            speed: const Duration(milliseconds: 100),
          ),
        ],
        totalRepeatCount: 1,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 150,
      child: LinearProgressIndicator(
        backgroundColor: Colors.white.withOpacity(0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
        minHeight: 3,
      ),
    );
  }

  Widget _buildBottomBranding() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Powered by Innovation',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Blessed Journey Ahead',
            style: GoogleFonts.amiri(
              fontSize: 14,
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for floating particles
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (size.width * 0.1 + (i * 37) % size.width) + 
                (math.sin(animationValue * 2 * math.pi + i) * 20);
      final y = (size.height * 0.1 + (i * 47) % size.height) + 
                (math.cos(animationValue * 2 * math.pi + i) * 15);
      
      canvas.drawCircle(
        Offset(x, y),
        2 + math.sin(animationValue * 4 * math.pi + i) * 1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom painter for Islamic geometric patterns
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw star pattern
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final x1 = centerX + math.cos(angle) * 100;
      final y1 = centerY + math.sin(angle) * 100;
      final x2 = centerX + math.cos(angle + math.pi / 8) * 150;
      final y2 = centerY + math.sin(angle + math.pi / 8) * 150;
      
      canvas.drawLine(Offset(centerX, centerY), Offset(x1, y1), paint);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        i * 80.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
