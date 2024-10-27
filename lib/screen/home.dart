import 'package:flutter/material.dart';
import 'package:uts_bintang/model/user.dart';
import 'package:uts_bintang/service/appwrite.dart';
// Sesuaikan dengan path UserModel Anda

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppwriteService _appwriteService = AppwriteService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    try {
      UserModel? user = await _appwriteService.getCurrentUser();
      setState(() {
        _user = user;
      });
    } catch (e) {
      print('Error fetching user: $e');
      // Tangani error sesuai kebutuhan, misalnya tampilkan Snackbar
    }
  }

  Future<void> _logout() async {
    await _appwriteService.logout(context);
    // Ganti dengan rute login Anda
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[200]!, Colors.teal[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      // Ganti dengan URL gambar profil jika ada
                                      'https://cdn-icons-png.flaticon.com/512/6858/6858504.png',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Welcome, ${_user!.name}!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Email: ${_user!.email}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.teal[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _logout,
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
