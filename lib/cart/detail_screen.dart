import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../store/local_store.dart';

class DetailScreen extends StatefulWidget {
  final Product? product;

  const DetailScreen({super.key, this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Product _product;
  late PageController _pageController;
  int _selectedImageIndex = 0;
  String _selectedSize = '100 ml';
  String _selectedConcentration = 'Eau de Parfum';
  int _quantity = 1;

  final List<String> _sizeOptions = ['50 ml', '100 ml', '200 ml'];
  final List<String> _concentrationOptions = ['Eau de Parfum', 'Extrait de Parfum', 'Parfum Oil'];

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? LocalStore.allProducts.first;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Calculate dynamic price based on size multiplier
  double get _unitPrice {
    if (_selectedSize == '50 ml') {
      return _product.price * 0.80;
    } else if (_selectedSize == '200 ml') {
      return _product.price * 1.70;
    }
    return _product.price;
  }

  double get _totalPrice => _unitPrice * _quantity;

  List<String> get _productImages {
    if (_product.galleryImages.isNotEmpty) {
      return _product.galleryImages;
    }
    return [_product.imageUrl];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AnimatedBuilder(
        animation: LocalStore.instance,
        builder: (context, _) {
          final isFavorite = LocalStore.instance.isInWishlist(_product.id);

          return Stack(
            children: [
              // Main Scrollable Body
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Hero Image & Top Bar Sliver
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.46,
                      child: Stack(
                        children: [
                          // Image PageView
                          PageView.builder(
                            controller: _pageController,
                            itemCount: _productImages.length,
                            onPageChanged: (index) {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                color: const Color(0xFF16141B),
                                child: Image.network(
                                  _productImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF1B1822),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/Velora_gold_logo.png',
                                          height: 160,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          // Dark Gradient Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 100,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.background,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),

                          // Top Navigation Bar
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 8,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Back Button
                                _GlassActionButton(
                                  icon: Icons.arrow_back_ios_new_rounded,
                                  onTap: () => Navigator.of(context).pop(),
                                ),
                                Row(
                                  children: [
                                    // Wishlist Toggle
                                    _GlassActionButton(
                                      icon: isFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      iconColor: isFavorite ? AppTheme.gold : Colors.white,
                                      onTap: () {
                                        LocalStore.instance.toggleWishlist(_product.id);
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    // Cart Icon with Badge
                                    _GlassActionButton(
                                      icon: Icons.shopping_bag_outlined,
                                      badgeCount: LocalStore.instance.cartCount,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Gallery Indicator Dots
                          if (_productImages.length > 1)
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _productImages.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: _selectedImageIndex == index ? 28 : 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: _selectedImageIndex == index
                                            ? AppTheme.gold
                                            : Colors.white30,
                                        boxShadow: _selectedImageIndex == index
                                            ? [
                                                BoxShadow(
                                                  color: AppTheme.gold.withValues(alpha: 0.5),
                                                  blurRadius: 8,
                                                )
                                              ]
                                            : [],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Main Details Content Sheet
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 150, // Added padding to avoid overflow under sticky bottom bar
                      ),
                      decoration: const BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand Subheader & Authenticity Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _product.category.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.gold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.gold.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded, color: AppTheme.gold, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'Authentic Fine Fragrance',
                                      style: TextStyle(
                                        color: AppTheme.lightGold,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Product Name
                          Text(
                            _product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Tagline
                          Text(
                            '"${_product.tagline}"',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Rating & Price Summary Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: AppTheme.gold, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_product.rating}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '(${_product.reviewCount} Reviews)',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Price Tag
                              Text(
                                '₹${_unitPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppTheme.lightGold,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Divider(color: Colors.white12),
                          ),

                          // 3. Size & Concentration Selector
                          const Text(
                            'SELECT BOTTLE SIZE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _sizeOptions.map((size) {
                              final isSelected = _selectedSize == size;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.gold.withValues(alpha: 0.2)
                                          : const Color(0xFF16151B),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.gold
                                            : Colors.white.withValues(alpha: 0.15),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          color: isSelected ? AppTheme.gold : Colors.white70,
                                          fontSize: 12,
                                          fontWeight:
                                              isSelected ? FontWeight.bold : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'CONCENTRATION',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: _concentrationOptions.map((conc) {
                                final isSelected = _selectedConcentration == conc;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedConcentration = conc;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.gold.withValues(alpha: 0.15)
                                          : const Color(0xFF16151B),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected ? AppTheme.gold : Colors.white12,
                                      ),
                                    ),
                                    child: Text(
                                      conc,
                                      style: TextStyle(
                                        color: isSelected ? AppTheme.gold : Colors.white60,
                                        fontSize: 11,
                                        fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Divider(color: Colors.white12),
                          ),

                          // 4. Fragrance Notes Pyramid Section
                          const Text(
                            'FRAGRANCE PYRAMID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _NotesPyramidWidget(
                            topNotes: _product.topNotes,
                            heartNotes: _product.heartNotes,
                            baseNotes: _product.baseNotes,
                          ),

                          const SizedBox(height: 22),

                          // 5. Scent Accord Profile
                          if (_product.accords.isNotEmpty) ...[
                            const Text(
                              'MAIN ACCORDS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._product.accords.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${(entry.value * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: AppTheme.gold,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: entry.value,
                                        minHeight: 5,
                                        backgroundColor: const Color(0xFF1E1C24),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          AppTheme.gold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                          ],

                          // 6. Performance & Spec Grid
                          const Text(
                            'PERFORMANCE PROFILE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            children: [
                              _MetricCard(
                                icon: Icons.timer_outlined,
                                title: 'Longevity',
                                value: _product.longevity,
                              ),
                              _MetricCard(
                                icon: Icons.air_rounded,
                                title: 'Sillage',
                                value: _product.sillage,
                              ),
                              _MetricCard(
                                icon: Icons.ac_unit_rounded,
                                title: 'Best Season',
                                value: _product.season,
                              ),
                              _MetricCard(
                                icon: Icons.auto_awesome_rounded,
                                title: 'Occasion',
                                value: _product.occasion,
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Colors.white12),
                          ),

                          // 7. Master Perfumer Story & Description
                          const Text(
                            'THE SCENT STORY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _product.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                          if (_product.story.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16151B),
                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                border: const Border(
                                  left: BorderSide(
                                    color: AppTheme.gold,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Text(
                                _product.story,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // 8. How to Apply Guide
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14131A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.gold.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF22202C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb_outline_rounded,
                                    color: AppTheme.gold,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'APPLICATION ADVICE',
                                        style: TextStyle(
                                          color: AppTheme.gold,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Apply to pulse points: wrists, inner elbows, and base of neck from 15cm distance for maximum sillage.',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 10,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Sticky Bottom Action Bar with ADD TO BAG & BUY NOW buttons
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121016),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.85),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price summary banner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'TOTAL PRICE: ',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  '₹${_totalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppTheme.lightGold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$_selectedSize • $_selectedConcentration',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Action Buttons Row (Quantity | Add to Bag | Buy Now)
                        Row(
                          children: [
                            // Quantity Counter
                            Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1D26),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      child: Icon(Icons.remove, color: AppTheme.gold, size: 15),
                                    ),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() => _quantity++);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      child: Icon(Icons.add, color: AppTheme.gold, size: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // ADD TO BAG Button
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.gold,
                                    width: 1.2,
                                  ),
                                  color: AppTheme.gold.withValues(alpha: 0.12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    LocalStore.instance.addToCart(
                                      CartItem(
                                        id: _product.id,
                                        name: '${_product.name} ($_selectedSize)',
                                        category: _product.category,
                                        price: _unitPrice,
                                        imageUrl: _product.imageUrl,
                                        quantity: _quantity,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${_product.name} ($_selectedSize) added to Bag.'),
                                        backgroundColor: const Color(0xFF242424),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_bag_outlined, color: AppTheme.gold, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'ADD TO BAG',
                                          style: TextStyle(
                                            color: AppTheme.gold,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // BUY NOW Button
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF5D77A),
                                      Color(0xFFD4AF37),
                                      Color(0xFFA88219),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.gold.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    LocalStore.instance.addToCart(
                                      CartItem(
                                        id: _product.id,
                                        name: '${_product.name} ($_selectedSize)',
                                        category: _product.category,
                                        price: _unitPrice,
                                        imageUrl: _product.imageUrl,
                                        quantity: _quantity,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Proceeding to Instant Buy Checkout...'),
                                        backgroundColor: Color(0xFF242424),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.flash_on_rounded, color: Colors.black, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'BUY NOW',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlassActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int? badgeCount;
  final VoidCallback onTap;

  const _GlassActionButton({
    required this.icon,
    this.iconColor = Colors.white,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.55),
              border: Border.all(
                color: AppTheme.gold.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppTheme.gold,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotesPyramidWidget extends StatelessWidget {
  final List<String> topNotes;
  final List<String> heartNotes;
  final List<String> baseNotes;

  const _NotesPyramidWidget({
    required this.topNotes,
    required this.heartNotes,
    required this.baseNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16151B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          if (topNotes.isNotEmpty)
            _NoteRow(
              title: 'TOP NOTES',
              icon: Icons.eco_outlined,
              notes: topNotes,
              accentColor: AppTheme.lightGold,
            ),
          if (heartNotes.isNotEmpty) ...[
            const Divider(color: Colors.white12, height: 20),
            _NoteRow(
              title: 'HEART NOTES',
              icon: Icons.local_florist_outlined,
              notes: heartNotes,
              accentColor: AppTheme.gold,
            ),
          ],
          if (baseNotes.isNotEmpty) ...[
            const Divider(color: Colors.white12, height: 20),
            _NoteRow(
              title: 'BASE NOTES',
              icon: Icons.nature_people_outlined,
              notes: baseNotes,
              accentColor: AppTheme.darkGold,
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> notes;
  final Color accentColor;

  const _NoteRow({
    required this.title,
    required this.icon,
    required this.notes,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accentColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: notes.map((note) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22202A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      note,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.gold, size: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
