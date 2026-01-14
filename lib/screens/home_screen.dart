import 'package:flutter/material.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '다시 오신 것을 환영합니다',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      '버거 조인트',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search, size: 28),
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuA9_KeNUf94FVEaODh0sH-6THeiVidxuZ3I8Uf1bgABRcWrsNzFO-_hfN5t3GYuF5O9xHq5B9NCIovc6CBMx46WJpbw4vZFS6Dgow9ZZ5NuYv_b0FV9EL0y3UBjuvx_1yvJ6fTNfzfmfn3b5kynwY4Rjgb9Hi6QHd4rn8yzw4YwbaoD-EpjcyFHxOcvjKMOhPMvQpYGkTxZ0qnohqcVM76bkZW7fVenfGD96YseHyl1XGy1t62PIVSVGMFkQ-E3eSNaqoAMVFT7IwM'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '한정 할인',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '스페셜 딜:\n세트 메뉴 20% 할인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '클래식 콤보를 더 저렴한 가격에 만나보세요',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Categories
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _CategoryItem(
                      icon: Icons.star, title: '전체', isActive: true),
                  _CategoryItem(icon: Icons.lunch_dining, title: '소고기'),
                  _CategoryItem(icon: Icons.egg_alt, title: '치킨'),
                  _CategoryItem(icon: Icons.eco, title: '비건'),
                  _CategoryItem(icon: Icons.fastfood, title: '사이드'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Popular Menu Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '인기 메뉴',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text(
                          '전체보기',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Popular Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: const [
                  _MenuItem(
                    title: '클래식 치즈버거',
                    subtitle: '소고기 패티, 체다 치즈, 양상추, 토마토',
                    price: '₩8,900',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDm6mIx0fs99Oua6sn3tJGFTtRKlkEO4-jr0mJQzRr5vXc3lWzMhaaS8R-6ic0tczSQX-znCUl1X4QG7HGMsYIJ-G3rXZoqAry9L5vfx-DdqZTKWFem1A4Yi8ZZJ3X27DwBUHxcv8J9fxAUSyjM7vhGEM8oVSNYZDH5WpZQnkbcVdmi70gxIQ8F-0OGIksIM6uGB87NQP2I6Y_7rkpKp3ZTHB4JoDB0uaPTCm5audamNYXgJka7QVag_g1083b7NmKkWViDYh7nL04',
                  ),
                  _MenuItem(
                    title: '스파이시 치킨 딜럭스',
                    subtitle: '바삭한 치킨, 스파이시 마요',
                    price: '₩9,500',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCGyxLIPl-zU2gr5gKY6bc0gvOwrUHKLbrH3APCTuEjAxIV4c4NxNHGdgaAvqKTNUf4bLOFmu3dsy61lzCTelB9s4owYLBZXaK4CZevOQWm29pM1WKUwRHyNwTjlEqKf2rY3xP_K-IAJ2MhLBrqMCl7aEZZKbkVeGF26dOcfHEOVl9n7E4kinkHHflLJ-IILGGDtMepQ-X3rw76-VuFCQ89pYfHjQHvSIXe0aJysJEjny5-GhLpfZ-iG12OzL1JgEWgOHqon7x1udg',
                  ),
                  _MenuItem(
                    title: '머쉬룸 스위스',
                    subtitle: '볶은 버섯, 스위스 치즈',
                    price: '₩10,200',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuD9iZ7i1tGCiVAryLZ6KtowIyzi9ybb0kSQLf3S4FOxWw8CzzGRerQEm8frt3kJR6em3Wm07PsIkQJ9oJHxhqEz06YDAoN5oudNv3jSqmsubDbjZxxONQIPOpIxyh0OHzOK4gmlSS4qDHGEIcV4ZMAh91dtl4Dj3a8aetuC4AVdBUME-TY3hRhJZJdV_38npJhQsuXq4-tnJxWj_ygTe-uaLGGReCO5t5p9zdxWcam3DE6hQv1aD_PYQZDEa1OcudUpkMtJTGNwnPs',
                  ),
                  _MenuItem(
                    title: '비건 딜라이트',
                    subtitle: '식물성 패티, 아보카도',
                    price: '₩11,000',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCSypEu_NWOEFD8wl9VLxM-pOkkkpmbaMBUc0JsE9y0LEck-r6fuZHzkHzHhX3RVqc7FcphSYC2Ez0HK97OnNkam_qQyAe1rJePsHTgAWvgP3HyJb0fA0NkNCFgySx_nYCgBqavxD9qsVax6k_J1N-u5hC1m90Cyh_5O8qP061BS4Q9vmOxoxc3G2OR5cJ20rZyqELUu38h9iC5Q8WBi3byZCb4tr6zMXO7LXiCnfucg_hLa2DzEwpnaEEhQNkWnFJwLgWVNn4QFzI',
                    isVegan: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;

  const _CategoryItem({
    required this.icon,
    required this.title,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isActive ? Colors.black : Colors.grey[200]!,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final bool isVegan;

  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.isVegan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              aspectRatio: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.grey[100]!),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: isVegan
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[100]!),
                      ),
                      child: const Text(
                        'Vegan',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
