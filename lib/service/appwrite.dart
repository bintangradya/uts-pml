import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:uts_bintang/model/recipe.dart';
import 'package:uts_bintang/model/user.dart';
import 'package:uts_bintang/screen/home.dart';
import 'package:uts_bintang/screen/login.dart';

class AppwriteService {
  Client client = Client();
  late Account account;
  late Databases databases;
  late Storage storage;
    final String databaseId = 'recipeId';
  final String collectionId = 'recipeId';
  final String bucketId = 'recipeId';

  AppwriteService() {
    client
      ..setEndpoint(
          'https://cloud.appwrite.io/v1') // Ganti dengan endpoint Appwrite Anda
      ..setProject(
          "671db5840036fb0d033a"); // Ganti dengan project ID Appwrite Anda
  account = Account(client);
     databases = Databases(client);
    storage = Storage(client);
  }

  // Fungsi untuk mendaftarkan pengguna baru
  Future<UserModel?> register(
      String email, String password, String name) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return UserModel(
        id: user.$id,
        name: user.name,
        email: user.email,
      );
    } on AppwriteException catch (e) {
      print(" gagal : $e");
      if (e.code == 409) {
        throw 'Email sudah digunakan, silahkan gunakan email lain';
      }
      throw 'Terjadi kesalahan saat register';
    }
  }

  // Fungsi untuk login pengguna
  Future<void> login(String email, String password, context) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      print('Login successful');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } on AppwriteException catch (e) {
      print(e);
      if (e.code == 401) {
        throw 'Email dan password salah';
      }
      throw 'Terjadi kesalahan saat login, pastikan internet anda terhubung';
    }
  }

  // Logout pengguna
  Future<void> logout(context) async {
    try {
      await account.deleteSession(sessionId: 'current');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } catch (e) {
      throw Exception('Gagal logout');
    }
  }

////////////////////// COMING SOON ////////////////////////////


  // Mendapatkan detail pengguna saat ini
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await account.get();
      return UserModel(
        id: user.$id,
        name: user.name,
        email: user.email,
      );
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna saat ini');
    }
  }

  // Fetch Recipes
  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.orderDesc('\$createdAt'),
        ],
      );
      return response.documents
          .map((doc) => RecipeModel.fromMap(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      print("Error fetching recipes: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: $e");
      return [];
    }
  }

  // Add a new Recipe
  Future<void> createRecipe(String title, String description,
      {String? imagePath}) async {
    try {
      String? imageUrl;
      String? imageId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: bucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );
        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=671db5840036fb0d033a&mode=admin';
        imageId = responseImg.$id;
      }

      Map<String, dynamic> data = {
        'title': title,
        'description': description,
      };

      if (imageUrl != null) {
        data['gambar'] = imageUrl;
        data['gambarId'] = imageId;
      }

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: data,
      );
      print("Recipe created successfully");
    } on AppwriteException catch (e) {
      print("Error creating recipe: ${e.message}");
      throw 'Gagal menambahkan resep';
    }
  }

  // Update Recipe
  Future<void> updateRecipe(String id, String title, String description,
      {String? imagePath, String? oldImageId}) async {
    try {
      String? imageUrl;
      String? imageId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: bucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );
        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=671db5840036fb0d033a&mode=admin';
        imageId = responseImg.$id;

        if (oldImageId != null) {
          await storage.deleteFile(
            bucketId: bucketId,
            fileId: oldImageId,
          );
        }
      }

      Map<String, dynamic> data = {
        'title': title,
        'description': description,
      };

      if (imageUrl != null) {
        data['gambar'] = imageUrl;
        data['gambarId'] = imageId;
      }

      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
        data: data,
      );
      print("Recipe updated successfully");
    } on AppwriteException catch (e) {
      print("Error updating recipe: ${e.message}");
      throw 'Gagal memperbarui resep';
    }
  }

  // Delete Recipe
  Future<void> deleteRecipe(String id) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );
      print("Recipe deleted successfully");
    } on AppwriteException catch (e) {
      print("Error deleting recipe: ${e.message}");
      throw 'Gagal menghapus resep';
    }
  }
}
