import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class CatCollectionPage extends StatefulWidget {
  const CatCollectionPage({Key? key}) : super(key: key);

  @override
  _CatCollectionPageState createState() => _CatCollectionPageState();
}

class _CatCollectionPageState extends State<CatCollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Collection'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.collection),
      body: const Text('Cat Collection'), // TODO: implement Cat Collection
    );
  }
}
