import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
          ),
          SafeArea(
              child: Container(
            width: 250,
            padding: EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo/happy_shop.png'),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10,),
                  Text('User Name',
                  style: TextStyle(color: Colors.white,
                  fontSize: 18),),
                  SizedBox(height: 20,),
                  ListTile(
                    leading: Icon(
                      Icons.shop,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    title: Text(
                      'Shop',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.payment,
                        color: Theme.of(context).secondaryHeaderColor),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                    onTap: () {
                      //Navigator.of(context).pushReplacementNamed(OrderScreen.route);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit,
                        color: Theme.of(context).secondaryHeaderColor),
                    title: Text(
                      'Your Products',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                    onTap: () {
                      //  Navigator.of(context).pushReplacementNamed(UserProductsScreen.route);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,
                        color: Theme.of(context).secondaryHeaderColor),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/');

                      // Provider.of<Auth>(context,listen: false).logout();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   child: ProductOverviewScreen(),
          // ),

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __){
              return Transform(
                  transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..setEntry(0, 3, 200*val)
                ..rotateY((3.14/6)*val),
              child: ProductOverviewScreen(),);
            },
          ),

          GestureDetector(
            onTap: (){
              setState(() {
                value==0? value=1: value=0;
              });
            },
          )
        ],
      ),
    );
  }
}
