import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/components/coffee_tile.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:coffee_shop/models/coffee_shop.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
   const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add coffee to cart 
  Future<void> addToCart(Coffee coffee, String imagePath) async {

    String coffeeName = coffee.name;
    String coffeePrice = coffee.price;
    String coffeeImage = imagePath;

    Provider.of<CoffeeShop>(context, listen: false).addItemToCart(coffee);

    await _firestore.collection('cart').add({
      'name': coffeeName,
      'price': coffeePrice,
      'image': coffeeImage,
    });

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) =>  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              // HEADING MESSAGE
              const Text(
                "How would you like your coffee?", 
                style: TextStyle(fontSize: 20 ),
              ),
    
              const SizedBox(height: 25),
    
              // list of coffee to buy 
              Expanded(
                child: ListView.builder(
                  itemCount:value.coffeeShop.length, 
                  itemBuilder: (context, index) {
                // get individual coffee 
                Coffee eachCoffee = value.coffeeShop[index];
                // return the tile for this coffee
                return CoffeeTile(
                  coffee: eachCoffee,
                  icon: Icon(Icons.add),
                  onPressed: (){
                    addToCart(eachCoffee, eachCoffee.imagePath);
                  },
                  );
                
              }),
              ),
            ],
          ),
        ),
      ),
      );
  }
}