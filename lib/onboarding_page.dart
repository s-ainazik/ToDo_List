import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/home/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Добро пожаловать!',
      description: 'Организуйте свою жизнь с Todolist - приложение для управления задачами',
      image: Icons.checklist,
    ),
    OnboardingData(
      title: 'Все задачи в одном месте',
      description: 'Добавляйте упорядочивание и управляйте задачами на день, неделю и месяц',
      image: Icons.task,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _saveOnboardingShown();
  }

  Future<void> _saveOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingShown', true);
  }

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MyHomePage(
          title: 'ToDo',
          onThemeToggle: _dummyThemeToggle,
          isDarkMode: false,
        ),
      ),
    );
  }

  void _dummyThemeToggle(bool isDark) {} 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPageContent(page);
                },
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            data.image,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 32),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Кнопка "Пропустить" (всегда видна)
          TextButton(
            onPressed: _skipOnboarding,
            child: const Text('Пропустить'),
          ),
          // Индикаторы страниц
          Row(
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.blue
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          // Кнопка "Далее" или "Начать"
          TextButton(
            onPressed: _currentPage == _pages.length - 1
                ? _finishOnboarding
                : _goToNext,
            child: Text(
              _currentPage == _pages.length - 1 ? 'Начать' : 'Далее',
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}