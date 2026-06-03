import 'package:flutter/material.dart';

void main() {
  runApp(const PerfumeShopApp());
}

class PerfumeShopApp extends StatelessWidget {
  const PerfumeShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perfume Shop',
      theme: ThemeData(
        fontFamily: 'Serif', 
        scaffoldBackgroundColor: const Color(0xFFF4EDED),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentTabIndex = 0;
  final Map<String, Map<String, dynamic>> _cartItems = {};
  final List<Map<String, dynamic>> _favoritePerfumes = [];

  // Expanded Catalog Database with More Premium Perfumes
  final List<Map<String, dynamic>> allPerfumes = [
    {
      "name": "Shalimar",
      "brand": "Guerlain",
      "price50": 145.00,
      "price100": 195.00,
      "category": "Oriental",
      "notes": "Bergamot, Iris, Vanilla, Amber",
      "description": "A flight of fancy iconized. Inspired by the passionate love story between an Emperor and an Indian Princess, Shalimar is the fragrance of desire.",
      "color": const Color(0xFFE4C2BD),
      "image": "https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&q=80&w=600",
    },
    {
      "name": "Chanel No. 5",
      "brand": "Chanel",
      "price50": 160.00,
      "price100": 210.00,
      "category": "Floral",
      "notes": "Aldehydes, Jasmine, Neroli, Sandalwood",
      "description": "The very essence of femininity. An abstract, mysterious, powdered floral bouquet. The ultimate timeless luxury standard.",
      "color": const Color(0xFFD4B2AB),
      "image": "https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&q=80&w=600",
    },
    {
      "name": "Bleu de Chanel",
      "brand": "Chanel",
      "price50": 130.00,
      "price100": 175.00,
      "category": "Fresh",
      "notes": "Grapefruit, Mint, Cedar, Labdanum",
      "description": "An exquisite ode to masculine freedom expressed in a woody aromatic fragrance with a captivating trail. Timeless and non-conforming.",
      "color": const Color(0xFFBAC7CD),
      "image": "https://images.unsplash.com/photo-1523293182086-7651a899d37f?auto=format&fit=crop&q=80&w=600",
    },
    {
      "name": "Santal 33",
      "brand": "Le Labo",
      "price50": 230.00,
      "price100": 310.00,
      "category": "Woody",
      "notes": "Sandalwood, Virginia Cedar, Cardamom, Iris",
      "description": "A perfume that touches the sensual universality of this icon, which would intoxicate a man as much as a woman. An open fire, the soft drift of smoke.",
      "color": const Color(0xFFC9C0BB),
      "image": "https://images.unsplash.com/photo-1547887537-6158d64c35b3?auto=format&fit=crop&q=80&w=600",
    },
    {
      "name": "Black Opium",
      "brand": "Yves Saint Laurent",
      "price50": 155.00,
      "price100": 195.00,
      "category": "Oriental",
      "notes": "Black Coffee, Orange Blossom, Cedarwood",
      "description": "A captivating floral gourmet scent twisted with an opening of rich, dark coffee notes for an energetic and modern shot of adrenaline.",
      "color": const Color(0xFFCBB6BE),
      "image": "https://images.unsplash.com/photo-1616949755610-8c9bbc08f138?auto=format&fit=crop&q=80&w=600",
    },
    {
      "name": "Acqua di Gio",
      "brand": "Giorgio Armani",
      "price50": 115.00,
      "price100": 150.00,
      "category": "Fresh",
      "notes": "Marine Notes, Bergamot, Persimmon, Cedar",
      "description": "A resolutely masculine fragrance born from the sea, the sun, the earth, and the breeze of a Mediterranean island. Transparent, modern, and natural.",
      "color": const Color(0xFFCAD0C5),
      "image": "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&q=80&w=600",
    }
  ];

  void _addToCart(Map<String, dynamic> product, int size, double price) {
    final String cartKey = "${product['name']}_$size";
    setState(() {
      if (_cartItems.containsKey(cartKey)) {
        _cartItems[cartKey]!['quantity'] += 1;
      } else {
        _cartItems[cartKey] = {
          'name': product['name'],
          'brand': product['brand'],
          'size': size,
          'price': price,
          'color': product['color'],
          'image': product['image'],
          'quantity': 1,
        };
      }
    });
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (_favoritePerfumes.any((p) => p['name'] == product['name'])) {
        _favoritePerfumes.removeWhere((p) => p['name'] == product['name']);
      } else {
        _favoritePerfumes.add(product);
      }
    });
  }

  int get _totalCartCount {
    return _cartItems.values.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double grandTotal = _cartItems.values.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Your Shopping Bag", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
                      Text("($_totalCartCount items)", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 30),
                  Expanded(
                    child: _cartItems.isEmpty
                        ? const Center(child: Text("Your bag is currently empty.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                        : ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final key = _cartItems.keys.elementAt(index);
                              final item = _cartItems[key]!;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: item['color'],
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5B3A39))),
                                          Text("${item['brand']} • ${item['size']}ml", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          const SizedBox(height: 4),
                                          Text("\$${item['price'].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF724239))),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF724239)),
                                          onPressed: () {
                                            setState(() {
                                              if (item['quantity'] > 1) {
                                                item['quantity'] -= 1;
                                              } else {
                                                _cartItems.remove(key);
                                              }
                                            });
                                            setModalState(() {});
                                          },
                                        ),
                                        Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF724239)),
                                          onPressed: () {
                                            setState(() {
                                              item['quantity'] += 1;
                                            });
                                            setModalState(() {});
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  if (_cartItems.isNotEmpty) ...[
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
                        Text("\$${grandTotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF724239))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close Cart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: _cartItems.values.toList(),
                                totalAmount: grandTotal,
                                onOrderConfirmed: () {
                                  setState(() {
                                    _cartItems.clear(); // Empty cart on successful purchase
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF724239), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text("Proceed to Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        allPerfumes: allPerfumes,
        cartCount: _totalCartCount, 
        favoritePerfumes: _favoritePerfumes,
        onOpenCart: _showCartBottomSheet, 
        onQuickAdd: _addToCart,
        onToggleFavorite: _toggleFavorite,
      ),
      FavoritesScreen(
        favoriteItems: _favoritePerfumes,
        onToggleFavorite: _toggleFavorite,
        onQuickAdd: _addToCart,
      ),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: const Color(0xFF724239),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allPerfumes;
  final int cartCount;
  final List<Map<String, dynamic>> favoritePerfumes;
  final VoidCallback onOpenCart;
  final Function(Map<String, dynamic>, int, double) onQuickAdd;
  final Function(Map<String, dynamic>) onToggleFavorite;

  const HomeScreen({
    Key? key, 
    required this.allPerfumes,
    required this.cartCount, 
    required this.favoritePerfumes,
    required this.onOpenCart, 
    required this.onQuickAdd,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  String searchQuery = "";
  
  final List<String> categories = ["All", "Floral", "Woody", "Oriental", "Fresh"];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedPerfumes = widget.allPerfumes.where((perfume) {
      bool matchesCategory = selectedCategoryIndex == 0 || perfume["category"] == categories[selectedCategoryIndex];
      bool matchesSearch = perfume["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) || perfume["brand"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF5B3A39)),
          onPressed: () {},
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF5B3A39)),
                onPressed: widget.onOpenCart,
              ),
              if (widget.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: widget.onOpenCart,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Color(0xFF724239), shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${widget.cartCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("Find Your\nSignature Scent", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39), height: 1.2)),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search perfume...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: isSelected ? const Color(0xFF724239) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: Text(categories[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              
              displayedPerfumes.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: Text("No scents found.", style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(), 
                      itemCount: displayedPerfumes.length,
                      itemBuilder: (context, index) {
                        final item = displayedPerfumes[index];
                        bool isFav = widget.favoritePerfumes.any((p) => p['name'] == item['name']);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: item, 
                                  isFavInitially: isFav,
                                  onAddToCart: widget.onQuickAdd,
                                  onToggleFav: widget.onToggleFavorite,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: (item["color"] as Color).withOpacity(0.3), 
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item["color"],
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(image: NetworkImage(item["image"]!), fit: BoxFit.cover),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(item["brand"]!, style: const TextStyle(fontSize: 12, color: Color(0xFF9E8480))),
                                        const SizedBox(height: 2),
                                        Text(item["name"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text("\$${item["price50"]}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF724239))),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: const Color(0xFF724239)),
                                      onPressed: () => widget.onToggleFavorite(item),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.onQuickAdd(item, 50, item["price50"]);
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Added ${item['name']} (50ml) to bag!"), duration: const Duration(seconds: 1)),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(color: Color(0xFF724239), shape: BoxShape.circle),
                                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isFavInitially;
  final Function(Map<String, dynamic>, int, double) onAddToCart;
  final Function(Map<String, dynamic>) onToggleFav;

  const ProductDetailsScreen({
    Key? key, 
    required this.product, 
    required this.isFavInitially,
    required this.onAddToCart,
    required this.onToggleFav,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedSize = 50; 
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.isFavInitially;
  }

  @override
  Widget build(BuildContext context) {
    double dynamicPrice = selectedSize == 50 ? widget.product["price50"] : widget.product["price100"];

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: widget.product["color"],
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                  image: DecorationImage(image: NetworkImage(widget.product["image"]!), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF5B3A39)), onPressed: () => Navigator.pop(context)),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: const Color(0xFF724239)),
                        onPressed: () {
                          setState(() {
                            isFav = !isFav;
                          });
                          widget.onToggleFav(widget.product);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product["brand"]!.toUpperCase(), style: const TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 1.5)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product["name"]!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
                      Text("\$${dynamicPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF724239))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("Fragrance Notes: ${widget.product['notes']}", style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF724239), fontSize: 14)),
                  const SizedBox(height: 15),
                  Text(widget.product["description"]!, style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5)),
                  const SizedBox(height: 25),
                  const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
                  const SizedBox(height: 10),
                  Row(
                    children: [50, 100].map((size) {
                      bool isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF724239) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                          ),
                          child: Text("$size ml", style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onAddToCart(widget.product, selectedSize, dynamicPrice);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added ${widget.product['name']} ($selectedSize ml) to your bag!"), duration: const Duration(seconds: 2)),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF724239), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text("Add to Bag", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// NEW FUNCTIONAL SCREENS

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(Map<String, dynamic>) onToggleFavorite;
  final Function(Map<String, dynamic>, int, double) onQuickAdd;

  const FavoritesScreen({
    Key? key, 
    required this.favoriteItems, 
    required this.onToggleFavorite,
    required this.onQuickAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites", style: TextStyle(color: Color(0xFF5B3A39), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text("Your favorites list is empty.", style: TextStyle(color: Colors.grey, fontSize: 16)))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: item['color'],
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['brand'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF5B3A39))),
                              const SizedBox(height: 4),
                              Text("\$${item['price50']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF724239))),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Color(0xFF724239)),
                          onPressed: () => onToggleFavorite(item),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Color(0xFF5B3A39), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF724239),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text("Guest User", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
              const Text("guest.user@example.com", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              _buildProfileOption(Icons.shopping_bag_outlined, "Order History"),
              _buildProfileOption(Icons.location_on_outlined, "Shipping Address"),
              _buildProfileOption(Icons.payment_outlined, "Payment Methods"),
              _buildProfileOption(Icons.settings_outlined, "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF724239)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final VoidCallback onOrderConfirmed;

  const CheckoutScreen({
    Key? key, 
    required this.cartItems, 
    required this.totalAmount,
    required this.onOrderConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Color(0xFF5B3A39), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B3A39)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item['name']} (${item['size']}ml) x${item['quantity']}", style: const TextStyle(fontSize: 16)),
                        Text("\$${(item['price'] * item['quantity']).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Payable:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5B3A39))),
                Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF724239))),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  onOrderConfirmed(); // Clear Global Cart State
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                      content: const Text(
                        "Your premium fragrance order has been placed successfully!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close alert dialog box
                            Navigator.pop(context); // Close checkout view panel back to main store
                          },
                          child: const Text("Perfect", style: TextStyle(color: Color(0xFF724239), fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF724239), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text("Confirm Order", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}