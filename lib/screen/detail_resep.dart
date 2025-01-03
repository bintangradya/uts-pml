import 'package:flutter/material.dart';
import 'package:uts_bintang/model/recipe.dart'; // Sesuaikan dengan path model Recipe Anda

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title ?? 'Recipe Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe.gambar ?? '',
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              recipe.title ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              recipe.description ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            // Text(
            //   'Ingredients:',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // // Jika Anda memiliki daftar bahan, tampilkan di sini
            // // Misalkan Anda memiliki field ingredients di model Recipe
            // // ... (tampilkan bahan di sini)
          ],
        ),
      ),
    );
  }
}
