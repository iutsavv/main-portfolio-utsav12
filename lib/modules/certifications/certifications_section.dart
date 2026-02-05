import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class Certificate {
  final String title;
  final String organization;
  final String date;
  final String imagePath;
  final Color accentColor;

  const Certificate({
    required this.title,
    required this.organization,
    required this.date,
    required this.imagePath,
    this.accentColor = const Color(0xFF6366f1),
  });
}

class CertificationsSection extends StatefulWidget {
  const CertificationsSection({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  State<CertificationsSection> createState() => _CertificationsSectionState();
}

class _CertificationsSectionState extends State<CertificationsSection>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isAnimating = false;
  late AnimationController _transitionController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Certificate> certificates = const [
    Certificate(
      title: 'AWS Cloud Practitioner',
      organization: 'Amazon Web Services',
      date: '2024',
      imagePath: 'assets/certi/Aws_cloud_practitoner.jpg',
      accentColor: Color(0xFFFF9900),
    ),
    Certificate(
      title: 'Certified Ethical Hacker',
      organization: 'EC-Council',
      date: '2022',
      imagePath: 'assets/certi/CEH.jpg',
      accentColor: Color(0xFFe74c3c),
    ),
    Certificate(
      title: 'Model Context Protocol',
      organization: 'Anthropic',
      date: '2024',
      imagePath: 'assets/certi/MCP.jpg',
      accentColor: Color(0xFFd4a574),
    ),
    Certificate(
      title: 'Meta Hacker Cup',
      organization: 'Meta',
      date: '2024',
      imagePath: 'assets/certi/Meta_Hacker_cup.jpg',
      accentColor: Color(0xFF0668E1),
    ),
    Certificate(
      title: 'OCI Cloud Certification',
      organization: 'Oracle',
      date: '2024',
      imagePath: 'assets/certi/OCI_cloud.jpg',
      accentColor: Color(0xFFC74634),
    ),
    Certificate(
      title: 'Hackathon Winner',
      organization: 'NIT Mizoram',
      date: '2023',
      imagePath: 'assets/certi/Screenshot (14).png',
      accentColor: Color(0xFF10b981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _handleScroll(PointerScrollEvent event) {
    if (_isAnimating) return;

    if (event.scrollDelta.dy > 0 || event.scrollDelta.dx > 0) {
      _navigateTo(_currentIndex + 1);
    } else if (event.scrollDelta.dy < 0 || event.scrollDelta.dx < 0) {
      _navigateTo(_currentIndex - 1);
    }
  }

  void _navigateTo(int index) {
    if (index < 0 || index >= certificates.length || _isAnimating) return;

    setState(() => _isAnimating = true);
    _transitionController.forward(from: 0).then((_) {
      setState(() {
        _currentIndex = index;
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final currentCert = certificates[_currentIndex];

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _handleScroll(event);
        }
      },
      child: Container(
        width: double.infinity,
        height: screenHeight(context) * 1.15,
        decoration: const BoxDecoration(
          // Deep navy blue background matching the uploaded image
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0a12),
              Color(0xFF0d0d18),
              Color(0xFF08081a),
              Color(0xFF0a0a14),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated stars/particles background
            CustomPaint(
              size: Size.infinite,
              painter: _StarfieldPainter(
                starCount: 150,
                seed: 42,
              ),
            ),

            // Ambient glow from current certificate
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.3, -0.2),
                    radius: 1.5,
                    colors: [
                      currentCert.accentColor.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, isMobile),

                  // Certificate display area
                  Expanded(
                    child: Row(
                      children: [
                        // Left side - Certificate info
                        if (!isMobile)
                          Expanded(
                            flex: 4,
                            child: _buildCertificateInfo(context, currentCert, isMobile),
                          ),

                        // Right side - Certificate image showcase
                        Expanded(
                          flex: isMobile ? 1 : 6,
                          child: _buildCertificateShowcase(context, currentCert, isMobile),
                        ),
                      ],
                    ),
                  ),

                  // Bottom navigation
                  _buildBottomNavigation(context, isMobile),

                  SizedBox(height: isMobile ? 20 : 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding(context),
        vertical: isMobile ? 24 : 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'CREDENTIALS',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: isMobile ? 11 : 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xFFa5b4fc),
                  ],
                ).createShader(bounds),
                child: Text(
                  'Certifications',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: isMobile ? 32 : 52,
                        height: 1.1,
                      ),
                ),
              ),
            ],
          ),

          // Certificate count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified,
                  color: AppColors.accent,
                  size: isMobile ? 16 : 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${certificates.length} Verified',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateInfo(BuildContext context, Certificate cert, bool isMobile) {
    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        final slideValue = _isAnimating
            ? Curves.easeInOut.transform(_transitionController.value)
            : 0.0;

        return Transform.translate(
          offset: Offset(-30 * slideValue, 0),
          child: Opacity(
            opacity: 1 - (slideValue * 0.5),
            child: Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding(context),
                right: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Organization badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: cert.accentColor.withValues(alpha: 0.15),
                      border: Border.all(
                        color: cert.accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      cert.organization,
                      style: TextStyle(
                        color: cert.accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Certificate title
                  Text(
                    cert.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36,
                          height: 1.2,
                        ),
                  ),

                  const SizedBox(height: 20),

                  // Date and verification
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Issued ${cert.date}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10b981),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10b981).withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: const Color(0xFF10b981),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Progress indicator
                  Row(
                    children: [
                      Text(
                        '${_currentIndex + 1}',
                        style: TextStyle(
                          color: cert.accentColor,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '/',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        '${certificates.length}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCertificateShowcase(BuildContext context, Certificate cert, bool isMobile) {
    return AnimatedBuilder(
      animation: Listenable.merge([_transitionController, _floatAnimation]),
      builder: (context, child) {
        final slideValue = _isAnimating
            ? Curves.easeInOut.transform(_transitionController.value)
            : 0.0;

        return Transform.translate(
          offset: Offset(
            50 * slideValue,
            _floatAnimation.value,
          ),
          child: Opacity(
            opacity: 1 - (slideValue * 0.3),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 40),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect behind certificate
                    Container(
                      width: isMobile ? 280 : 450,
                      height: isMobile ? 200 : 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cert.accentColor.withValues(alpha: 0.3),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    // Certificate frame
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? 320 : 520,
                        maxHeight: isMobile ? 240 : 380,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            // Certificate image
                            Image.asset(
                              cert.imagePath,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFF1a1a2e),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: cert.accentColor.withValues(alpha: 0.5),
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      cert.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Shine effect overlay
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.1),
                                    ],
                                    stops: const [0.0, 0.3, 0.7, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Decorative accent lines
                    Positioned(
                      top: isMobile ? -10 : -20,
                      right: isMobile ? 20 : 40,
                      child: Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cert.accentColor,
                              cert.accentColor.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: isMobile ? -10 : -20,
                      left: isMobile ? 20 : 40,
                      child: Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cert.accentColor.withValues(alpha: 0),
                              cert.accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Mobile info overlay
                    if (isMobile)
                      Positioned(
                        bottom: -60,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              cert.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${cert.organization} • ${cert.date}',
                              style: TextStyle(
                                color: cert.accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prev button
          _buildNavButton(
            Icons.arrow_back_rounded,
            'PREV',
            _currentIndex > 0,
            () => _navigateTo(_currentIndex - 1),
            isMobile,
          ),

          // Certificate thumbnails
          if (!isMobile)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(certificates.length, (index) {
                final isActive = index == _currentIndex;
                final cert = certificates[index];

                return GestureDetector(
                  onTap: () => _navigateTo(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 48 : 36,
                    height: isActive ? 48 : 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? cert.accentColor
                            : Colors.white.withValues(alpha: 0.1),
                        width: isActive ? 2 : 1,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: cert.accentColor.withValues(alpha: 0.4),
                                blurRadius: 16,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        cert.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: cert.accentColor.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.image,
                            color: cert.accentColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

          // Dots for mobile
          if (isMobile)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(certificates.length, (index) {
                final isActive = index == _currentIndex;
                return GestureDetector(
                  onTap: () => _navigateTo(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? certificates[_currentIndex].accentColor
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                );
              }),
            ),

          // Next button
          _buildNavButton(
            Icons.arrow_forward_rounded,
            'NEXT',
            _currentIndex < certificates.length - 1,
            () => _navigateTo(_currentIndex + 1),
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    IconData icon,
    String label,
    bool enabled,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: isMobile ? 12 : 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: enabled
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
          ),
          gradient: enabled
              ? LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'PREV') ...[
              Icon(
                icon,
                color: enabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.2),
                size: isMobile ? 18 : 20,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: enabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.2),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ] else ...[
              if (!isMobile) ...[
                Text(
                  label,
                  style: TextStyle(
                    color: enabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.2),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                icon,
                color: enabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.2),
                size: isMobile ? 18 : 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom painter for starfield background
class _StarfieldPainter extends CustomPainter {
  final int starCount;
  final int seed;

  _StarfieldPainter({required this.starCount, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.2 + 0.3;
      final opacity = random.nextDouble() * 0.5 + 0.2;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
