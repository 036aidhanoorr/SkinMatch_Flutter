// File: lib/profile_page.dart (VERSI DIPERBAIKI DENGAN LOADING STATE)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import 'edit_profile_page.dart'; 
import 'menu_detail_page.dart'; 
import 'login_page.dart'; 

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);
const Color _kLightPinkBackground = Color(0xFFFDEEF2);
const Color _kHintGrey = Color(0xFF8D8D8D);

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Nilai Default (akan ditampilkan jika data belum ada di storage)
  String _userName = 'Pengguna Baru'; 
  String _userEmail = 'pengguna@skinmatch.com';
  String? _profileImageUrl; 
  
  // >>> BARU: Variabel untuk menandakan status loading data
  late Future<void> _dataLoadingFuture;
  
  final String _dummyNewImageUrl = 'https://i.imgur.com/Y1g9qYI.png'; 

  @override
  void initState() {
    super.initState();
    // Inisialisasi Future untuk memuat data
    _dataLoadingFuture = _loadUserData(); 
  }

  /// Fungsi untuk mengambil data profil dari Shared Preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final storedName = prefs.getString('user_name'); 
    final storedEmail = prefs.getString('user_email');
    
    // Perbarui state jika ada data yang tersimpan
    // Perhatikan: Kita hanya melakukan setState jika widget masih mounted
    if (mounted) {
      setState(() {
        _userName = storedName ?? 'Pengguna Baru'; // Gunakan nama default jika null
        _userEmail = storedEmail ?? 'pengguna@skinmatch.com'; // Gunakan email default jika null
        // _profileImageUrl = prefs.getString('user_photo_url');
      });
    }
  }

  // ... (Fungsi _showSnackbar, _editProfilePhoto, _editProfileData, _navigateToMenuDetail, _logout tetap sama)
  
  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editProfilePhoto() {
    setState(() {
      if (_profileImageUrl == null) {
        _profileImageUrl = _dummyNewImageUrl;
        _showSnackbar('Foto Profil berhasil di-upload!', Colors.green);
      } else {
        _profileImageUrl = null;
        _showSnackbar('Foto Profil berhasil dihapus!', _kPrimaryPink);
      }
    });
  }
  
  void _editProfileData() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialName: _userName,
          initialEmail: _userEmail,
          initialImageUrl: _profileImageUrl, 
        ),
      ),
    );

    if (result != null && result is Map) {
      final newName = result['name'] ?? _userName;
      final newEmail = result['email'] ?? _userEmail;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', newName); 
      await prefs.setString('user_email', newEmail);

      setState(() {
        _userName = newName;
        _userEmail = newEmail;
      });
      _showSnackbar('Data profil berhasil diperbarui!', Colors.green);
    }
  }

  void _navigateToMenuDetail(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailPage(title: title),
      ),
    );
  }

  void _logout() async { 
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name'); 
    await prefs.remove('user_email'); 
    
    _showSnackbar('Berhasil Keluar Akun.', Colors.redAccent);
    
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(), 
        ),
        (Route<dynamic> route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kLightPinkBackground,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 22
          ),
        ),
        backgroundColor: _kLightPinkBackground,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      // >>> PERUBAHAN UTAMA: Menggunakan FutureBuilder untuk menunggu _loadUserData()
      body: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading screen/indicator saat data sedang dimuat
            return const Center(
              child: CircularProgressIndicator(color: _kPrimaryPink),
            );
          }
          
          // Tampilkan konten utama setelah data selesai dimuat
          return _buildProfileContent();
        },
      ),
    );
  }
  
  // >>> BARU: Ekstrak konten profil ke fungsi terpisah
  Widget _buildProfileContent() {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Kelola informasi akun kamu',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
            
            _buildAvatarSection(),
            const SizedBox(height: 25),

            _buildInfoCard(),
            const SizedBox(height: 20),

            _buildMenuCard(
              icon: Icons.notifications_none,
              title: 'Notifikasi',
              onTap: () => _navigateToMenuDetail('Notifikasi'), 
              iconColor: Colors.amber,
            ),
            const SizedBox(height: 15),
            
            _buildMenuCard(
              icon: Icons.lock_outline,
              title: 'Privasi & Keamanan',
              onTap: () => _navigateToMenuDetail('Privasi & Keamanan'), 
              iconColor: _kPrimaryPink,
            ),
            const SizedBox(height: 15),
            
            _buildMenuCard(
              icon: Icons.help_outline,
              title: 'Bantuan & Dukungan',
              onTap: () => _navigateToMenuDetail('Bantuan & Dukungan'), 
              iconColor: Colors.redAccent,
            ),
            
            const SizedBox(height: 20),
            
            _buildAboutCard(),
            const SizedBox(height: 20),
            
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      );
  }
  // ... (Semua fungsi _build... lainnya tetap di bawah sini)
  // ... (Pastikan semua fungsi build widget lainnya ada di bawah _buildProfileContent)
  
  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _profileImageUrl == null ? _kPrimaryPink.withOpacity(0.8) : Colors.transparent,
                image: _profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _profileImageUrl == null
                  ? const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 60,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _editProfilePhoto,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: _kPrimaryPink,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _userName, 
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          _userEmail, 
          style: const TextStyle(
            fontSize: 15,
            color: _kHintGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Akun',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.black87
              ),
            ),
            const Divider(height: 30),
            
            _buildDetailRow(
              icon: Icons.person_outline,
              title: 'Nama',
              value: _userName, 
              iconColor: _kPrimaryPink,
            ),
            const SizedBox(height: 15),
            _buildDetailRow(
              icon: Icons.email_outlined,
              title: 'Email',
              value: _userEmail, 
              iconColor: _kPrimaryPink,
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _editProfileData,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: _kPrimaryPink,
                  side: const BorderSide(color: _kPrimaryPink, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildAboutCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.black87
              ),
            ),
            const Divider(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Versi', style: TextStyle(fontSize: 15, color: Colors.black54)),
                Text('1.0.0', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Build', style: TextStyle(fontSize: 15, color: Colors.black54)),
                Text('2024.12', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.exit_to_app, color: Colors.red),
        label: const Text(
          'Keluar',
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: Colors.red
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}