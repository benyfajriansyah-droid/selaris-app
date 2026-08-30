# JastipPro

Aplikasi jastip mobile-first berbasis Next.js + Neon Postgres. Fokus v0.2: katalog, cart, checkout tervalidasi server, tracking, admin foundation, auth session, dan integrasi Midtrans Snap server-side.

## Stack
- Next.js 15 + React 19 + TypeScript
- Neon Postgres (`@neondatabase/serverless`)
- Signed HTTP-only session cookie (`jose`) + bcrypt password hash
- Midtrans Snap API + signed notification webhook

## Setup
1. `npm install`
2. Salin `.env.example` ke `.env.local`.
3. Isi `DATABASE_URL` dari Neon pooled connection string dan `AUTH_SECRET`.
4. Jalankan `neon/schema.sql`, lalu opsional `neon/seed.sql`.
5. Buat user admin dengan password bcrypt (jangan simpan password plaintext).
6. Isi Midtrans sandbox keys, lalu arahkan payment notification URL ke `/api/payment/midtrans/notification`.
7. `npm run dev`

## Flow produksi
Customer memilih produk → cart → checkout → server membaca ulang harga/stok dari Neon → order dibuat → Snap token dibuat dari `/api/payment/midtrans` → webhook Midtrans memverifikasi signature dan mengubah order ke `paid` → admin melanjutkan status pembelian/pengiriman → customer tracking dengan no order + email.

## Catatan keamanan
Harga checkout tidak dipercaya dari browser. Server mengambil harga dan stok dari database. Cookie session HTTP-only. Midtrans notification diverifikasi dengan SHA-512 signature. Untuk production, gunakan `AUTH_SECRET` acak yang panjang, HTTPS, Midtrans production keys, rate limiting, dan backup/branching Neon.

## Status
Source sudah dimigrasikan dari Supabase ke Neon. Project Neon baru belum otomatis dibuat karena organisasi Neon yang tersambung dikelola Vercel dan menolak pembuatan project lewat Neon API. Buat database baru dari integrasi Vercel/Neon atau hubungkan organisasi Neon non-managed, lalu masukkan `DATABASE_URL`.
