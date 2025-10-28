## Pengembang

Nama: Dimas Bagus Hari Murti  
NIM: 240605110080  
Kelas: B  
Mata Kuliah: Mobile Programming  
Dosen Pengampu: A'la Syauqi,M.Kom


# Dimusic App

Aplikasi "Dimusic" adalah aplikasi pemutar musik sederhana berbasis Flutter yang menampilkan daftar lagu dari API "iTunes".  
Aplikasi ini dibuat untuk memenuhi bagian dari tugas UTS Mobile Programming.  


## Deskripsi Singkat

Home_Page.dart berfungsi untuk menampilkan berbagai daftar lagu berdasarkan kategori seperti:  
- Made for You  
- Popular Indonesia Singer  
- Taylor Swift Collection  
- Top Lyodra Song  
- Top NIKI Song  

Selain itu, didalam file music_player_pages.dart pengguna juga dapat:
- Memutar lagu (play, pause, next, previous)
- Menyukai lagu (like)
- Menambahkan lagu ke dalam playlist  


## Fitur Utama

1. Menampilkan Lagu dari API iTunes  
   Lagu ditampilkan secara dinamis menggunakan data real-time dari API iTunes.  

2. Pemutar Musik Interaktif  
   Lagu dapat diputar langsung dari aplikasi melalui halaman Music_Player_Page.dart  

3. Fitur Like dan Playlist 
   Lagu dapat ditandai sebagai favorit dan ditambahkan ke playlist pribadi.  

4. Navigasi Antar Halaman  
   Menggunakan "BottomNavigationBar" dan "Navigator.push()" untuk berpindah antar halaman seperti Home, Music, Like, dan Playlist.  

5. Tampilan Tema yang dinamis  
   Aplikasi mendukung Light Mode dan Dark Mode yang otomatis menyesuaikan dengan preferensi pengguna.


## Penjelasan Kode Utama

### 1. `ItunesApi.fetchSongs()`
Berfungsi untuk mengambil data lagu dari API iTunes berdasarkan kata kunci tertentu.  
Contoh:
final songs = await ItunesApi.fetchSongs("Taylor Swift");

### 2. `MusicPlayerPage`
Halaman ini digunakan untuk memutar lagu.  
Terdapat tombol "play", "pause", "next", dan "previous" yang berfungsi secara interaktif.

### 3. `LikeManager` & `PlaylistManager`
Keduanya menggunakan "Provider (ChangeNotifier)" untuk mengelola state secara global.  
- `LikeManager` menyimpan data lagu yang disukai.  
- `PlaylistManager` menyimpan data lagu yang ditambahkan ke playlist.  

### 4. `BottomNavigationBar`
Digunakan sebagai navigasi utama aplikasi agar pengguna bisa berpindah antar halaman dengan mudah.


## Desain Tampilan

Tampilan utama menggunakan tema dinamis yang dapat berubah antara light mode dan dark mode sesuai preferensi pengguna.
Setiap section lagu dapat digeser ke samping (horizontal scroll) menampilkan gambar album, judul lagu, dan nama penyanyi.


