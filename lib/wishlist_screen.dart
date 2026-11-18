import 'package:flutter/material.dart';
import 'cart/detail_screen.dart';
import 'core/app_theme.dart';
import 'store/local_store.dart';

class WishlistScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const WishlistScreen({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LocalStore.instance,
      builder: (context, _) {
        final wishlistProducts = LocalStore.instance.wishlistProducts;
        final isEmpty = wishlistProducts.isEmpty;

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.background,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'MY WISHLIST',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 18,
                letterSpacing: 4,
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (!isEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.white54,
                    size: 22,
                  ),
                  tooltip: 'Clear Wishlist',
                  onPressed: () {
                    LocalStore.instance.clearWishlist();
                  },
                ),
            ],
          ),
          body: SafeArea(
            child: isEmpty
                ? _EmptyWishlistWidget(onExploreTap: onExploreTap)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideScreen = constraints.maxWidth > 650;
                      final crossAxisCount = isWideScreen ? 3 : 2;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 110),
                          itemCount: wishlistProducts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final product = wishlistProducts[index];
                            return _WishlistProductCard(product: product);
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _EmptyWishlistWidget extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const _EmptyWishlistWidget({this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF16151B),
                border: Border.all(
                  color: AppTheme.gold.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: AppTheme.gold,
                size: 42,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Save your favorite fine fragrances to view or purchase them later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF5D77A),
                    Color(0xFFD4AF37),
                    Color(0xFFA88219),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: onExploreTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                ),
                child: const Text(
                  'EXPLORE FRAGRANCES',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
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

class _WishlistProductCard extends StatelessWidget {
  final Product product;

  const _WishlistProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
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
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF221E18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.gold.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/Velora_gold_logo.png',
                            height: 65,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_florist_rounded,
                                color: AppTheme.gold,
                                size: 40,
                              );
                            },
                          );
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
                        child: const Icon(
                          Icons.favorite_rounded,
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

            // Name
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

            // Category
            Text(
              product.category,
              style: const TextStyle(
                color: AppTheme.gold,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 8),

            // Price & Add to Cart
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppTheme.gold,
                      size: 14,
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
