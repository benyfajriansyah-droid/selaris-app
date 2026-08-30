CREATE EXTENSION IF NOT EXISTS pgcrypto;
DO $$ BEGIN CREATE TYPE order_status AS ENUM ('pending_payment','paid','purchased','international_transit','arrived_indonesia','domestic_delivery','completed','cancelled'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TYPE trip_status AS ENUM ('draft','open_po','closed','shopping','in_transit','completed'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS users (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), full_name text NOT NULL, email text UNIQUE NOT NULL,
 phone text, password_hash text NOT NULL, role text NOT NULL DEFAULT 'customer' CHECK(role IN ('customer','admin')),
 created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS trips (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), title text NOT NULL, country text NOT NULL, city text,
 po_deadline timestamptz NOT NULL, depart_at timestamptz, return_at timestamptz, quota integer NOT NULL DEFAULT 50,
 status trip_status NOT NULL DEFAULT 'draft', created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS products (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), trip_id uuid REFERENCES trips(id) ON DELETE SET NULL,
 name text NOT NULL, slug text UNIQUE NOT NULL, description text, category text, country text,
 source_price numeric(14,2) NOT NULL CHECK(source_price>=0), source_currency text NOT NULL DEFAULT 'IDR',
 exchange_rate numeric(14,4) NOT NULL DEFAULT 1 CHECK(exchange_rate>0), jastip_fee numeric(14,2) NOT NULL DEFAULT 0,
 handling_fee numeric(14,2) NOT NULL DEFAULT 0, stock integer NOT NULL DEFAULT 0 CHECK(stock>=0), image_url text,
 active boolean NOT NULL DEFAULT true, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS orders (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), order_no text UNIQUE NOT NULL, user_id uuid REFERENCES users(id),
 customer_name text NOT NULL, customer_email text NOT NULL, customer_phone text NOT NULL, status order_status NOT NULL DEFAULT 'pending_payment',
 subtotal numeric(14,2) NOT NULL DEFAULT 0, handling_total numeric(14,2) NOT NULL DEFAULT 0,
 domestic_shipping numeric(14,2) NOT NULL DEFAULT 0, grand_total numeric(14,2) NOT NULL DEFAULT 0,
 payment_reference text, payment_status text, address jsonb NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS order_items (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
 product_id uuid REFERENCES products(id), product_name text NOT NULL, qty integer NOT NULL CHECK(qty>0),
 unit_price numeric(14,2) NOT NULL, fee numeric(14,2) NOT NULL DEFAULT 0, total numeric(14,2) NOT NULL
);
CREATE TABLE IF NOT EXISTS order_status_history (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
 status order_status NOT NULL, note text, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS settings (key text PRIMARY KEY, value jsonb NOT NULL, updated_at timestamptz NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS idx_products_active_category ON products(active,category);
CREATE INDEX IF NOT EXISTS idx_orders_user_created ON orders(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status_created ON orders(status,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_history_order_created ON order_status_history(order_id,created_at);
