import 'package:flutter/foundation.dart';

/// Product item model
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final List<String> galleryImages;
  final String tagline;
  final String description;
  final String story;
  final double rating;
  final int reviewCount;
  final List<String> topNotes;
  final List<String> heartNotes;
  final List<String> baseNotes;
  final Map<String, double> accords;
  final String longevity;
  final String sillage;
  final String season;
  final String occasion;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.galleryImages = const [],
    this.tagline = 'An exquisite symphony of rare olfactory notes.',
    this.description = '',
    this.story = '',
    this.rating = 4.8,
    this.reviewCount = 142,
    this.topNotes = const [],
    this.heartNotes = const [],
    this.baseNotes = const [],
    this.accords = const {},
    this.longevity = '10 - 12 Hours',
    this.sillage = 'Intense & Enveloping',
    this.season = 'Autumn / Winter',
    this.occasion = 'Evening & Special Events',
  });
}

/// Cart item model
class CartItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String?,
        quantity: json['quantity'] as int? ?? 1,
      );
}

/// Centralized local store for managing app state, session, cart, and wishlist
class LocalStore extends ChangeNotifier {
  LocalStore._privateConstructor();
  static final LocalStore instance = LocalStore._privateConstructor();

  static const List<Product> allProducts = [
    Product(
      id: 'p1',
      name: 'Velvet Noir',
      category: 'WOMEN',
      price: 3499.0,
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'Sensual, enigmatic, and timelessly seductive.',
      description: 'Velvet Noir captures the mysterious essence of midnight gardenia fused with smoked amber and velvety black violet. Designed for the bold woman who commands sophistication.',
      story: 'Handcrafted in Grasse, France by master perfumers using rare cold-pressed night blooms and aged dark amber resins.',
      rating: 4.9,
      reviewCount: 248,
      topNotes: ['Midnight Plum', 'Blackcurrant', 'Italian Bergamot'],
      heartNotes: ['Black Violet', 'Midnight Rose', 'Jasmine Sambac'],
      baseNotes: ['Smoked Amber', 'Bourbon Vanilla', 'Patchouli', 'Cashmere Wood'],
      accords: {
        'Floral': 0.90,
        'Smoky Amber': 0.85,
        'Woody': 0.75,
        'Sweet Vanilla': 0.65,
      },
      longevity: '10 - 12 Hours',
      sillage: 'Intense & Enveloping',
      season: 'Autumn / Winter / Night Out',
      occasion: 'Evening Galas & Midnight Soirées',
    ),
    Product(
      id: 'p2',
      name: 'Ocean Mist',
      category: 'MEN',
      price: 3999.0,
      imageUrl: 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1523293182086-7651a899d37f?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'Crisp aquatic sea breeze with warm golden oakmoss.',
      description: 'Ocean Mist evokes the exhilarating freshness of crashing waves against sun-drenched coastal cliffs. Blending vibrant citrus with deep sea minerals and white cedar.',
      story: 'Inspired by the pristine Mediterranean coastlines, distilled with natural ocean salt crystals and rare Italian citrus essential oils.',
      rating: 4.8,
      reviewCount: 186,
      topNotes: ['Sea Breeze Accord', 'Calabrian Bergamot', 'Grapefruit Zest'],
      heartNotes: ['Wild Sage', 'African Geranium', 'Fresh Rosemary'],
      baseNotes: ['Golden Amber', 'White Cedar', 'Himalayan Vetiver', 'Oakmoss'],
      accords: {
        'Fresh Aquatic': 0.95,
        'Citrus': 0.82,
        'Woody': 0.72,
        'Aromatic': 0.65,
      },
      longevity: '8 - 10 Hours',
      sillage: 'Moderate to High',
      season: 'Spring / Summer / Daytime',
      occasion: 'Executive Meetings & Summer Vacations',
    ),
    Product(
      id: 'p3',
      name: 'Rose Aura',
      category: 'UNISEX',
      price: 2999.0,
      imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'A romantic symphony of royal Damask Rose & smoked Oud.',
      description: 'Rose Aura balances the poetic romanticism of fresh morning Damask roses with the grounded, regal warmth of aged agarwood and golden honey nectar.',
      story: 'Harvested at dawn in the Rose Valley when the dew drops concentrate scent potency, blended with organic royal oud.',
      rating: 4.95,
      reviewCount: 312,
      topNotes: ['Damask Rose', 'Pink Pepper', 'Persian Saffron'],
      heartNotes: ['Bulgarian Rose', 'Hazelnut Praline', 'Warm Clove'],
      baseNotes: ['Royal Oud', 'Golden Honey', 'Sandalwood', 'White Musk'],
      accords: {
        'Damask Rose': 0.96,
        'Royal Oud': 0.88,
        'Warm Spicy': 0.75,
        'Honeyed Amber': 0.70,
      },
      longevity: '12+ Hours',
      sillage: 'Rich & Radiant Trail',
      season: 'All Seasons / Romantic Evenings',
      occasion: 'Anniversaries, Parties & Signature Daily Wear',
    ),
    Product(
      id: 'p4',
      name: 'Gold Elixir',
      category: 'GIFT SETS',
      price: 4999.0,
      imageUrl: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'The pinnacle of luxury perfumery and gilded elegance.',
      description: 'Gold Elixir is an opulent, golden potion infused with Madagascar vanilla, shimmering amber resins, and precious saffron. Includes travel atomizer and gold case.',
      story: 'Formulated to celebrate Velora’s heritage, containing 24-karat gold olfactory micro-shimmer and pure grade oils.',
      rating: 5.0,
      reviewCount: 420,
      topNotes: ['Golden Saffron', 'Blood Orange', 'Green Cardamom'],
      heartNotes: ['Orange Blossom', 'Amberwood', 'Ylang-Ylang'],
      baseNotes: ['Madagascar Vanilla', 'Golden Resin', 'Atlas Cedar', 'Tonka Bean'],
      accords: {
        'Warm Spicy': 0.92,
        'Gilded Amber': 0.90,
        'Vanilla Nectar': 0.85,
        'Woody': 0.72,
      },
      longevity: '14+ Hours',
      sillage: 'Unforgettable Luxury Trail',
      season: 'Fall / Winter / Grand Celebrations',
      occasion: 'Luxury Gifting & Black-Tie Events',
    ),
    Product(
      id: 'p5',
      name: 'Amber Royale',
      category: 'UNISEX',
      price: 4299.0,
      imageUrl: 'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1523293182086-7651a899d37f?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'Regal amber infused with warm honeyed tobacco.',
      description: 'Amber Royale is a noble creation built around glowing amber crystals, honeyed tobacco leaves, and smooth cinnamon bark for an intoxicating warm embrace.',
      story: 'Created with aged amber resin macerated for 6 months in oak barrels for maximum depth and richness.',
      rating: 4.85,
      reviewCount: 154,
      topNotes: ['Honeyed Tobacco', 'Cinnamon Bark', 'Fresh Nutmeg'],
      heartNotes: ['Amber Crystal', 'Benzoin Resin', 'Somali Myrrh'],
      baseNotes: ['Dark Sandalwood', 'Tonka Bean', 'Smoked Vetiver'],
      accords: {
        'Warm Amber': 0.95,
        'Sweet Tobacco': 0.86,
        'Woody': 0.80,
        'Spicy': 0.74,
      },
      longevity: '12+ Hours',
      sillage: 'Regal & Intimate',
      season: 'Autumn / Winter',
      occasion: 'Evening Lounges & Special Dates',
    ),
    Product(
      id: 'p6',
      name: 'Oud Supreme',
      category: 'MEN',
      price: 5499.0,
      imageUrl: 'https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=800&q=80',
      ],
      tagline: 'Dark, commanding, and profoundly intense royal oud.',
      description: 'Oud Supreme is an intense statement fragrance centered around aged Cambodian Oud, smoky incense, and rich leather accords for the ultimate executive aura.',
      story: 'Sourced directly from sustainable Cambodian agarwood reserves, refined using ancient steam distillation techniques.',
      rating: 4.92,
      reviewCount: 275,
      topNotes: ['Aged Oud', 'Smoked Incense', 'Cardamom Pods'],
      heartNotes: ['Tuscan Leather', 'Atlas Cedarwood', 'Patchouli Leaf'],
      baseNotes: ['Dark Amber', 'Guaiac Wood', 'Black Musk'],
      accords: {
        'Smoky Oud': 0.98,
        'Rich Leather': 0.88,
        'Woody': 0.85,
        'Spicy': 0.72,
      },
      longevity: '14+ Hours',
      sillage: 'Commanding & Powerful',
      season: 'Winter & Formal Nights',
      occasion: 'Red Carpet, Executive Boardrooms & Luxury Events',
    ),
  ];

  // User Session State
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;
  bool _rememberMe = false;

  // Cart & Wishlist State
  final List<CartItem> _cartItems = [
    CartItem(
      id: 'p1',
      name: 'Velvet Noir',
      category: 'WOMEN',
      price: 3499.0,
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=600&q=80',
      quantity: 1,
    ),
    CartItem(
      id: 'p4',
      name: 'Gold Elixir',
      category: 'GIFT SETS',
      price: 4999.0,
      imageUrl: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=600&q=80',
      quantity: 1,
    ),
  ];

  final Set<String> _wishlistProductIds = {'p1', 'p4'};

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  bool get rememberMe => _rememberMe;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Set<String> get wishlistProductIds => Set.unmodifiable(_wishlistProductIds);

  List<Product> get wishlistProducts {
    return allProducts
        .where((product) => _wishlistProductIds.contains(product.id))
        .toList();
  }

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // User Auth Methods
  void login({required String email, String? name, bool rememberMe = false}) {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = name ?? email.split('@').first;
    _rememberMe = rememberMe;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    _cartItems.clear();
    _wishlistProductIds.clear();
    notifyListeners();
  }

  // Wishlist Methods
  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistProductIds.clear();
    notifyListeners();
  }

  // Cart Methods
  void addToCart(CartItem item) {
    final index = _cartItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
