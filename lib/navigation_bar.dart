import 'package:flutter/material.dart';
import 'package:sqflite_crud_operations/page/page1.dart';
import 'package:sqflite_crud_operations/page/page2.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int selectedIndex = 0;
  List page = [const MyHomePage(), const MyHomePage2()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.crop_square_outlined,
                ),
                label: 'Veritabanlı'),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_off_sharp),
                label: 'Veritabansız'),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          }),
      body: page[selectedIndex],
    );
  }
}

class ikinci extends StatelessWidget {
  const ikinci({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ucuncu extends StatelessWidget {
  const ucuncu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
