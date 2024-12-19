import 'package:awesome_dialog/awesome_dialog.dart'; // Library untuk menampilkan dialog dengan gaya menarik.
import 'package:firebase_auth/firebase_auth.dart'; // Library untuk autentikasi menggunakan Firebase.
import 'package:flutter/material.dart'; // Library utama untuk membangun UI dengan Flutter.
import 'package:provider/provider.dart'; // Library untuk state management menggunakan Provider.
import 'package:url_launcher/url_launcher.dart'; // Library untuk membuka URL di browser.

import '../providers/data_provider.dart'; // Import provider untuk mengelola data.
import 'signin.dart'; // Import halaman signin.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat widget pertama kali dibuka.
    // Menggunakan Future.microtask agar fetchData dieksekusi segera setelah build.
    Future.microtask(
        () => Provider.of<DataProvider>(context, listen: false).fetchData());
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance DataProvider untuk mengakses data dan status loading.
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // Judul AppBar.
        title: const Text('List Data'),
        actions: [
          // Tombol logout di AppBar.
          IconButton(
            onPressed: () {
              // Menampilkan dialog konfirmasi menggunakan AwesomeDialog.
              AwesomeDialog(
                context: context,
                animType: AnimType.scale, // Animasi dialog.
                dialogType:
                    DialogType.question, // Ikon dialog berupa tanda tanya.
                title: 'Logout?', // Judul dialog.
                btnOkOnPress: () {
                  // Fungsi logout menggunakan Firebase Auth.
                  FirebaseAuth.instance.signOut();
                  // Navigasi ke halaman signin dan menghapus stack navigasi sebelumnya.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninPage(),
                    ),
                    (route) => false,
                  );
                },
              ).show(); // Menampilkan dialog.
            },
            icon: const Icon(
              Icons.logout_rounded, // Ikon logout.
              color: Colors.red, // Warna ikon logout.
            ),
          )
        ],
      ),
      body: dataProvider.isLoading
          ? // Jika data sedang dimuat, tampilkan indikator loading.
          const Center(child: CircularProgressIndicator())
          : dataProvider.dataList.isEmpty
              ? // Jika data kosong, tampilkan pesan "No data found!".
              const Center(child: Text('No data found!'))
              : // Jika ada data, tampilkan dalam bentuk ListView.
              ListView.builder(
                  padding: const EdgeInsets.all(25), // Padding untuk daftar.
                  itemCount:
                      dataProvider.dataList.length, // Jumlah item di dataList.
                  itemBuilder: (context, index) {
                    final value = dataProvider
                        .dataList[index]; // Mendapatkan data per item.
                    return GestureDetector(
                      onTap: () {
                        // Membuka URL di browser ketika item di-tap.
                        launchUrl(Uri.parse(value.link));
                      },
                      child: Container(
                        height: 200, // Tinggi item.
                        margin: const EdgeInsets.only(
                            bottom: 20), // Margin antar item.
                        padding:
                            const EdgeInsets.all(10), // Padding dalam item.
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              15), // Membuat sudut melengkung.
                          color: Colors.purple.shade50, // Warna latar item.
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Menyusun teks ke kiri.
                          children: [
                            // Menampilkan judul data.
                            Text(
                              value.title,
                              style: const TextStyle(
                                fontSize: 16, // Ukuran font.
                                fontWeight: FontWeight.bold, // Font tebal.
                              ),
                            ),
                            const SizedBox(height: 8), // Jarak antar elemen.
                            // Menampilkan deskripsi data (maksimal 7 baris).
                            Text(
                              value.desc,
                              maxLines: 7, // Maksimal 7 baris.
                              overflow: TextOverflow
                                  .ellipsis, // Tambahkan "..." jika terlalu panjang.
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
