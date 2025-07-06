# booking_doctor

Mata kuliah :
1. Pemrograman Mobile Lintas Platform
2. Basis Data NoSQL

Untuk Menjalankan codingan ini maka kita akan menyiapkan ruang lingkup yang akan digunakan
1. Instal Java 21
   1. Kita bisa download nya di chrome dengan menggunakan link : (https://www.oracle.com/ae/java/technologies/downloads/#jdk21-windows)
   2. Setelah itu kita pilih Installer dan menunggu beberapa saat untuk downloadnya
   3. Setelah itu kita bisa menginstall nya di laptop kita dan pilih secara default saja
   4. untuk mengecek nya kita bisa ke CMD lalu ketik java --version
   5. kalau hasilnya java 21 2023-09-19 LTS ini maka java kita sudah kedeteksi dengan laptop yang digunakan
   6. Kalau belum berhasil maka kita bisa menuju path file yang sudah kita lokasikan khusus java (biasanya di C di Program Files) sampai masuk dibagian bin
   7. Setelah itu bisa mencari Environtment ke User Variable di bagian Path tambahkan path file java
   8. lakukan lagi pengecekan di no 4
      
3. Instal SDK Flutter
   1. Kita bisa download di chrome dengan menggunakan link : (https://docs.flutter.dev/get-started/install/windows/mobile)
   2. Setelah itu kita scroll ke bawah sampai dapat pilihan maka kita pilih "Download & Instal" baru kita download yang versi zip
   3. Setelah itu kita bisa mengekstrak filennya jadi hasil filenya flutter_windows_3.3.25.zip/flutter
   4. Maka kita bisa buat file Dist apapun (idealnya C) lalu buat folder flutter/src
   5. Setelah kita ekstrak file zip nya maka kita pindahkan di foider yang kita sudah buat C/flutter/src
   6. Maka langkah selanjutya kita copy path filenya seperti ini C/flutter/src/flutter/bin
   7. Setelah itu kita cari Environtmen lalu pilih di User Variable bagian Path dan copy lalu simpan
   8. setelah itu kita bisa ketik di CMD flutter --version sama dart --version
      
5. Instal Android Studio
   1. kita bisa buka di chrome dengan menggunakan link : (https://developer.android.com/studio?gad_source=1&gad_campaignid=21831783564&gbraid=0AAAAAC-IOZlqpOh5OksRmtExfNeaQa_CR&gclid=Cj0KCQjwvajDBhCNARIsAEE29WrWMjAnG8RSvqL4-yzbP1KK_fubpPHLp1yWotUu3jOivFvYIBUFLq8aAi_BEALw_wcB&gclsrc=aw.ds&hl=id)
   2. Setelah itu kita bisa pilih yang versi di rekomendasikan
   3. Lalu scroll ke bawah dan centang lalu klik button downloadnya
   4. Setelah kita sudah download maka kita bisa menginstal Android studio di laptop
   5. Maka kita atur konfigurasi secara default saja
   6. Setelah dijalankan pertamakali maka kita pilih rekomndasi download dalam nya yang membutuhkan 8GB+
   7. Perlu diketahui karena kita melakukan donwload dan instal Androidstudio hanya mengambil SDK Platform, SDK Tools(build-tools, NDK, command-line, Android SDK Platform Tools dll), SDK Upddate Sites semuanya bisa di cek di SDK Manager
      
7. Instal Vscode
   1. Kita bisa buka di chrome dengan link : (https://code.visualstudio.com/)
   2. Setalah itu kita donwload sesuai OS laptop yang dimiliki
   3. Setelah kita download maka kita bisa instal di laptop dan untuk konfigrasi lakukan secara default
   4. Setelah kita masuk di vscode maka kita pergi ke Extension untuk download Code runner, Flutter, Dart

Perlu diketahui untuk menjalankan framework flutter harus terhubung dengan koneksi internet 

8. Menyiapkan Database
   1. kita bisa menggunakan chrome dengan link : (https://www.googleadservices.com/pagead/aclk?sa=L&ai=DChsSEwiC_-mW76eOAxWepWYCHRX-DPUYACICCAEQABoCc20&co=1&ase=2&gclid=Cj0KCQjwvajDBhCNARIsAEE29WqH1h3oh0WfED7ly377NX5UDISun-dQQo7_-WJTfOtnmrQYWv-9WOAaAgh_EALw_wcB&ohost=www.google.com&cid=CAESVeD2Minlwp1YwqdmM2gx5d7j71IXVmhmlzqjCKinYzKKDzfwCzllnSbznvt711_ciXMtKtbm_Rvcuf8aGppQC7dIJBNdYuAD_z4FJC4jl4COOPBrNZM&category=acrcp_v1_45&sig=AOD64_0Th8KdNScvxvOZZUrqTMotMo-cSg&q&nis=4&adurl&ved=2ahUKEwjXruaW76eOAxXc1DgGHbjWD9MQ0Qx6BAgJEAE)
   2. Setelah itu kita bisa klik "Go to console"
   3. Lalu klik "Get started with a Firebase project" atau "Create a Firebase Project"
   4. Masukkan Nama projeknya lalu centang lalu klik Continue
   5. jika kita ingin menggunakan AI assistank maka centang kalau tidak jangan di centang lalu Continue
   6. Kita perlu nyalakan Google Analytic bawaaan Firebase maka centang lalu klik Continue
   7. Analytic Location kita pilih indonesia lalu centang semuanya lalu klik Project
   8. Setelah menunggu beberapa saat maka klik Continue lagi
   9. Maka kita pilih Android
   10. Lalu kita mmasukkan Android package name berada di Projek/android/app/build.gradle.kts lalu cari codingan androdi dibagian namespace nya lalu salin dan tempelkan di Android Package.name
   11. lalu isi App nickname samakan saja dengan nama android package.name bedanya hapus di bagian com.example lalu klik register
   12. Setelah itu kita download google-servcices.json lalu tempatkan di file Projek/android/app/ lalu klik Next
   14. Setelah itu kita masuk di SDK Fiebase (pilih apakah kotlin atau groovy)di bagian pertama salinan nya akan masuk di Projek/android/ dan salin
   15. Setelah itu kita masuk di SDK Firebase  (pilih apakah kotlin atau groovy) di bagian kedua salinan nya akan masuk di Projek/android/app dan salin
   16. Setelah semuanya sudah di salin maka kita bisa klik Nex
   17. Setelah iitu klik lagi Go to console
   18. Setelah itu kita masuk di build dan pilihalah modul apa yang akan dgiunakan (Authentiication, Firestore, Realtime)
   19. Setelah itu kita klik "Create Database" atau "Get Started" di masing-masing modul yang digunakan
       
9. Hosting hanya untuk akses di web (Opsional)
    1. pakai modul Hosting yang ada di Firebase 
    2. sorce code harus berada di github
    3. buka codinngan yang terhubung dengan akun github dan git lokal yang ada di laptop
    4. ketik di terminal di codingan git lokal npm install -g firebase-tools
    5. ketik firebaase login
    6. ketik firebase init
    7. ketik firebase deploy
    8. ketik firebasefire configure
    9. commit & push terlebih dahulu
    10. ketik firebase deploy
