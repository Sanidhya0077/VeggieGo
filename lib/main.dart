import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const VeggieGoApp());
}

class VeggieGoApp extends StatelessWidget {
  const VeggieGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VeggieGo',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50), // Green
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF81C784), // Light Green
          background: const Color(0xFFE8F5E9),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial'),
          titleLarge: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              onChanged: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Tomato',
      price: 40.0,
      imageUrl: 'https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg',
      description: 'A juicy and red tomato, perfect for salads and sauces.',
      quantity: 1.0,
    ),
    Product(
      id: 2,
      name: 'Cucumber',
      price: 30.0,
      imageUrl: 'https://images.pexels.com/photos/3568039/pexels-photo-3568039.jpeg',
      description: 'A crisp and refreshing cucumber, great for hydration.',
      quantity: 1.0,
    ),
    Product(
      id: 3,
      name: 'Spinach',
      price: 45.0,
      imageUrl: 'https://images.pexels.com/photos/2325843/pexels-photo-2325843.jpeg',
      description: 'Nutrient-rich spinach, ideal for smoothies and stir-fries.',
      quantity: 0.5,
    ),
    Product(
      id: 4,
      name: 'Carrot',
      price: 25.0,
      imageUrl: 'https://images.pexels.com/photos/1306559/pexels-photo-1306559.jpeg',
      description: 'Crunchy and sweet carrot, a healthy snack option.',
      quantity: 1.0,
    ),
    Product(
      id: 5,
      name: 'Bell Pepper',
      price: 60.0,
      imageUrl: 'https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg',
      description: 'Colorful bell pepper, perfect for adding flavor to any dish.',
      quantity: 0.5,
    ),
    Product(
      id: 6,
      name: 'Broccoli',
      price: 90.0,
      imageUrl: 'https://images.pexels.com/photos/47347/broccoli-vegetable-food-healthy-47347.jpeg',
      description: 'Healthy broccoli, great for steaming and roasting.',
      quantity: 0.5,
    ),
    Product(
      id: 7,
      name: 'Apple',
      price: 35.0,
      imageUrl: 'https://images.pexels.com/photos/206959/pexels-photo-206959.jpeg',
      description: 'A crisp and sweet apple, perfect for a quick snack.',
      quantity: 1.0,
    ),
    Product(
      id: 8,
      name: 'Banana',
      price: 40.0,
      imageUrl: 'https://images.pexels.com/photos/1093038/pexels-photo-1093038.jpeg',
      description: 'A creamy and convenient banana, great for potassium.',
      quantity: 1.0,
    ),
    Product(
      id: 9,
      name: 'Orange',
      price: 50.0,
      imageUrl: 'https://images.pexels.com/photos/327098/pexels-photo-327098.jpeg',
      description: 'A juicy and citrusy orange, rich in Vitamin C.',
      quantity: 1.0,
    ),
    Product(
      id: 10,
      name: 'Grapes',
      price: 70.0,
      imageUrl: 'https://images.pexels.com/photos/708777/pexels-photo-708777.jpeg',
      description: 'Sweet and refreshing grapes, perfect for snacking.',
      quantity: 0.5,
    ),
    Product(
      id: 11,
      name: 'Strawberry',
      price: 120.0,
      imageUrl: 'https://images.pexels.com/photos/89778/strawberries-fruit-food-freshness-89778.jpeg',
      description: 'Delicious and vibrant strawberries, great for desserts.',
      quantity: 0.25,
    ),
    Product(
      id: 12,
      name: 'Blueberry',
      price: 180.0,
      imageUrl: 'https://images.pexels.com/photos/87818/background-berries-berry-blueberries-87818.jpeg',
      description: 'Antioxidant-rich blueberries, ideal for smoothies and cereals.',
      quantity: 0.25,
    ),
  ];

  String _searchTerm = '';
  Map<int, int> _cart = {};

  List<Product> get _filteredProducts => products
      .where((product) =>
          product.name.toLowerCase().contains(_searchTerm.toLowerCase()))
      .toList();

  int get _totalItems =>
      _cart.values.fold(0, (previousValue, element) => previousValue + element);

  double get _totalPrice => products.fold(0, (previousValue, product) {
        return previousValue + ((_cart[product.id] ?? 0) * product.price);
      });

  double get _totalWeight => products.fold(0, (previousValue, product) {
        return previousValue + ((_cart[product.id] ?? 0) * product.quantity);
      });

  void _addToCart(Product product) {
    setState(() {
      _cart.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.remove(product.id);
    });
  }

  void _increaseQuantity(Product product) {
    setState(() {
      _cart.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    });
  }

  void _decreaseQuantity(Product product) {
    setState(() {
      if (_cart[product.id]! > 1) {
        _cart.update(product.id, (value) => value - 1);
      } else {
        _removeFromCart(product);
      }
    });
  }

  void _updateSearchTerm(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    int previousTotalItems = -1; // Initialize to a value unlikely to match
    double previousTotalWeight = -1.0; // Same logic here
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'VeggieGo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Fresh & Organic',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            SearchBar(
              onSearch: _updateSearchTerm,
            ),
            const SizedBox(height: 2),
            const Text(
              'Best Quality Fruits & Vegetables',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 100, // Fixed height for AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16,top: 16),  
            child: Stack(
              alignment: Alignment.topRight,
              children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartScreen(
                        cart: _cart,
                        products: products,
                        decreaseQuantity: _decreaseQuantity,
                        increaseQuantity: _increaseQuantity,
                        removeFromCart: _removeFromCart,
                      ),
                    ),
                  );
                },
              ),
             
              if (_cart.length > 0 && (_cart.length != previousTotalItems))
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.yellow,
                  child: Text(
                    '${_cart.length}',
                    style: const TextStyle(fontSize: 7, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '₹${product.price.toStringAsFixed(0)} / ${product.quantity}kg',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (_cart[product.id] != null && _cart[product.id]! > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => _decreaseQuantity(product),
                          icon: const Icon(Icons.remove, size: 16),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                        Text('${_cart[product.id]}', style: const TextStyle(fontSize: 12)),
                        IconButton.filledTonal(
                          onPressed: () => _increaseQuantity(product),
                          icon: const Icon(Icons.add, size: 16),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(32),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      onPressed: () => _addToCart(product),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        // color: Theme.of(context).colorScheme.secondary,
        
          padding: const EdgeInsets.all(2.0),
          // height:40,
          child: Text(
            '© ${DateTime.now().year} VeggieGo. All rights reserved.',
            textAlign: TextAlign.center,
          ),
      ),
    );
  }
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({
    super.key,
    required this.cart,
    required this.products,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.removeFromCart,
  });

  final Map<int, int> cart;
  final List<Product> products;
  final Function(Product) increaseQuantity;
  final Function(Product) decreaseQuantity;
  final Function(Product) removeFromCart;

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = widget.products.where((product) => widget.cart[product.id] != null).toList();
    final totalPrice = calculateTotalPrice(widget.cart, widget.products);
    cartItems.forEach((product) {
    // totalPrice += product.price * widget.cart[product.id]!;
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text(
                      '₹${product.price.toStringAsFixed(0)} × ${widget.cart[product.id]} = ₹${(product.price * widget.cart[product.id]!).toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.decreaseQuantity(product);
                          setState(() {}); // Force rebuild
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                      ),
                      Text(
                        widget.cart[product.id].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.increaseQuantity(product);
                          setState(() {}); // Force rebuild
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () {
                          widget.removeFromCart(product);
                          setState(() {}); // Force rebuild
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
bottomNavigationBar: Container(
  height: 100, 
  color: Colors.grey[100],
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        height: 40, // Fixed height for the Row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '₹${totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E8E41),
              elevation: 8,
              minimumSize: Size(double.infinity, 30), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
              ),
              shadowColor: Colors.green[300],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(totalPrice: totalPrice),
                ),
              );
            },
            child: Text(
              'Proceed to Pay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
)

    );
  }

  double calculateTotalPrice(Map<int, int> cart, List<Product> products) {
    return products.fold(0, (previousValue, product) {
      return previousValue + ((cart[product.id] ?? 0) * product.price);
    });
  }
}



