import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': '大量の資料\n読むだけで疲れる…',
      'description': '・会社のマニュアル、大学の授業資料など…\n・読むのに時間がかかるし、わかりにくいこと\n　も多い。',
      'image': 'assets/lottie/search.json',
    },
    {
      'title': '先輩に毎回聞くのは\n気が引ける…',
      'description': '・マニュアルに書いてあることを聞くのは申し\n　訳ない…\n・忙しい先輩の時間を奪うのも気になる…',
      'image': 'assets/lottie/difficult.json',
    },
    {
      'title': 'AIに読み込ませよ！',
      'description': '・マニュアルに書いてあることを読み込み、聞\n　きたいことをチャットで聞くことで時間短縮',
      'image': 'assets/lottie/ai_animation.json',
    },
    {
      'title': 'もう、悩まなくていい。',
      'description':
          '・ドキュメントをアップロードすれば、聞きた\n　いことをチャットで聞くだけ！\n・DocChatが内容を読み取ってすぐに答えてく\n　れます。',
      'image': 'assets/lottie/happy.json',
    },
  ];

  void _nextPage() async {
    final goroute = GoRouter.of(context);
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await ref.read(localStorageProvider).setFirstLaunchComplete();
      goroute.goNamed(RouteNames.signin);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white, // 背景を白に統一
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                final item = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(item['image']!, height: 300),
                      const SizedBox(height: 32),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        item['description']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _nextPage,
                        child: Text(
                          style: TextStyle(
                            color: Color.fromARGB(255, 42, 204, 166),
                          ),
                          _currentPage == onboardingData.length - 1
                              ? 'はじめる'
                              : 'Next',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // 戻るボタン（左上に表示）
            if (_currentPage > 0)
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _prevPage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
