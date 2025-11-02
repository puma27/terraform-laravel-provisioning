# Step by Step Confgiration

1. Buat file main.tf yang berisi resource Linode dan konfigurasi koneksi SSH
2. Menggunakan provisioner remote-exec untuk menjalankan perintah langsung di dalam VM via SSH
3. Remote-exec diarahkan ke file shell script eksternal ---> install_laravel.sh yang berisi langkah-langkah instalasi stack Laravel
4. Eksekusi Terraform
   terraform init
   terraform plan
   terraform apply -auto-approve

# Alasan menggunakan remote-exec dan shell script

   Karena lebih mudah digunakan untuk kebutuhan inisialisasi cepat dan lebih rapi dalam proses serta dapat digunakan ulang

# Access SSH and DB

   username      = "putramaulana"
   root_password = "TestingPutra=123"

   DB_USER="laravel_putra"
   DB_PASS="LaravelTest123!"

# Penjelasan detail

   Bagian paling lama dari pengerjaan ini adalah pada konfigurasi automation yang harus dilakukan trial error terhadap linode, karena saya belum mengetahui lebih dalam mengenai variabel yang dibutuhkan oleh linode supaya proses automation berjalan dengan lancar.

   Kesulitan disaat proses terraform berjalan ada error yang membuat re-running code kembali dan solve error tersebut yang membutuhkan analisa lebih lanjut serta waktu cukup banyak.