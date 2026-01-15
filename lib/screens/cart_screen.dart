import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _cartItems = [];
  bool _isLoading = true;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getCart();
      setState(() {
        _cartItems = result['items'] ?? [];
        _totalAmount = double.tryParse(result['totalPrice']?.toString() ?? '0') ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _cartItems = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRemoveItem(int itemId) async {
    try {
      final result = await _apiService.removeFromCart(itemId);
      if (result['success'] == true) {
        _fetchCart();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove: $e')));
    }
  }

  Future<void> _handleUpdateQuantity(int itemId, int newQuantity) async {
    try {
      final result = await _apiService.updateCartItemQuantity(itemId, newQuantity);
      if (result['success'] == true) {
        _fetchCart();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '장바구니',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(child: Text('장바구니가 비어있습니다.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: _cartItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _CartItem(
                                title: item['name'] ?? '상품명',
                                options: item['options']?.toString() ?? '',
                                price: '₩${item['price']}',
                                quantity: item['quantity'] ?? 1,
                                imageUrl: item['image_url'] ?? 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
                                onRemove: () => _handleRemoveItem(item['id']),
                                onIncrease: () => _handleUpdateQuantity(item['id'], (item['quantity'] ?? 1) + 1),
                                onDecrease: () => _handleUpdateQuantity(item['id'], (item['quantity'] ?? 1) - 1),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 20, endIndent: 20),
                      const SizedBox(height: 32),
                      // Payment Summary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('결제 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _SummaryRow(label: '주문 금액', value: '₩${_totalAmount.toInt()}'),
                              const SizedBox(height: 12),
                              const _SummaryRow(label: '배달팁', value: '₩3,000'),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: _DashedLine(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '합계',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₩${(_totalAmount + 3000).toInt()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
      bottomSheet: _cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            totalAmount: _totalAmount + 3000,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      '결제하기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '위 주문 내용을 확인하였으며 결제에 동의합니다.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String title;
  final String options;
  final String price;
  final int quantity;
  final String imageUrl;
  final VoidCallback onRemove;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const _CartItem({
    required this.title,
    required this.options,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.onRemove,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            border: Border.all(color: Colors.grey[100]!),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(Icons.close, size: 20, color: Colors.grey[400]),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                options,
                style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onDecrease,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(Icons.remove, size: 16, color: quantity > 1 ? Colors.black : Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onIncrease,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.add, size: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _SummaryRow({required this.label, required this.value, this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[300])),
            );
          }),
        );
      },
    );
  }
}
