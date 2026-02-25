import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                  HapticFeedback.selectionClick();
                },
                children: const [
                  _OnboardingPage(
                    icon: Icons.camera_alt,
                    title: 'Scan Real-Time',
                    description: 'Use your phone\'s camera to instantly detect plant diseases using our on-device AI.',
                  ),
                  _OnboardingPage(
                    icon: Icons.photo_library,
                    title: 'Upload from Gallery',
                    description: 'Have photos saved? Upload them directly from your gallery for quick analysis.',
                  ),
                  _OnboardingPage(
                    icon: Icons.medical_services,
                    title: 'Get Local Treatments',
                    description: 'Receive biological and chemical treatment protocols tailored to your region.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Skip', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPageIndex == index
                              ? const Color(0xFF2E7D32)
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPageIndex == 2) {
                        _completeOnboarding();
                      } else {
                        HapticFeedback.lightImpact();
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentPageIndex == 2 ? 'Start' : 'Next',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 120, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
