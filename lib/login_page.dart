// File: lib/login_page.dart (VERSI DIPERBAIKI FINAL)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <<< BARU: Import SharedPreferences

import 'signup_page.dart'; 
import 'main_navigator.dart'; 

// --- DEFINISI WARNA ---
const Color _kPrimaryPink = Color(0xFFFF699F); 
const Color _kHintGrey = Color(0xFF8D8D8D); 
const Color _kInputOutline = Color(0xFFE0E0E0); 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
  
  // Helper untuk menampilkan SnackBar
  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // >>> FUNGSI LOGIN UTAMA DENGAN PENYIMPANAN DATA (PERBAIKAN NAMA) <<<
  Future<void> _handleLogin() async {
    final String enteredEmail = _emailController.text.trim();
    final String password = _passwordController.text; // Kata sandi diperlukan untuk validasi

    if (enteredEmail.isEmpty || password.isEmpty) {
        _showSnackbar('Email dan kata sandi harus diisi.', Colors.red);
        return;
    }

    setState(() {
      _isLoading = true; // Aktifkan loading
    });

    // TODO: GANTI INI DENGAN PANGGILAN API LOGIN ASLI ANDA
    await Future.delayed(const Duration(seconds: 1)); // Simulasikan waktu loading API

    // --- ASUMSI LOGIN SUKSES ---
    if (mounted) {
      // 1. Ambil instance SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      // 2. Coba ambil nama pengguna yang sudah tersimpan sebelumnya
      String? storedName = prefs.getString('user_name'); 
      
      // 3. Tentukan nama yang akan disimpan/digunakan:
      // Jika 'user_name' belum ada atau isinya adalah nama default 'Pengguna Baru' (asumsi dari profile_page),
      // maka buat nama dari email. Jika sudah ada, gunakan nama yang tersimpan (dari Sign Up/Edit Profil).
      if (storedName == null || storedName.isEmpty || storedName == 'Pengguna Baru') {
          // Buat nama baru dari email untuk inisiasi
          final String initialName = enteredEmail.split('@').first.toUpperCase(); 
          storedName = initialName;
      }

      // 4. Simpan data pengguna yang sukses login ke local storage
      await prefs.setString('user_name', storedName); // <-- Gunakan nama yang sudah dicheck
      await prefs.setString('user_email', enteredEmail);

      // 5. Navigasi ke MainNavigator
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigator(), 
        ),
      );
      _showSnackbar('Login berhasil. Selamat datang kembali!', Colors.green);
    } else {
        // Ini dijalankan jika login gagal setelah delay simulasi
        _showSnackbar('Email atau kata sandi salah.', Colors.red);
    }


    setState(() {
      _isLoading = false; // Matikan loading
    });
  }
  // --------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 50.0), 
              const _LogoAndTitle(),
              const SizedBox(height: 40.0),

              _label('Email'),
              TextField(
                controller: _emailController, 
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('masukkan email anda'),
              ),
              const SizedBox(height: 15.0),
              
              _label('Kata Sandi'),
              TextField(
                controller: _passwordController, 
                obscureText: true,
                decoration: _inputDecoration('masukkan kata sandi'),
              ),
              
              const SizedBox(height: 25.0),
              _buildLoginButton(context), 
              const SizedBox(height: 10.0),
              const _ForgotPasswordLink(),
              const SizedBox(height: 25.0),
              const _Separator(),
              const SizedBox(height: 25.0),
              _buildRegisterButton(context), 
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
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
        onPressed: _isLoading ? null : _handleLogin, 
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
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: _kPrimaryPink, 
          side: const BorderSide(color: _kPrimaryPink, width: 1.5), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
          );
        },
        child: const Text(
          'Daftar Akun Baru',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
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
          'Temukan Produk Skincare Terbaik untuk Kulitmu',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ],
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          // TODO: Tambahkan Aksi Lupa Kata Sandi
        },
        child: const Text(
          'Lupa kata sandi?',
          style: TextStyle(color: _kPrimaryPink, fontSize: 15.0),
        ),
      ),
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