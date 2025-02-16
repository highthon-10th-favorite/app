import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:highthon_10th_favorite/api/UserApi.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  final User? user = FirebaseAuth.instance.currentUser;

  final List<Profile> profiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    UserApi().getPictures(user!.uid).then((value) {
      Future.wait((value['match_candidates'] as List).map((element) {
        return UserApi().getUserById(element['uid']).then((userData) {
          if (mounted) {
            setState(() {
              profiles.add(Profile(
                name: userData['data']['nickname'],
                age: userData['data']['age'],
                image: userData['data']['profileImageUrl'],
                celebrities:
                    List<String>.from(element['common_lookalikes_images']),
              ));
            });
          }
        });
      }).toList())
          .then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
            print("요청 성공");
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = TextColors.of(context);
    final accent = AccentColors.of(context);
    return Scaffold(
      backgroundColor: text.white,
      appBar: AppBar(
        backgroundColor: text.white,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '자신의 이상형을\n',
                style: TextStyle(color: text.primary),
              ),
              TextSpan(
                text: '오른쪽',
                style: TextStyle(color: accent.primary),
              ),
              TextSpan(
                text: '으로 넘겨주세요!',
                style: TextStyle(color: text.primary),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : profiles.length >= 2
                      ? CardSwiper(
                          controller: controller,
                          cardsCount: profiles.length,
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                            right: true,
                            left: true,
                          ),
                          backCardOffset: const Offset(40, 40),
                          numberOfCardsDisplayed: 2,
                          padding: const EdgeInsets.all(20.0),
                          cardBuilder: (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) =>
                              ProfileCard(profile: profiles[index]),
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 10),
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/arrow_dark.png'
                  : 'assets/images/arrow.png',
            ),
            const SizedBox(height: 20),
            _buildReactionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButtons() {
    final text = TextColors.of(context);
    final accent = AccentColors.of(context);
    return SizedBox(
      width: 240,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '별로예요!',
            style: TextStyle(
              color: text.primary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 40),
          Text(
            '마음에 들어요!',
            style: TextStyle(
              color: accent.primary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right) {
      debugPrint('${profiles[previousIndex].name}님이 마음에 들어요!');
    } else if (direction == CardSwiperDirection.left) {
      debugPrint('${profiles[previousIndex].name}님이 별로예요!');
    }
    return true;
  }

  bool _onUndo(
      int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint('${profiles[currentIndex].name} 카드가 되돌려졌습니다.');
    return true;
  }
}

class Profile {
  final String name;
  final int age;
  final String image;
  final List<String> celebrities;

  Profile({
    required this.name,
    required this.age,
    required this.image,
    required this.celebrities,
  });
}

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: 330,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              profile.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 330,
          height: 100,
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0.7)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${profile.name} / ${profile.age}\n',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '닮은 연예인 : ${profile.celebrities.join(", ")}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
