import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/color.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';
import 'package:flutter_pos/presentation/checkout/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos/presentation/checkout/auth/pages/login_page.dart';
import 'package:flutter_pos/presentation/order/pages/order_confirmation_page.dart';
import 'package:flutter_pos/presentation/pos/bloc/product/product_bloc.dart';
import 'package:flutter_pos/presentation/pos/widgets/order_card.dart';
import 'package:flutter_pos/presentation/pos/widgets/product_card.dart';
import '../widgets/menu_button.dart';

class PosPage extends StatefulWidget {
  const PosPage({Key? key}) : super(key: key);

  @override
  State<PosPage> createState() => _PosPageState();
}

final List<String> categories = ['All', 'Drink', 'Snack', 'Food'];

class _PosPageState extends State<PosPage> {
  final searchController = TextEditingController();
  final ValueNotifier<int> indexValue = ValueNotifier(0);
  final Map<Product, int> cart = {};
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductFetched()); // Fetch all initially
  }

  void onCategoryTap(int index) {
    searchController.clear();
    indexValue.value = index;

    if (index == 0) {
      // All
      context.read<ProductBloc>().add(ProductFetched());
    } else {
      String category = '';
      switch (index) {
        case 1:
          category = 'drink';
          break;
        case 2:
          category = 'snack';
          break;
        case 3:
          category = 'food';
          break;
      }
      context.read<ProductBloc>().add(ProductCategoryFetched(category: category));
    }
  }

  void addToCart(Product product) {
    setState(() {
      if (cart.containsKey(product)) {
        cart[product] = cart[product]! + 1;
      } else {
        cart[product] = 1;
      }
    });
  }

  void updateQuantity(Product product, int quantity) {
    setState(() {
      if (quantity <= 0) {
        cart.remove(product);
      } else {
        cart[product] = quantity;
      }
    });
  }

  void placeOrder() {
    if (customerNameController.text.isEmpty || tableNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          cart: cart,
          total: cart.entries.fold(0.0, (sum, item) => sum + double.parse(item.key.price) * item.value),
          customerName: customerNameController.text,
          table: tableNumberController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset(
                            'assets/TL.png',
                            fit: BoxFit.cover, // Membuat gambar nge-zoom mengisi area lingkaran
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      const Text(
                        'Taminum POS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search item...',
                              hintStyle: TextStyle(color: AppColors.secondaryTextColor),
                              filled: true,
                              fillColor: AppColors.cardColor,
                              prefixIcon: const Icon(Icons.search, color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Orders: ${cart.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      if (state is LogoutSuccess) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                        );
                      } else if (state is LogoutFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (String value) {
                        switch (value) {
                          case 'settings':
                            Navigator.pushNamed(context, '/settings');
                            break;
                          case 'profile':
                            Navigator.pushNamed(context, '/profile');
                            break;
                          case 'logout':
                            context.read<LogoutBloc>().add(LogoutButtonPressed());
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'settings',
                          child: ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Settings'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'profile',
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Profile'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body Content
            Expanded(
              child: Row(
                children: [
                  // Left Product Area
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories
                        // Categories
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ValueListenableBuilder(
                            valueListenable: indexValue,
                            builder: (context, index, _) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  MenuButton(
                                    iconPath: Icon(Icons.dashboard, color: index == 0 ? Colors.white : Colors.green),
                                    label: 'All',
                                    isActive: index == 0,
                                    onPressed: () => onCategoryTap(0),
                                  ),
                                  MenuButton(
                                    iconPath: Icon(Icons.local_drink, color: index == 1 ? Colors.white : Colors.green),
                                    label: 'Drink',
                                    isActive: index == 1,
                                    onPressed: () => onCategoryTap(1),
                                  ),
                                  MenuButton(
                                    iconPath: Icon(Icons.fastfood, color: index == 2 ? Colors.white : Colors.green),
                                    label: 'Snack',
                                    isActive: index == 2,
                                    onPressed: () => onCategoryTap(2),
                                  ),
                                  MenuButton(
                                    iconPath: Icon(Icons.food_bank, color: index == 3 ? Colors.white : Colors.green),
                                    label: 'Food',
                                    isActive: index == 3,
                                    onPressed: () => onCategoryTap(3),
                                  ),
                                ].map((btn) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: SizedBox(width: 245, child: btn),
                                )).toList(),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        // Product Grid
                        Expanded(
                          child: BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              if (state is ProductLoading || state is ProductInitial) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (state is ProductFailure) {
                                return Center(child: Text('Error: ${state.message}'));
                              }

                              if (state is ProductSuccess) {
                                if (state.products.isEmpty) {
                                  return const Center(child: Text('Tidak ada produk tersedia'));
                                }

                                return GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 25.0,
                                    crossAxisSpacing: 25.0,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: state.products.length,
                                  itemBuilder: (context, index) => ProductCard(
                                    product: state.products[index],
                                    onPressed: () {
                                      addToCart(state.products[index]);
                                    },
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Order Summary
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(16),
                    color: AppColors.cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Info
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: customerNameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Customer Name',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                controller: tableNumberController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Table Number',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Order List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView(
                            children: cart.entries.map((entry) {
                              final product = entry.key;
                              final qty = entry.value;
                              return OrderCard(
                                product: product,
                                quantity: qty,
                                onQuantityChanged: (newQty) => updateQuantity(product, newQty),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: Rp${cart.entries.fold(0.0, (sum, item) => sum + double.parse(item.key.price) * item.value).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: placeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }
}
