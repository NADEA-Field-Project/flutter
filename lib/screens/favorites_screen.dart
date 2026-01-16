import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'menu_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  
  List<dynamic> _myFavorites = [];
  List<dynamic> _trending = [];
  bool _isLoading = true;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _fetchCartCount();
  }

  Future<void> _fetchCartCount() async {
    try {
      final count = await _apiService.getCartCount();
      if (mounted) {
        setState(() => _cartCount = count);
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _handleAddToCart(int productId, String productName) async {
    try {
      final result = await _apiService.addToCart(productId, 1, {});
      if (mounted) {
        if (result['success'] == true) {
          _fetchCartCount();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$productName added to cart!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Add to cart failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _apiService.getFavorites();
      final trending = await _apiService.getTrendingFavorites();
      setState(() {
        _myFavorites = favorites;
        _trending = trending;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(int productId) async {
    try {
      final result = await _apiService.toggleFavorite(productId);
      if (result['success'] == true) {
        _loadData(); // Reload to sync counts and state
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling favorite: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('즐겨찾기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh, size: 24)),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: 'My Favorites'),
            Tab(text: 'Global Trending'),
          ],
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyFavoritesTab(),
                _buildGlobalTrendingTab(),
              ],
            ),
    );
  }

  Widget _buildMyFavoritesTab() {
    if (_myFavorites.isEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${_myFavorites.length} items', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _myFavorites.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = _myFavorites[index];
                  return SizedBox(
                    width: 180,
                    child: _buildFavoriteCard(item),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildGlobalTrendingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalTrendingTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Most Liked Menus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Top ${_trending.length}', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _trending.length,
              itemBuilder: (context, index) {
                final item = _trending[index];
                return _buildTrendingItem(item, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalTrendingSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Global Trending', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('Live Updates', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _trending.length > 2 ? 2 : _trending.length, // Show top 2 in main list
          itemBuilder: (context, index) {
            final item = _trending[index];
            return _buildTrendingItem(item, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
              child: Icon(Icons.favorite_border, size: 60, color: Colors.grey[300]),
            ),
            const SizedBox(height: 24),
            const Text(
              '아직 즐겨찾기한 메뉴가 없어요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '주문을 하러 가볼까요? 나만의 최애 메뉴를\n즐겨찾기에 담아보세요.',
              style: TextStyle(fontSize: 15, color: Colors.grey[500], height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _loadData(), // Refresh button
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('새로고침', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(dynamic item) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailScreen(product: item),
          ),
        );
        _loadData(); // Sync state when returning
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(item['image_url'] ?? 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'), 
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(item['id']),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, size: 16, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₩${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GestureDetector(
              onTap: () => _handleAddToCart(item['id'], item['name']),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(dynamic item, int rank) {
    final count = item['favorite_count'] ?? 0;
    String countStr = count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}k' : count.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(item['image_url'] ?? 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5'), 
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    rank == 1 ? '1st' : rank == 2 ? '2nd' : rank == 3 ? '3rd' : '${rank}th', 
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 12, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('$countStr saves', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _handleAddToCart(item['id'], item['name']),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
              child: const Icon(Icons.add, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
