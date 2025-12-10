// File: lib/edit_profile_page.dart (FINAL & NYAMBUNG)

import 'package:flutter/material.dart';

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String? initialImageUrl;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    this.initialImageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Memastikan field tidak kosong
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan Email tidak boleh kosong.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Mengembalikan data yang diubah dalam bentuk Map ke ProfilePage
    Navigator.pop(context, {
      'name': _nameController.text,
      'email': _emailController.text,
    });
  }
  
  void _cancelEdit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider = widget.initialImageUrl != null 
        ? NetworkImage(widget.initialImageUrl!) 
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil Saya', // Sesuai dengan desain UI Anda
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Mengikuti desain ProfilePage
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Avatar Section (Sama seperti di ProfilePage) ---
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: imageProvider == null ? _kPrimaryPink.withOpacity(0.8) : Colors.transparent,
                image: imageProvider != null
                    ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageProvider == null
                  ? const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 60,
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            const Text(
              'Foto Profil',
              style: TextStyle(color: _kPrimaryPink, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Form Input Nama
            const Align(alignment: Alignment.centerLeft, child: Text('Nama Lengkap')),
            const SizedBox(height: 5),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: widget.initialName,
                prefixIcon: const Icon(Icons.person_outline, color: _kPrimaryPink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // Form Input Email
            const Align(alignment: Alignment.centerLeft, child: Text('Email')),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: widget.initialEmail,
                prefixIcon: const Icon(Icons.email_outlined, color: _kPrimaryPink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Batal dan Simpan (Sesuai desain image_15f9da.png)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelEdit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: _kPrimaryPink,
                      side: const BorderSide(color: _kPrimaryPink, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Batal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}