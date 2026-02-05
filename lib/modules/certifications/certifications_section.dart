import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class Certificate {
  final String title;
  final String organization;
  final String date;
  final String imagePath;

  const Certificate({
    required this.title,
    required this.organization,
    required this.date,
    required this.imagePath,
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
  late PageController _pageController;
  int _currentPage = 0;
  bool _isAnimating = false;

  final List<Certificate> certificates = const [
    Certificate(
      title: 'AWS Cloud Practitioner',
      organization: 'Amazon Web Services',
      date: '2024',
      imagePath: 'assets/certi/Aws_cloud_practitoner.jpg',
    ),
    Certificate(
      title: 'Certified Ethical Hacker',
      organization: 'EC-Council',
      date: '2024',
      imagePath: 'assets/certi/CEH.jpg',
    ),
    Certificate(
      title: 'Microsoft Certified Professional',
      organization: 'Microsoft',
      date: '2023',
      imagePath: 'assets/certi/MCP.jpg',
    ),
    Certificate(
      title: 'Meta Hacker Cup',
      organization: 'Meta',
      date: '2023',
      imagePath: 'assets/certi/Meta_Hacker_cup.jpg',
    ),
    Certificate(
      title: 'OCI Cloud Certification',
      organization: 'Oracle',
      date: '2024',
      imagePath: 'assets/certi/OCI_cloud.jpg',
    ),
    Certificate(
      title: 'Professional Certificate',
      organization: 'Industry Certification',
      date: '2024',
      imagePath: 'assets/certi/Screenshot (14).png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleScroll(PointerScrollEvent event) {
    if (_isAnimating) return;

    if (event.scrollDelta.dy > 0 && _currentPage < certificates.length - 1) {
      _animateToPage(_currentPage + 1);
    } else if (event.scrollDelta.dy < 0 && _currentPage > 0) {
      _animateToPage(_currentPage - 1);
    }
  }

  void _animateToPage(int page) {
    setState(() => _isAnimating = true);
    _pageController
        .animateToPage(
      page,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    )
        .then((_) {
      setState(() {
        _currentPage = page;
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SizedBox(
      width: double.infinity,
      height: screenHeight(context) * 1.2,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              image: const DecorationImage(
                image: AssetImage('assets/images/workBg.png'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, isMobile),
          ),

          // Certificate PageView with scroll jacking
          Positioned(
            top: isMobile ? 120 : 150,
            left: 0,
            right: 0,
            bottom: 80,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _handleScroll(event);
                }
              },
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: certificates.length,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  return _buildCertificateCard(context, certificates[index], index, isMobile);
                },
              ),
            ),
          ),

          // Navigation Dots
          Positioned(
            right: isMobile ? 16 : 40,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildNavigationDots(isMobile),
            ),
          ),

          // Bottom Counter
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildCounter(context, isMobile),
          ),

          // Navigation Arrows
          if (!isMobile) ...[
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: Center(
                child: _buildNavigationArrows(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding(context),
        vertical: isMobile ? 30 : 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.accent,
                AppColors.moonGlow,
                AppColors.accent,
              ],
            ).createShader(bounds),
            child: Text(
              'CERTIFICATIONS',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: isMobile ? 4 : 8,
                    fontSize: isMobile ? 28 : 48,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Credentials that validate expertise and commitment to excellence.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontSize: isMobile ? 14 : 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(
      BuildContext context, Certificate certificate, int index, bool isMobile) {
    final isActive = index == _currentPage;

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page ?? 0) - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }

        return Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: isActive ? 1.0 : 0.3,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 400),
              scale: isActive ? 1.0 : 0.85,
              curve: Curves.easeOutCubic,
              child: Container(
                width: isMobile ? screenWidth(context) * 0.85 : screenWidth(context) * 0.6,
                height: isMobile ? screenHeight(context) * 0.6 : screenHeight(context) * 0.65,
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.glassSurface.withOpacity(0.2),
                      AppColors.glassSurface.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: isActive
                        ? AppColors.accent.withOpacity(0.5)
                        : AppColors.textPrimary.withOpacity(0.1),
                    width: isActive ? 2 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Certificate Image
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              certificate.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.glassSurface.withOpacity(0.1),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.textPrimary,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Gradient Overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: isMobile ? 100 : 120,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.bgDark.withOpacity(0.9),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Certificate Info
                      Positioned(
                        bottom: isMobile ? 16 : 24,
                        left: isMobile ? 16 : 24,
                        right: isMobile ? 16 : 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              certificate.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isMobile ? 18 : 24,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  certificate.organization,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    certificate.date,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
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
      },
    );
  }

  Widget _buildNavigationDots(bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(certificates.length, (index) {
        final isActive = index == _currentPage;
        return GestureDetector(
          onTap: () => _animateToPage(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 6),
            width: isActive ? 12 : 8,
            height: isActive ? 12 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.accent : AppColors.textPrimary.withOpacity(0.3),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCounter(BuildContext context, bool isMobile) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_currentPage + 1}'.padLeft(2, '0'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 24 : 32,
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: isMobile ? 40 : 60,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.textPrimary.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          Text(
            '${certificates.length}'.padLeft(2, '0'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 24 : 32,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationArrows() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _currentPage > 0 ? () => _animateToPage(_currentPage - 1) : null,
          icon: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: _currentPage > 0
                ? AppColors.textPrimary
                : AppColors.textPrimary.withOpacity(0.3),
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: _currentPage < certificates.length - 1
              ? () => _animateToPage(_currentPage + 1)
              : null,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _currentPage < certificates.length - 1
                ? AppColors.textPrimary
                : AppColors.textPrimary.withOpacity(0.3),
            size: 32,
          ),
        ),
      ],
    );
  }
}
