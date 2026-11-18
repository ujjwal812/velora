import 'package:flutter/material.dart';
import '../Mens/mens_collection_scr.dart';
import '../cart/detail_screen.dart';
import '../core/app_theme.dart';
import '../store/local_store.dart';
import '../store/women_collection_scr.dart';
import '../wishlist_screen.dart';
import 'Profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'ALL';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: _VeloraLeftDrawer(
        onCategorySelect: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 700;
            final horizontalPadding = isWideScreen ? 32.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 16,
                    bottom: 110,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _TopAppBar(),
                      const SizedBox(height: 20),
                      _SearchBarWidget(
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      const _PromoBanner(),
                      const SizedBox(height: 28),
                      _CategoriesSection(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      const SizedBox(height: 28),
                      _BestSellersSection(
                        selectedCategory: _selectedCategory,
                        searchQuery: _searchQuery,
                        onResetFilter: () {
                          setState(() {
                            _selectedCategory = 'ALL';
                            _searchQuery = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Section 1: Responsive Top App Bar
class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: 3-Line Menu Icon (Opens Left Navigation Drawer)
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.notes_rounded,
              color: AppTheme.gold,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Menu',
          ),
        ),

        // Center: VELORA Brand Text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'VELORA',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
                fontFamily: 'serif',
              ),
            ),
            SizedBox(height: 2),
            Text(
              'FINE FRAGRANCES',
              style: TextStyle(
                color: AppTheme.lightGold,
                fontSize: 8,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Right: Notification Bell Icon with Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No new notifications'),
                    backgroundColor: Color(0xFF16151B),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF16151B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.gold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.gold,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Left Navigation Drawer with User Details & Options
class _VeloraLeftDrawer extends StatelessWidget {
  final ValueChanged<String>? onCategorySelect;

  const _VeloraLeftDrawer({this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF100F15),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header (User Profile Brief)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF18161F),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.gold.withValues(alpha: 0.25),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.gold.withValues(alpha: 0.15),
                          border: Border.all(color: AppTheme.gold, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 32,
                          color: AppTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Ujjwal Kumar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ujjwal@example.com',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '+91 98765 43210',
                              style: TextStyle(
                                color: AppTheme.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text(
                        'VIEW & EDIT PROFILE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Menu Items
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  const _DrawerSectionTitle(title: 'MY ACCOUNT'),
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    title: 'My Profile',
                    subtitle: 'Personal info & details',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    subtitle: 'Track your deliveries',
                    onTap: () {
                      Navigator.pop(context);
                      _showPlaceholder(context, 'My Orders', Icons.shopping_bag_outlined);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Wishlist',
                    subtitle: 'Saved fragrances',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WishlistScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Delivery locations',
                    onTap: () {
                      Navigator.pop(context);
                      _showPlaceholder(context, 'Saved Addresses', Icons.location_on_outlined);
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Divider(color: Colors.white12),
                  ),

                  const _DrawerSectionTitle(title: 'CATEGORIES'),
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Women Collection',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WomenCollectionScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.person_sharp,
                    title: 'Men Collection',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MensCollectionScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.sanitizer_outlined,
                    title: 'Unisex Fragrances',
                    onTap: () {
                      Navigator.pop(context);
                      onCategorySelect?.call('UNISEX');
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.card_giftcard_outlined,
                    title: 'Luxury Gift Sets',
                    onTap: () {
                      Navigator.pop(context);
                      onCategorySelect?.call('GIFT SETS');
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Divider(color: Colors.white12),
                  ),

                  const _DrawerSectionTitle(title: 'PREFERENCES'),
                  _DrawerTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      _showPlaceholder(context, 'Settings', Icons.settings_outlined);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      _showPlaceholder(context, 'Help & Support', Icons.help_outline_rounded);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About VELORA',
                    onTap: () {
                      Navigator.pop(context);
                      _showPlaceholder(context, 'About VELORA', Icons.info_outline_rounded);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(14),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Text(
                    'V E L O R A',
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'YOUR SIGNATURE. YOUR SCENT.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 8,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showPlaceholder(BuildContext context, String title, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.background,
            foregroundColor: AppTheme.gold,
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppTheme.gold, size: 60),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This section is ready for your UI.',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF171717),
        title: const Text('Logout', style: TextStyle(color: AppTheme.gold)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              LocalStore.instance.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Color(0xFF171717),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;

  const _DrawerSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.gold,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = AppTheme.gold,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        horizontalTitleGap: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white24,
          size: 13,
        ),
      ),
    );
  }
}

/// Section 2: Modern Search Bar
class _SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBarWidget({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Search fine fragrances, notes, sets...',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: Colors.white54, size: 18),
        ],
      ),
    );
  }
}

/// Section 3: New Arrivals Promo Banner
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isCompact ? 16 : 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2A2315),
                Color(0xFF17130C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.gold.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'NEW ARRIVALS',
                      style: TextStyle(
                        color: AppTheme.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elegant Scents\nFor Every Mood',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final promoProduct = LocalStore.allProducts.firstWhere(
                            (p) => p.id == 'p4',
                            orElse: () => LocalStore.allProducts.first,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(product: promoProduct),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF5D77A),
                                Color(0xFFD4AF37),
                                Color(0xFFA88219),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'SHOP NOW',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.black,
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Real Perfume Bottle Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: isCompact ? 80 : 95,
                  height: isCompact ? 90 : 105,
                  decoration: BoxDecoration(
                    color: const Color(0xFF221E18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=600&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/Velora_gold_logo.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Section 4: Responsive Categories Section
class _CategoriesSection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _CategoriesSection({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'ALL', 'icon': Icons.grid_view_rounded},
      {'label': 'WOMEN', 'icon': Icons.person_outline_rounded},
      {'label': 'MEN', 'icon': Icons.person_sharp},
      {'label': 'UNISEX', 'icon': Icons.sanitizer_outlined},
      {'label': 'GIFT SETS', 'icon': Icons.card_giftcard_outlined},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CATEGORIES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            GestureDetector(
              onTap: () => onCategorySelected('ALL'),
              child: const Text(
                'VIEW ALL',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: categories.map((cat) {
              final label = cat['label'] as String;
              final icon = cat['icon'] as IconData;
              final isSelected = selectedCategory == label;

              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _CategoryItem(
                  icon: icon,
                  label: label,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(label),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.gold.withValues(alpha: 0.2)
                    : const Color(0xFF16151B),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.gold
                      : AppTheme.gold.withValues(alpha: 0.25),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.gold.withValues(alpha: 0.3),
                          blurRadius: 10,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.gold : Colors.white70,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.gold : Colors.white70,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section 5: Responsive Best Sellers Section
class _BestSellersSection extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;
  final VoidCallback onResetFilter;

  const _BestSellersSection({
    required this.selectedCategory,
    required this.searchQuery,
    required this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCategory == 'ALL'
                  ? 'EXPLORE FRAGRANCES'
                  : '$selectedCategory COLLECTION',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            if (selectedCategory != 'ALL' || searchQuery.isNotEmpty)
              GestureDetector(
                onTap: onResetFilter,
                child: const Text(
                  'RESET FILTER',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: LocalStore.instance,
          builder: (context, _) {
            final filteredProducts = LocalStore.allProducts.where((product) {
              final matchesCategory =
                  selectedCategory == 'ALL' || product.category == selectedCategory;
              final query = searchQuery.toLowerCase().trim();
              final matchesSearch = query.isEmpty ||
                  product.name.toLowerCase().contains(query) ||
                  product.category.toLowerCase().contains(query) ||
                  product.tagline.toLowerCase().contains(query) ||
                  product.topNotes.any((n) => n.toLowerCase().contains(query)) ||
                  product.heartNotes.any((n) => n.toLowerCase().contains(query)) ||
                  product.baseNotes.any((n) => n.toLowerCase().contains(query));

              return matchesCategory && matchesSearch;
            }).toList();

            if (filteredProducts.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF16151B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off_rounded, color: AppTheme.gold, size: 36),
                    SizedBox(height: 12),
                    Text(
                      'No Fragrances Found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Try searching for another note, name or category.',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isTabletOrDesktop = constraints.maxWidth > 650;

                if (isTabletOrDesktop) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _ProductCard(product: product);
                    },
                  );
                }

                return SizedBox(
                  height: 245,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    itemCount: filteredProducts.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _ProductCard(product: product);
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

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
        width: 155,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF16151B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.gold.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfume Bottle Image Box with Top-Right Heart Wishlist Badge
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
                            height: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_florist_rounded,
                                color: AppTheme.gold,
                                size: 38,
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

            // Price & Add To Cart Action Icon
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
                      border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.4),
                      ),
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
