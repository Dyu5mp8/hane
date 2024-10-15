import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
           _buildOnboardingPage(
        context,
        image: 'assets/images/welcome.png',
        imageFit: BoxFit.contain,
        imageHeight: MediaQuery.of(context).size.height * 0.5, // Make it responsive
        title: 'Välkommen!',
        description: 'Hitta snabbt till det du behöver samlat på en plats. ',
      ),
      _buildOnboardingPage(
        context,
        image: 'assets/images/milrinone.png',
        imageHeight: MediaQuery.of(context).size.height * 0.55, // Make it responsive
        title: 'Översikt',
        description: 'Se det nödvändiga på en sida.',
      ),
      _buildOnboardingPage(
        context,
        image: 'assets/images/milrinone_dosage_snippet.png',
        imageHeight: MediaQuery.of(context).size.height * 0.1, // Adjust for smaller images
        title: 'Doseringsrutan',
        description: 'Välj indikation och se doseringsförslag.',
      ),
      _buildOnboardingPage(
        context,
        image: 'assets/images/milrinone_composite.png',
        imageHeight: MediaQuery.of(context).size.height * 0.45,
        title: 'Omvandla doser snabbt och enkelt',
        description:
            'Omvandla doser direkt i rutan. Välj vikt, läkemedelsspädning, tidsenhet eller en kombination av de alla.',
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(216, 214, 202, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: WormEffect(
                  spacing: 8.0,
                  dotWidth: 12.0,
                  dotHeight: 12.0,
                  paintStyle: PaintingStyle.fill,
                  activeDotColor: Colors.blueAccent,
                  dotColor: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _currentPage == pages.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48), // Full-width button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Vi kör!'),
                      )
                    : TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48), // Full-width button
                        ),
                        child: const Text('Nästa'),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context, {
    required String image,
    required String title,
    required String description,
    BoxFit imageFit = BoxFit.cover,
    double imageHeight = 300,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              image,
              height: imageHeight,
              fit: imageFit
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 36, 36, 36),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}