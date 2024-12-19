import 'package:awesome_dialog/awesome_dialog.dart'; // Library untuk menampilkan dialog yang menarik.
import 'package:firebase_auth/firebase_auth.dart'; // Library untuk autentikasi menggunakan Firebase.
import 'package:firebase_database/firebase_database.dart'; // Library untuk menggunakan Realtime Database Firebase.
import 'package:flutter/material.dart'; // Library utama untuk membangun UI dengan Flutter.
import 'package:guruji/views/home.dart'; // Mengimpor halaman beranda setelah login berhasil.

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  // Controller untuk mengontrol input pada TextField email dan password.
  var email = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite, // Tinggi container mencakup seluruh layar.
        width: double.maxFinite, // Lebar container mencakup seluruh layar.
        child: Stack(
          children: [
            // Latar belakang berupa gambar.
            Image.asset(
              'assets/bg.png',
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover, // Menyesuaikan gambar dengan ukuran layar.
            ),
            // Padding untuk memberi jarak pada konten di dalam layar.
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: ListView(
                children: [
                  SizedBox(height: 20), // Memberi jarak di bagian atas.
                  Image.asset('assets/logo.png'), // Logo aplikasi.
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Learn Graphic and UI/UX designing in Hindi \n for free with live projects.',
                      textAlign: TextAlign.center, // Teks rata tengah.
                      style: TextStyle(
                        color: Colors.white, // Warna teks putih.
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Memberi jarak.
                  // Input field untuk email.
                  Container(
                    height: 50, // Tinggi container.
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            25), // Membuat sudut melengkung.
                        color: Colors.white), // Padding di dalam container.
                    child: TextField(
                      controller:
                          email, // Menghubungkan dengan controller email.
                      decoration: InputDecoration(
                          border: InputBorder.none, // Tidak ada border default.
                          hintText:
                              'Email Address'), // Placeholder untuk input.
                    ), // Warna latar putih.
                  ),
                  SizedBox(height: 20), // Memberi jarak.
                  // Input field untuk password.
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: TextField(
                      controller:
                          password, // Menghubungkan dengan controller password.
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password'), // Placeholder untuk password.
                    ),
                  ),
                  SizedBox(height: 20), // Memberi jarak.
                  // Tombol login.
                  InkWell(
                    onTap: () async {
                      // Proses login menggunakan Firebase Auth.
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.text, password: password.text);

                        // Jika login berhasil, navigasi ke halaman HomePage.
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      } on FirebaseAuthException catch (e) {
                        // Jika terjadi error pada login.
                        if (e.code == 'wrong-password') {
                          // Jika password salah, tampilkan dialog.
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.warning,
                            title: 'Email & password salah. Coba lagi',
                            btnOkOnPress: () {},
                          ).show();

                          email.clear(); // Reset input email.
                          password.clear(); // Reset input password.
                        } else if (e.code == 'user-not-found') {
                          // Jika user tidak ditemukan.
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.error,
                            title: 'User tidak ditemukan. Coba lagi',
                            btnOkOnPress: () {},
                          ).show();

                          email.clear();
                          password.clear();
                        } else {
                          // Error lain (misal masalah jaringan).
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.warning,
                            title: 'Periksa internet anda',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      }
                    },
                    child: Container(
                      height: 50, // Tinggi tombol.
                      alignment: Alignment.center, // Teks di tengah tombol.
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              25), // Sudut tombol melengkung.
                          color: Colors.orange),
                      child: Text(
                        'LOGIN', // Teks pada tombol.
                        style: TextStyle(color: Colors.white),
                      ), // Warna tombol.
                    ),
                  ),
                  SizedBox(height: 20),
                  // Teks untuk lupa password.
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Teks untuk pendaftaran akun baru.
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Dont have an account? Register now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Gambar untuk login menggunakan media sosial.
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/social login.png')),
                  SizedBox(height: 40),
                  // Teks syarat dan ketentuan.
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'By signing up, you are agree with our Terms & Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
