import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/components/coffee_tile.dart';
import 'package:coffee_shop/models/coffee_shop.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartPage extends StatefulWidget {
   const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFirebase(List<Coffee> coffee) async {


    // Provider.of<CoffeeShop>(context, listen: false).addItemToCart(coffee);


    for(int i = 0; i < coffee.length; i++){
      await _firestore.collection('Purchased Coffees').add({
        'name': coffee[i].name,
        'price': coffee[i].price,
        'imagePath': coffee[i].imagePath,
      });
    }


  }


  //remove item from cart 
  void removeFromCart (Coffee coffee) {
    Provider.of<CoffeeShop>(context,listen:false).removeItemFromCart(coffee);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop> (
      builder:((context, value, child) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [

            // heading
            Text(
              'Your Cart',
               style: TextStyle(fontSize: 20),
          ),

          // list of cart
          Expanded(
            child: ListView.builder(
              itemCount: value.userCart.length,
              itemBuilder: (context, index) {
            // get individual cart items
            Coffee eachCoffee = value.userCart[index];
            //return coffee
            return CoffeeTile(
              coffee: eachCoffee,
               onPressed: () => removeFromCart(eachCoffee), icon: Icon(Icons.delete),
            );
          }),
          ),

            SizedBox(height: 25),
            ElevatedButton(onPressed: (){
              List<Coffee> UserCart = value.userCart;
              debugPrint(UserCart.toString());
              addToFirebase(UserCart);
            }, child: Text("Purchase")),

          ],
          ),
      ),
      )),
      );
  }
}