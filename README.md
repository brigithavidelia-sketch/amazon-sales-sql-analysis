### Analisis Kinerja Penjualan E-Commerce Amazon Menggunakan PostgreSQL

### 1. Latar Belakang & Masalah Bisnis

Amazon beroperasi dengan volume transaksi yang sangat tinggi serta beragam kategori produk dan metode pemenuhan logistik. Manajemen memerlukan analisis mendalam berbasis data untuk mengidentifikasi produk yang paling berkontribusi terhadap pendapatan, efisiensi metode pengiriman, serta potensi pasar pada segmen Business-to-Business (B2B). 

### 2. Dataset yang Digunakan

Dataset yang dianalisis merupakan data transaksi penjualan riil Amazon yang bersumber dari Kaggle. Dataset mencakup informasi penting seperti: order_id, date_order, status, category, qty, amount, b2b, dan lokasi pengiriman (ship_city, ship_state). 

### 3. Proses Pembersihan Data (Data Cleaning)

Untuk memastikan akurasi analisis keuangan, dilakukan pembersihan data kotor dengan kriteria berikut: 

* Menghilangkan transaksi yang batal (Cancelled dan Rejected) agar tidak mendistorsi pendapatan riil.
* Mengatasi nilai kosong (*null*) pada kolom pendapatan menggunakan fungsi COALESCE agar dapat dihitung secara matematis.

sql

CREATE OR REPLACE VIEW cleaned_amazon_sales AS
SELECT 
    order_id, date_order, status, fulfilment, category, size, qty,
    COALESCE(amount, 0) AS amount, ship_city, ship_state, b2b
FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Rejected');

Gunakan kode dengan hati-hati.

### 4. Analisis Temuan (Insights) & Kode SQL

### A. Kategori Produk Berdasarkan Pendapatan Tertinggi

Mengetahui kategori produk yang menjadi motor utama pendapatan perusahaan. 

sql

SELECT 
    category,
    SUM(qty) AS total_produk_terjual,
    SUM(amount) AS total_pendapatan
FROM cleaned_amazon_sales
GROUP BY category
ORDER BY total_pendapatan DESC;

Gunakan kode dengan hati-hati.

*Insight:* Kategori dengan total pendapatan tertinggi disarankan untuk selalu dijaga ketersediaan stoknya (*safety stock*), terutama menjelang musim puncak belanja (*peak-season*). 

Berikut adalah hasil eksekusi kueri pada pgAdmin:
![Hasil Kueri Kategori Produk](hasil_kategori.png)

### B. Efisiensi Metode Pengiriman (Fulfilment)

Membandingkan kinerja pengiriman internal Amazon dengan Merchant pihak ketiga. 

sql

SELECT 
    fulfilment AS metode_pengiriman,
    COUNT(order_id) AS jumlah_transaksi,
    SUM(amount) AS total_pendapatan,
    ROUND(AVG(amount), 2) AS rata_rata_nilai_transaksi
FROM cleaned_amazon_sales
GROUP BY fulfilment
ORDER BY total_pendapatan DESC;

Gunakan kode dengan hati-hati.

*Insight:* Mengidentifikasi apakah infrastruktur logistik Amazon berhasil memberikan kontribusi volume transaksi dan margin rata-rata yang lebih baik dibandingkan metode konvensional. 

Berikut adalah hasil eksekusi kueri pada pgAdmin:
![Hasil Kueri Metode Pengiriman](hasil_pengiriman.png)

### C. Analisis Segmen Pasar B2B (Business-to-Business)

Mengukur seberapa besar dampak pasar grosir/B2B terhadap struktur pendapatan Amazon. 

sql

SELECT 
    b2b AS transaksi_b2b,
    COUNT(order_id) AS jumlah_pesanan,
    SUM(amount) AS total_pendapatan
FROM cleaned_amazon_sales
GROUP BY b2b;

Gunakan kode dengan hati-hati.

*Insight:* Berdasarkan data analisis, transaksi non-B2B masih mendominasi platform. Namun, segmen B2B memiliki potensi pertumbuhan yang menarik jika didukung oleh kampanye pemasaran khusus korporat. 

Berikut adalah hasil eksekusi kueri pada pgAdmin:
![Hasil Kueri Segmen Pasar B2B](hasil_b2b.png)

### 5. Kesimpulan & Rekomendasi Strategis

1. **Fokus Alokasi Inventaris:** Alokasikan modal inventaris lebih besar pada kategori-kategori produk teratas hasil analisis guna menghindari kehilangan potensi penjualan akibat *out-of-stock*.
2. **Standardisasi Logistik:** Mendorong integrasi penjual pihak ketiga ke dalam ekosistem pemenuhan pesanan Amazon jika data menunjukkan performa finansialnya lebih unggul.
3. **Eksplorasi Pasar B2B:** Meluncurkan fitur atau kemudahan pembayaran khusus bisnis untuk menaikkan rata-rata nilai transaksi pada kelompok pengguna B2B.

👉 [Lihat Dashboard Penjualan Amazon di Tableau Public]([PASTE_LINK_BARU_ANDA_DI_SINI](https://public.tableau.com/views/AmazonSalesDataAnalysis_17928385579170/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
