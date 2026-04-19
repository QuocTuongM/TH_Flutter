import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A0A1A), Color(0xFF0D1B3E), Color(0xFF0A0A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Decorative circles background
          Positioned(top: -60, right: -60,
            child: _glowCircle(200, const Color(0xFF1A3AFF).withOpacity(0.15)),
          ),
          Positioned(bottom: 40, left: -80,
            child: _glowCircle(240, const Color(0xFF00D4FF).withOpacity(0.10)),
          ),
          Positioned(top: 200, left: -40,
            child: _glowCircle(120, const Color(0xFF7B2FFF).withOpacity(0.12)),
          ),

          // Main content
          FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // Floating Avatar
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, math.sin(_floatController.value * math.pi) * 8),
                        child: child,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 148,
                            height: 148,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const SweepGradient(
                                colors: [
                                  Color(0xFF00D4FF),
                                  Color(0xFF7B2FFF),
                                  Color(0xFF1A3AFF),
                                  Color(0xFF00D4FF),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0D1B3E),
                            ),
                          ),
                          // Avatar
                          Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF1A3AFF), Color(0xFF7B2FFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 72,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Tên
                    const Text(
                      'Nguyễn Quốc Tường',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // MSSV badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A3AFF), Color(0xFF7B2FFF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A3AFF).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'MSSV: 2224802010908',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Phát triển ứng dụng đa nền tảng',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A3AFF).withOpacity(0.08),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _infoItem(
                            icon: Icons.badge_rounded,
                            label: 'Mã số sinh viên',
                            value: '2224802010908',
                            color: const Color(0xFF00D4FF),
                          ),
                          _divider(),
                          _infoItem(
                            icon: Icons.email_rounded,
                            label: 'Email',
                            value: '2224802010908@student.tdmu.edu.vn',
                            color: const Color(0xFF7B2FFF),
                          ),
                          _divider(),
                          _infoItem(
                            icon: Icons.school_rounded,
                            label: 'Trường',
                            value: 'Đại học Thủ Dầu Một',
                            color: const Color(0xFF1A3AFF),
                          ),
                          _divider(),
                          _infoItem(
                            icon: Icons.devices_rounded,
                            label: 'Môn học',
                            value: 'Cross-Platform Development',
                            color: const Color(0xFF00D4FF),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Bottom tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00D4FF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Flutter Developer in Progress',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7B2FFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}