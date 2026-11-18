import 'package:flutter/material.dart';
import '../cart/detail_screen.dart';
import '../core/app_theme.dart';
import '../store/local_store.dart';

class MensCollectionScreen extends StatefulWidget {
  const MensCollectionScreen({super.key});

  @override
  State<MensCollectionScreen> createState() => _MensCollectionScreenState();
}

class _MensCollectionScreenState extends State<MensCollectionScreen> {
  String _searchQuery = '';
  String _selectedSubFilter = 'ALL';

  final List<String> _subFilters = ['ALL', 'Aquatic & Fresh', 'Oud & Woody', 'Leather & Spicy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppTheme.gold,
                      size: 20,
                    ),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "MEN'S COLLECTION",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: LocalStore.instance,
                    builder: (context, _) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16151B),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.gold.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppTheme.gold,
                              size: 20,
                            ),
                          ),
                          if (LocalStore.instance.cartCount > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.gold,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${LocalStore.instance.cartCount}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16151B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.gold.withValues(alpha: 0.25),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppTheme.gold, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                setState(() => _searchQuery = val);
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: 'Search men\'s fragrances, notes...',
                                hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Featured Category Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1C1A22),
                            Color(0xFF100F15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.gold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'GENTLEMAN\'S SIGNATURE',
                                  style: TextStyle(
                                    color: AppTheme.gold,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Bold, Intense &\nTimeless Masculinity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'serif',
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFF221E18),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&w=600&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.local_florist_rounded,
                                    color: AppTheme.gold,
                                    size: 32,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sub-filters Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _subFilters.map((filter) {
                          final isSelected = _selectedSubFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedSubFilter = filter;
                                });
                              },
                              backgroundColor: const Color(0xFF16151B),
                              selectedColor: AppTheme.gold.withValues(alpha: 0.25),
                              checkmarkColor: AppTheme.gold,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.gold : Colors.white70,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppTheme.gold : Colors.white12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Products Grid
                    AnimatedBuilder(
                      animation: LocalStore.instance,
                      builder: (context, _) {
                        final mensProducts = LocalStore.allProducts.where((p) {
                          final matchesCategory = p.category == 'MEN' || p.category == 'UNISEX';
                          final query = _searchQuery.toLowerCase().trim();
                          final matchesQuery = query.isEmpty ||
                              p.name.toLowerCase().contains(query) ||
                              p.tagline.toLowerCase().contains(query);

                          return matchesCategory && matchesQuery;
                        }).toList();

                        if (mensProducts.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(32),
                            alignment: Alignment.center,
                            child: const Column(
                              children: [
                                Icon(Icons.search_off_rounded, color: AppTheme.gold, size: 40),
                                SizedBox(height: 12),
                                Text(
                                  'No Men\'s Fragrances Found',
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mensProducts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final product = mensProducts[index];
                            return _CollectionProductCard(product: product);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionProductCard extends StatelessWidget {
  final Product product;

  const _CollectionProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isFavorite = LocalStore.instance.isInWishlist(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF16151B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.gold.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color(0xFF221E18),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/Velora_gold_logo.png', fit: BoxFit.contain);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        LocalStore.instance.toggleWishlist(product.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: AppTheme.gold,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.category,
              style: const TextStyle(
                color: AppTheme.gold,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppTheme.lightGold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    LocalStore.instance.addToCart(
                      CartItem(
                        id: product.id,
                        name: product.name,
                        category: product.category,
                        price: product.price,
                        imageUrl: product.imageUrl,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to Cart.'),
                        backgroundColor: const Color(0xFF242424),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppTheme.gold,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
