import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
        description: 'Hitta blixtsnabbt till det du vill använda',
      ),
      _buildOnboardingPage(
        context,
        image: 'assets/images/milrinone.png',
        imageHeight: MediaQuery.of(context).size.height * 0.6, // Make it responsive
        title: 'Översikt',
        description: 'Se allt nödvändigt på en sida',
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
        imageHeight: MediaQuery.of(context).size.height * 0.50,
        title: 'Omvandla doser snabbt och enkelt',
        description:
            'Omvandla doser direkt i rutan. Välj vikt, läkemedelsspädning, tidsenhet eller en kombination',
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(216, 214, 202, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 6),
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
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
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
              const SizedBox(height: 8),
              (_currentPage == pages.length - 1)
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                        
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Color.fromARGB(255, 236, 159, 117),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Vi kör!', style: TextStyle(fontSize: 18)),
                      ),
                  )
                  : (kIsWeb
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(), // Placeholder for alignment
                            IconButton(
                              icon: Icon(Icons.arrow_forward_rounded),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              iconSize: 36,
                            ),
                          ],
                        )
                      : const SizedBox()),
             
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
            Image.asset(image, height: imageHeight, fit: imageFit),
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