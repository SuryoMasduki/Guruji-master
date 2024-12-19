import 'package:firebase_core/firebase_core.dart'; // Digunakan untuk inisialisasi Firebase dalam aplikasi Flutter.
import 'package:firebase_database/firebase_database.dart'; // Library untuk berinteraksi dengan Firebase Realtime Database.
import 'package:flutter/material.dart'; // Library utama untuk membangun UI Flutter.

import '../models/data_model.dart'; // Mengimpor model data yang digunakan untuk memetakan data dari database.

class DataProvider with ChangeNotifier {
  // Membuat referensi ke database Firebase.
  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(), // Inisialisasi Firebase app.
          databaseURL:
              'https://project-akhir-pam-e43f1-default-rtdb.asia-southeast1.firebasedatabase.app' // URL Realtime Database yang digunakan.
          )
      .ref()
      .child('data'); // Mengacu pada node 'data' dalam database.

  // Deklarasi variabel untuk menyimpan data dan status loading.
  List<DataModel> _dataList = []; // Menyimpan daftar data dari database.
  bool _isLoading = true; // Menandakan apakah data sedang dimuat atau tidak.

  // Getter untuk mendapatkan data dan status loading.
  List<DataModel> get dataList => _dataList;
  bool get isLoading => _isLoading;

  // Fungsi untuk mengambil data dari Firebase Realtime Database.
  Future<void> fetchData() async {
    _isLoading = true; // Mengubah status loading menjadi true.
    notifyListeners(); // Memberi tahu UI bahwa ada perubahan pada state.

    try {
      // Mengambil data dari referensi database.
      final snapshot = await _databaseRef.get();

      // Jika data ada dan tidak null.
      if (snapshot.exists && snapshot.value != null) {
        // Konversi data yang didapat dari snapshot menjadi Map.
        final dataMap = snapshot.value as Map<dynamic, dynamic>;
        // Memetakan data ke dalam list model.
        _dataList = dataMap.values.map((value) {
          return DataModel.fromMap(value as Map<dynamic, dynamic>);
        }).toList();
      } else {
        // Jika tidak ada data, kosongkan list.
        _dataList = [];
      }
    } catch (e) {
      // Menangani error ketika mengambil data.
      print('Error fetching data: $e');
    } finally {
      // Mengubah status loading menjadi false setelah proses selesai.
      _isLoading = false;
      notifyListeners(); // Memberi tahu UI bahwa data sudah diperbarui.
    }
  }
}
