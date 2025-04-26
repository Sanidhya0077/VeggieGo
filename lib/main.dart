import 'package:flutter/material.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Tomato',
      price: 2.5,
      imageUrl: 'https://picsum.photos/200/150',
      description: 'A juicy and red tomato, perfect for salads and sauces.',
    ),
    Product(
      id: 2,
      name: 'Cucumber',
      price: 1.75,
      imageUrl: 'https://picsum.photos/200/151',
      description: 'A crisp and refreshing cucumber, great for hydration.',
    ),
    Product(
      id: 3,
      name: 'Spinach',
      price: 3.0,
      imageUrl: 'https://picsum.photos/200/152',
      description: 'Nutrient-rich spinach, ideal for smoothies and stir-fries.',
    ),
    Product(
      id: 4,
      name: 'Carrot',
      price: 1.25,
      imageUrl: 'https://picsum.photos/200/153',
      description: 'Crunchy and sweet carrot, a healthy snack option.',
    ),
    Product(
      id: 5,
      name: 'Bell Pepper',
      price: 2.0,
      imageUrl: 'https://picsum.photos/200/154',
      description: 'Colorful bell pepper, perfect for adding flavor to any dish.',
    ),
    Product(
      id: 6,
      name: 'Broccoli',
      price: 3.5,
      imageUrl: 'https://picsum.photos/200/155',
      description: 'Healthy broccoli, great for steaming and roasting.',
    ),
    Product(
      id: 7,
      name: 'Apple',
      price: 1.0,
      imageUrl: 'https://picsum.photos/200/156',
      description: 'A crisp and sweet apple, perfect for a quick snack.',
    ),
    Product(
      id: 8,
      name: 'Banana',
      price: 0.75,
      imageUrl: 'https://picsum.photos/200/157',
      description: 'A creamy and convenient banana, great for potassium.',
    ),
    Product(
      id: 9,
      name: 'Orange',
      price: 1.25,
      imageUrl: 'https://picsum.photos/200/158',
      description: 'A juicy and citrusy orange, rich in Vitamin C.',
    ),
    Product(
      id: 10,
      name: 'Grapes',
      price: 2.0,
      imageUrl: 'https://picsum.photos/200/159',
      description: 'Sweet and refreshing grapes, perfect for snacking.',
    ),
    Product(
      id: 11,
      name: 'Strawberry',
      price: 3.0,
      imageUrl: 'https://picsum.photos/200/160',
      description: 'Delicious and vibrant strawberries, great for desserts.',
    ),
    Product(
      id: 12,
      name: 'Blueberry',
      price: 4.0,
      imageUrl: 'https://picsum.photos/200/161',
      description: 'Antioxidant-rich blueberries, ideal for smoothies and cereals.',
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
      _cart.update(product.id, (value) => value + 1);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('VeggieGo: Fruits and Vegetables'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search fruits and vegetables...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _updateSearchTerm,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
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
              if (_totalItems > 0)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.yellow,
                  child: Text(
                    _totalItems.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
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
                  aspectRatio: 1.3,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: () => _addToCart(product),
                    child: const Text('Add to Cart'),
                  ),
                ),
                if (_cart[product.id] != null && _cart[product.id]! > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => _decreaseQuantity(product),
                          icon: const Icon(Icons.remove),
                          style: const IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        Text('Quantity: ${_cart[product.id]}'),
                        IconButton.filledTonal(
                          onPressed: () => _increaseQuantity(product),
                          icon: const Icon(Icons.add),
                          style: const IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '© ${DateTime.now().year} VeggieGo. All rights reserved.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ShoppingCartScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cartItems = products.where((product) => cart[product.id] != null).toList();
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
                      '\$${product.price.toStringAsFixed(2)} x ${cart[product.id]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => decreaseQuantity(product),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(cart[product.id].toString()),
                      IconButton(
                        onPressed: () => increaseQuantity(product),
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () => removeFromCart(product),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$${calculateTotalPrice(cart, products).toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                          totalPrice: calculateTotalPrice(cart, products)),
                    ),
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
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

  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
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
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
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
                  },
                  child: _isCheckingOut
                      ? const CircularProgressIndicator()
                      : Text('Pay \$${widget.totalPrice.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}