class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.totalPrice});

  final double totalPrice;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _upiAddressController = TextEditingController();

  bool _isCheckingOut = false;
  String _paymentMethod = 'card';
  String _upiQrCodeData = '';

  @override
  void initState() {
    super.initState();
    _upiQrCodeData = 'upi://pay?pa=your-upi-id@oksbi&pn=Merchant&am=${widget.totalPrice}&cu=INR';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _paymentMethod = 'card';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _paymentMethod == 'card'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'Card',
                      style: TextStyle(
                        color: _paymentMethod == 'card'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _paymentMethod = 'upi';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _paymentMethod == 'upi'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'UPI',
                      style: TextStyle(
                        color: _paymentMethod == 'upi'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _paymentMethod = 'qr';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _paymentMethod == 'qr'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'QR Code',
                      style: TextStyle(
                        color: _paymentMethod == 'qr'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _paymentMethod == 'card'
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cardNumberController,
                          decoration:
                              const InputDecoration(labelText: 'Card Number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card number';
                            }
                            if (value.length != 16) {
                              return 'Card number must be 16 digits';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _expiryDateController,
                          decoration: const InputDecoration(
                              labelText: 'Expiry Date (MM/YY)'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            if (value.length != 5) {
                              return 'Expiry date must be in MM/YY format';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(labelText: 'CVV'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter CVV';
                            }
                            if (value.length != 3) {
                              return 'CVV must be 3 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                : _paymentMethod == 'upi'
                    ? TextFormField(
                        controller: _upiAddressController,
                        decoration:
                            const InputDecoration(labelText: 'UPI Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter UPI address';
                          }
                          return null;
                        },
                      )
                    : Column(
                        children: [
                          QrImageView(
                            data: _upiQrCodeData,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          SizedBox(height: 16),
                          Text('Scan QR code to pay'),
                        ],
                      ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_paymentMethod == 'card') {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isCheckingOut = true;
                      });

                      await Future.delayed(const Duration(seconds: 2));

                      setState(() {
                        _isCheckingOut = false;
                      });

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment successful!')),
                        );
                      }
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  } else if (_paymentMethod == 'upi') {
                    final Uri uri = Uri.parse(
                      'upi://pay?pa=${_upiAddressController.text}&pn=Merchant&am=${widget.totalPrice}&cu=INR',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to initiate payment')),
                      );
                    }
                  } else {
                    // Handle QR code payment
                  }
                },
                child: _isCheckingOut
                    ? const CircularProgressIndicator()
                    : Text('Pay ₹${widget.totalPrice.toStringAsFixed(0)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _upiAddressController.dispose();
    super.dispose();
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final double quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.quantity,
  });
}