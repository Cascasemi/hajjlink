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
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Islamic decorative ring
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: IslamicRingPainter(),
                  ),
                ),
                
                // Middle decorative ring with crescents
                Container(
                  width: 150,
                  height: 150,
                  child: CustomPaint(
                    painter: CrescentRingPainter(),
                  ),
                ),
                
                // Inner golden ring with shadow
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                
                // Logo container
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/hajjlink-logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                // Rotating Islamic geometric overlay
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _particleController.value * 2 * math.pi,
                      child: Container(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: RotatingStarPainter(),
                        ),
                      ),
                    );
                  },
                ),
              ],
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
    return Column(
      children: [
        // Decorative line with Islamic motifs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDecorativeDivider(),
            const SizedBox(width: 20),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(width: 20),
            _buildDecorativeDivider(),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Main tagline
        Padding(
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
        ),
        
        const SizedBox(height: 10),
        
        // Arabic-inspired subtitle
        Text(
          '• رحلة مباركة •',
          style: GoogleFonts.amiri(
            fontSize: 14,
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 15),
        
        // Bottom decorative line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDecorativeDivider(),
            const SizedBox(width: 15),
            const Icon(
              Icons.star,
              color: Color(0xFFFFD700),
              size: 12,
            ),
            const SizedBox(width: 15),
            _buildDecorativeDivider(),
          ],
        ),
      ],
    );
  }

  Widget _buildDecorativeDivider() {
    return Container(
      width: 40,
      height: 1,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFFFD700),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(1),
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
          // Islamic decorative border
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIslamicCornerDecoration(),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFFFFD700).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _buildIslamicCornerDecoration(),
            ],
          ),
          
          const SizedBox(height: 15),
          
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم',
            style: GoogleFonts.amiri(
              fontSize: 16,
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Powered by Innovation & Faith',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white54,
              letterSpacing: 1,
            ),
          ),
          
          const SizedBox(height: 5),
          
          Text(
            'A Blessed Journey Awaits',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicCornerDecoration() {
    return CustomPaint(
      size: const Size(20, 20),
      painter: IslamicCornerPainter(),
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
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw multiple Islamic star patterns
    _drawIslamicStar(canvas, Offset(centerX, centerY), 120, paint);
    _drawIslamicStar(canvas, Offset(centerX - 200, centerY - 150), 80, paint);
    _drawIslamicStar(canvas, Offset(centerX + 180, centerY - 120), 70, paint);
    _drawIslamicStar(canvas, Offset(centerX - 150, centerY + 180), 90, paint);
    _drawIslamicStar(canvas, Offset(centerX + 160, centerY + 160), 60, paint);

    // Draw Arabic calligraphy-inspired curves
    _drawCalligraphicCurves(canvas, size, paint);
    
    // Draw geometric hexagonal pattern
    _drawHexagonalPattern(canvas, size, paint);
  }

  void _drawIslamicStar(Canvas canvas, Offset center, double radius, Paint paint) {
    // 8-pointed Islamic star
    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi) / 8;
      final currentRadius = i % 2 == 0 ? radius : radius * 0.5;
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

    // Inner decorative circle
    canvas.drawCircle(center, radius * 0.3, paint);
  }

  void _drawCalligraphicCurves(Canvas canvas, Size size, Paint paint) {
    final curvePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Flowing curves reminiscent of Arabic calligraphy
    final path1 = Path();
    path1.moveTo(50, size.height * 0.3);
    path1.quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.6, size.height * 0.4);
    path1.quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width - 50, size.height * 0.3);
    canvas.drawPath(path1, curvePaint);

    final path2 = Path();
    path2.moveTo(size.width - 50, size.height * 0.7);
    path2.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width * 0.4, size.height * 0.6);
    path2.quadraticBezierTo(size.width * 0.2, size.height * 0.4, 50, size.height * 0.7);
    canvas.drawPath(path2, curvePaint);
  }

  void _drawHexagonalPattern(Canvas canvas, Size size, Paint paint) {
    final hexPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Small hexagonal pattern scattered across the screen
    for (int i = 0; i < 12; i++) {
      final x = (i * 100.0) % size.width;
      final y = ((i * 137.5) % size.height);
      _drawHexagon(canvas, Offset(x, y), 25, hexPaint);
    }
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

// Custom painter for Islamic decorative ring around logo
class IslamicRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw decorative dots around the ring
    for (int i = 0; i < 32; i++) {
      final angle = (i * 2 * math.pi) / 32;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      canvas.drawCircle(
        Offset(x, y), 
        i % 4 == 0 ? 3.0 : 1.5, 
        Paint()..color = const Color(0xFFFFD700).withOpacity(0.8)
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for crescents around the logo
class CrescentRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw crescents around the logo
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      _drawCrescent(canvas, Offset(x, y), 8, angle, paint);
    }
  }

  void _drawCrescent(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final path = Path();
    path.addOval(Rect.fromCircle(center: const Offset(-2, 0), radius: size));
    path.addOval(Rect.fromCircle(center: const Offset(2, 0), radius: size * 0.8));
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for rotating stars
class RotatingStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw rotating 4-pointed stars at corners
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi) / 2;
      final x = center.dx + math.cos(angle) * 80;
      final y = center.dy + math.sin(angle) * 80;
      
      _drawFourPointedStar(canvas, Offset(x, y), 12, paint);
    }
  }

  void _drawFourPointedStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final currentRadius = i % 2 == 0 ? radius : radius * 0.4;
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
