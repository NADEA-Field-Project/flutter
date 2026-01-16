import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MenuDetailScreen extends StatefulWidget {
  final dynamic product;
  const MenuDetailScreen({super.key, required this.product});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  final ApiService _apiService = ApiService();
  int _quantity = 1;
  bool _isLoading = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    try {
      final favorites = await _apiService.getFavorites();
      if (mounted) {
        setState(() {
          _isFavorited = favorites.any((f) => f['id'] == widget.product['id']);
        });
      }
    } catch (e) {
      // Handle error or ignore if not logged in
    }
  }

  Future<void> _toggleFavorite() async {
    if (!_apiService.isLoggedIn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('즐겨찾기를 사용하려면 로그인이 필요합니다.')),
        );
      }
      return;
    }

    try {
      final result = await _apiService.toggleFavorite(widget.product['id']);
      if (mounted) {
        if (result['success'] == true) {
          setState(() {
            _isFavorited = result['isFavorited'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? '오류가 발생했습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('연동 오류: $e')),
        );
      }
    }
  }

  // Options State
  String _selectedPatty = '싱글 패티'; // Default mandatory option
  final Map<String, bool> _addedCheese = {
    '체다 치즈': false,
    '스위스 치즈': false,
  };
  final Map<String, bool> _excludedIngredients = {
    '양파 제외': false,
    '피클 제외': false,
    '토마토 제외': false,
  };

  // Prices
  final int _doublePattyPrice = 3500;
  final Map<String, int> _cheesePrices = {
    '체다 치즈': 1000,
    '스위스 치즈': 1200,
  };

  int _calculateTotalPrice(int basePrice) {
    int optionsPrice = 0;
    
    // Patty Price
    if (_selectedPatty == '더블 패티') {
      optionsPrice += _doublePattyPrice;
    }

    // Cheese Price
    _addedCheese.forEach((cheese, isAdded) {
      if (isAdded) {
        optionsPrice += _cheesePrices[cheese] ?? 0;
      }
    });

    return (basePrice + optionsPrice) * _quantity;
  }

  Future<void> _handleAddToCart() async {
    setState(() => _isLoading = true);
    
    // Collect selected options
    List<String> selectedOptions = [];
    selectedOptions.add(_selectedPatty);
    _addedCheese.forEach((key, value) {
      if (value) selectedOptions.add(key);
    });
    _excludedIngredients.forEach((key, value) {
      if (value) selectedOptions.add(key);
    });

    try {
      final result = await _apiService.addToCart(
        widget.product['id'],
        _quantity,
        {
          'options': selectedOptions, // Sending options as list
          'total_price': _calculateTotalPrice(
            widget.product['price'] is int 
                ? widget.product['price'] 
                : int.tryParse(widget.product['price'].toString()) ?? 0
          )
        }, 
      );

      if (mounted) {
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('장바구니에 담겼습니다!')),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? '담기 실패')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final int basePrice = product['price'] is int ? product['price'] : int.tryParse(product['price'].toString()) ?? 0;
    final int totalPrice = _calculateTotalPrice(basePrice);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
                const Text(
                  'Menu Detail',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.black,
                    size: 28,
                  ),
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
            // Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product['image_url'] ?? 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Text(
                        '₩$basePrice',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product['description'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            
            if (product['category_id'] == 1) ...[
              // 1. Patty Selection
              _OptionSection(
                title: '패티 선택',
                isMandatory: true,
                children: [
                  _RadioOption(
                    label: '싱글 패티', 
                    price: '+₩0', 
                    isSelected: _selectedPatty == '싱글 패티',
                    onTap: () => setState(() => _selectedPatty = '싱글 패티'),
                  ),
                  _RadioOption(
                    label: '더블 패티', 
                    price: '+₩3,500', 
                    isSelected: _selectedPatty == '더블 패티',
                    onTap: () => setState(() => _selectedPatty = '더블 패티'),
                  ),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 24, endIndent: 24),

              // 2. Cheese Add
              _OptionSection(
                title: '치즈 추가',
                isMandatory: false,
                children: [
                  _CheckOption(
                    label: '체다 치즈', 
                    price: '+₩1,000', 
                    isSelected: _addedCheese['체다 치즈']!,
                    onTap: () => setState(() => _addedCheese['체다 치즈'] = !_addedCheese['체다 치즈']!),
                  ),
                  _CheckOption(
                    label: '스위스 치즈', 
                    price: '+₩1,200', 
                    isSelected: _addedCheese['스위스 치즈']!,
                    onTap: () => setState(() => _addedCheese['스위스 치즈'] = !_addedCheese['스위스 치즈']!),
                  ),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 24, endIndent: 24),

              // 3. Exclude Ingredients
              _OptionSection(
                title: '재료 제외',
                isMandatory: false,
                children: [
                  _CheckOption(
                    label: '양파 제외', 
                    price: '+₩0', 
                    isSelected: _excludedIngredients['양파 제외']!,
                    onTap: () => setState(() => _excludedIngredients['양파 제외'] = !_excludedIngredients['양파 제외']!),
                  ),
                  _CheckOption(
                    label: '피클 제외', 
                    price: '+₩0', 
                    isSelected: _excludedIngredients['피클 제외']!,
                    onTap: () => setState(() => _excludedIngredients['피클 제외'] = !_excludedIngredients['피클 제외']!),
                  ),
                   _CheckOption(
                    label: '토마토 제외', 
                    price: '+₩0', 
                    isSelected: _excludedIngredients['토마토 제외']!,
                    onTap: () => setState(() => _excludedIngredients['토마토 제외'] = !_excludedIngredients['토마토 제외']!),
                  ),
                ],
              ),
              const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            ],

            // Quantity
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수량', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _QuantityBtn(
                          icon: Icons.remove,
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        _QuantityBtn(
                          icon: Icons.add,
                          onTap: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('장바구니에 담기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text('₩$totalPrice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  ],
                ),
        ),
      ),
    );
  }
}

class _OptionSection extends StatelessWidget {
  final String title;
  final bool isMandatory;
  final List<Widget> children;

  const _OptionSection({
    required this.title,
    required this.isMandatory,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isMandatory ? '필수' : '선택',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label, 
    required this.price, 
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey[300]!,
                      width: isSelected ? 6 : 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckOption extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _CheckOption({
    required this.label, 
    required this.price, 
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.transparent : Colors.transparent, // Using border for unchecked
                    shape: BoxShape.circle, // Rounded like reference
                    border: Border.all(color: isSelected ? Colors.black : Colors.grey[300]!, width: 2),
                  ),
                  child: isSelected 
                    ? const Center(child: Icon(Icons.check, size: 14, color: Colors.black)) 
                    : null,
                ),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey[400], // Grey if not added/zero
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ]),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
