SELECT 
    b2b AS transaksi_b2b,
    COUNT(order_id) AS jumlah_pesanan,
    SUM(amount) AS total_pendapatan
FROM cleaned_amazon_sales
GROUP BY b2b;