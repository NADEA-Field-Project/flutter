import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('과거 주문 리스트'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const _MonthHeader(title: '2023년 10월'),
          const _OrderCard(
            restaurant: '버거킹 강남점',
            status: '배달 완료',
            date: '10월 24일',
            price: '18,500원',
            menu: '와퍼 세트, 치즈스틱 외 2개',
            logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuATowsnPfwIrjjYJKMZeiM4-yGAZuW-ptrp_1QzCxrRsDzS9Ko0Q8AtBHh0RewcAqzsINTU1ZT6eSln5x9KjA2KypkwAuwUWuUpJp4TYlsiEiwDv5lVmbqP3XosKx25wDxYwafPqQ0Z5eGmrS4r5xin06qd0-x-SGa6uFGKWKFSGo9mNMG8f0tvDKFskcdUV1h7mTV9jLibVYiZlEKZVV3_UCctBC6sie7tRcOOanrv0NlBeTdU4BsJKwRc6GvEDWgIDvnnvFTeAfA',
          ),
          const _OrderCard(
            restaurant: '스타벅스 역삼점',
            status: '픽업 완료',
            date: '10월 20일',
            price: '12,300원',
            menu: '아이스 아메리카노, 치즈 케이크',
            logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBJ_yft1Szb6XusgThzVymPEGIeXwjQFeX-49A1yqDzchCsIt6BNUJPCtu6YaGQd7dhST_7zP0DNOd93Fvz6SrR4Q4IZxF9TEDJ1g2kv4hFnsesgfhp8sggDWPPpWJjqfu2_HbTvLFkXkd_2PCpOYTbCeuPPGsNhwrPcZlIiUlyR1uE7ldgxrSxwzhzT5ik9Eo4Msjj1pHc0k3_rqA3qKPoVk2IpleyEqol5xuRmMnjqZVFWZjXjPuIp0JQWlXluKjCWzN_zdhMazo',
          ),
          const _OrderCard(
            restaurant: '도미노피자 서초점',
            status: '배달 완료',
            date: '10월 15일',
            price: '32,900원',
            menu: '포테이토 피자 L, 콜라 1.25L',
            logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDPkT0pTl-qphZM6aQjW1knIJtc9T-b0yxY-ycjUgWu35B2AnEVsLWAM5mg8trh0QV6QUXCv1S0lpmUU2FXqdUr5lpY1LE-jpnf4gs2ZW39ax11nRdUtVz2d6sl31jqRfVumLf9hgdP1KW1PqG-8kIyXscTtMpwnzHqjtsA0S43MWpVGwpLczwIyIcbWU49FTRyrXWwIHc8vt_B21NV-9oo5Y-UPYw37jM-yqRzX_7Tn9Gxih5_950MNTJ4bz9uelvJFJUk-qyQOvU',
          ),
          const SizedBox(height: 16),
          const _MonthHeader(title: '2023년 9월'),
          const _OrderCard(
            restaurant: '갓덴스시',
            status: '취소됨',
            date: '9월 28일',
            price: '0원',
            menu: '특선 초밥 세트 A',
            logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCUL69I6SrHkzcMTmfZLSdnoRUAlsYGSAzSbyfraOLd0tJEjRKRlBVvpwIbIxtIVHqFDtjKHr155j4R4HvkcDmkIkzWzd2s3DFDoVJqclQ-9dGuNu5ElAGiVUWHZKVVCaKHMvpZMZmrkX45JEWyPD2RCI_-aEcgADEoDbSUvhTApZO3Qw9Sgn3k8Ok9POMcPQZ0dz9w7BLqzS_jBWoOVPxVby24ydevU2zHKDoaKESmnCbG1WkkxJA1ZLrXxgSlQlIKMUnWV56Jvto',
            isCancelled: true,
          ),
          const _OrderCard(
            restaurant: '교촌치킨',
            status: '배달 완료',
            date: '9월 12일',
            price: '24,000원',
            menu: '허니콤보, 웨지감자',
            logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAIsJpz2uQsmOJ5ajyoLmgYlzBfX4IUgHnWYn_xFbD5h-agl9Rl8IzbqmUIqOPbI0kH_juMFZe1n_ImuoIZJk0Y4371wQ-xefrE46-X2c5AeTI_FdropqNIQva3WjRyN1fZRpftFfQYZm3M2GffT-_SyRcxuMrL_AI3KGXSAaEf2rEvqtLY0g-6r6KkBd8zQalIwdOYSqzCXwIY3wCGeMz9-NtHWnJ18PttoJ6KD-_bPQ9kqjvaO9xCcuY4TwmQAE-SoOKQsAc4DCY',
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final String title;
  const _MonthHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String restaurant;
  final String status;
  final String date;
  final String price;
  final String menu;
  final String logoUrl;
  final bool isCancelled;

  const _OrderCard({
    required this.restaurant,
    required this.status,
    required this.date,
    required this.price,
    required this.menu,
    required this.logoUrl,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: isCancelled ? 0.6 : 1.0,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(logoUrl),
                      fit: BoxFit.cover,
                      colorFilter: isCancelled
                          ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                          : null,
                    ),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isCancelled ? Colors.grey[400]! : Colors.black,
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCancelled ? Colors.grey[500] : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$date • $price',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        menu,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isCancelled ? null : () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(
                    color: isCancelled ? Colors.grey[300]! : Colors.black,
                  ),
                ),
                child: Text(
                  isCancelled ? '재주문 불가' : '재주문',
                  style: TextStyle(
                    color: isCancelled ? Colors.grey[400] : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
