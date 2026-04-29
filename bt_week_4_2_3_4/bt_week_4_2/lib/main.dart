import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GridScreen(),
    );
  }
}

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  // Danh sách icon cho 12 item
  static const List<IconData> icons = [
    Icons.star, Icons.favorite, Icons.music_note, Icons.camera,
    Icons.flight, Icons.directions_car, Icons.restaurant, Icons.sports_soccer,
    Icons.computer, Icons.phone, Icons.shopping_cart, Icons.beach_access,
  ];

  static const List<Color> colors = [
    Colors.red, Colors.orange, Colors.amber, Colors.green,
    Colors.teal, Colors.blue, Colors.indigo, Colors.purple,
    Colors.pink, Colors.cyan, Colors.lime, Colors.deepOrange,
  ];

  Widget _buildGridItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: colors[index % colors.length].withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors[index % colors.length].withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[index % icons.length],
            size: 36,
            color: colors[index % colors.length],
          ),
          const SizedBox(height: 8),
          Text(
            'Item ${index + 1}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors[index % colors.length].withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid View'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---- Section 1: GridView.count() ----
            const Text(
              'Fixed Column Grid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(12, (i) => _buildGridItem(i)),
            ),

            const SizedBox(height: 24),

            // ---- Section 2: GridView.extent() ----
            const Text(
              'Responsive Grid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.extent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(12, (i) => _buildGridItem(i)),
            ),

          ],
        ),
      ),
    );
  }
}