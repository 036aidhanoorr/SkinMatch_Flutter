// File: lib/signup_page.dart (VERSI DIPERBAIKI)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <<< Wajib: Import SharedPreferences

import 'main_navigator.dart'; 
import 'login_page.dart'; 

// --- DEFINISI WARNA ---
const Color _kPrimaryPink = Color(0xFFFF699F); 
const Color _kHintGrey = Color(0xFF8D8D8D); 
const Color _kInputOutline = Color(0xFFE0E0E0); 

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Kontroler untuk input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kHintGrey, fontSize: 14.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
      filled: true,
      fillColor: Colors.white, 
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), 
        borderSide: const BorderSide(color: _kInputOutline, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _kInputOutline, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _kPrimaryPink, width: 1.5), 
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }

  // >>> FUNGSI UTAMA UNTUK PROSES DAFTAR <<<
  Future<void> _handleSignup() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // --- Validasi Dasar ---
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('Semua kolom harus diisi.', Colors.red);
      return;
    }
    if (password != confirmPassword) {
      _showSnackbar('Konfirmasi Kata Sandi tidak cocok.', Colors.red);
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    // TODO: GANTI INI DENGAN PANGGILAN API REGISTRASI ASLI ANDA
    // Asumsi: Panggilan API berhasil dan mengembalikan token/data pengguna
    await Future.delayed(const Duration(seconds: 1)); // Simulasikan waktu loading API
    
    // --- ASUMSI PENDAFTARAN SUKSES ---
    if (mounted) {
      // 1. Simpan data pengguna yang baru terdaftar ke local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      // Simpan token (jika ada) di sini: await prefs.setString('auth_token', '...');
      
      // 2. Navigasi ke MainNavigator tanpa parameter
      Navigator.pushAndRemoveUntil( 
        context,
        MaterialPageRoute(
          // PERBAIKAN: Panggil MainNavigator TANPA parameter
          builder: (context) => const MainNavigator(), 
        ),
        (Route<dynamic> route) => false, 
      );
      
      _showSnackbar('Pendaftaran berhasil! Selamat datang!', Colors.green);
    }
    
    // Ini mungkin tidak dipanggil jika navigasi di atas berhasil
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _LogoAndTitle(),
              const SizedBox(height: 40.0),

              // Input Nama
              _label('Nama Lengkap'),
              TextField(
                controller: _nameController, 
                keyboardType: TextInputType.text,
                decoration: _inputDecoration('masukkan nama lengkap anda'),
              ),
              const SizedBox(height: 15.0),

              // Input Email
              _label('Email'),
              TextField(
                controller: _emailController, 
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('masukkan email anda'),
              ),
              const SizedBox(height: 15.0),
              
              // Input Kata Sandi
              _label('Kata Sandi'),
              TextField(
                controller: _passwordController, 
                obscureText: true,
                decoration: _inputDecoration('buat kata sandi'),
              ),
              const SizedBox(height: 15.0),
              
              // Input Konfirmasi Kata Sandi
              _label('Konfirmasi Kata Sandi'),
              TextField(
                controller: _confirmPasswordController, 
                obscureText: true,
                decoration: _inputDecoration('ulangi kata sandi'),
              ),
              
              const SizedBox(height: 30.0),
              _buildSignupButton(), 
              const SizedBox(height: 25.0),
              
              const _Separator(),
              const SizedBox(height: 25.0),

              _buildLoginRedirectButton(context), 
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimaryPink, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _handleSignup,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'Daftar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginRedirectButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: const Text(
          'Sudah punya akun? Masuk di sini',
          style: TextStyle(color: _kPrimaryPink, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// --- Komponen Const untuk Performa (StatelessWidget) ---

class _LogoAndTitle extends StatelessWidget {
  const _LogoAndTitle();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _kPrimaryPink.withOpacity(0.1), 
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const Icon(Icons.auto_awesome, size: 45, color: _kPrimaryPink),
        ),
        const SizedBox(height: 10.0),
        const Text(
          'SkinMatch',
          style: TextStyle(color: _kPrimaryPink, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10.0),
        const Text(
          'Buat akunmu dan mulai temukan skincare terbaik!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'atau',
        style: TextStyle(color: _kHintGrey, fontSize: 15.0),
      ),
    );
  }
}