export type Product = {
  id: string | number; name: string; country: string; category: string; price: number;
  fee: number; stock: number; deadline: string; image: string; badge?: string;
};

export const products: Product[] = [
  { id: 1, name: "Onitsuka Tiger Mexico 66", country: "Jepang", category: "Fashion", price: 1580000, fee: 120000, stock: 5, deadline: "4 Sep", image: "👟", badge: "Best Seller" },
  { id: 2, name: "Shiro Savon Eau de Parfum", country: "Jepang", category: "Beauty", price: 520000, fee: 65000, stock: 8, deadline: "4 Sep", image: "🧴", badge: "Hot" },
  { id: 3, name: "Gentle Monster Sunglasses", country: "Korea", category: "Fashion", price: 2350000, fee: 175000, stock: 3, deadline: "8 Sep", image: "🕶️" },
  { id: 4, name: "Kakao Friends Gift Set", country: "Korea", category: "Lifestyle", price: 395000, fee: 50000, stock: 12, deadline: "8 Sep", image: "🎁" },
  { id: 5, name: "Don Quijote Snack Box", country: "Jepang", category: "Food", price: 280000, fee: 45000, stock: 20, deadline: "4 Sep", image: "🍫" },
  { id: 6, name: "Tamburins Hand Cream", country: "Korea", category: "Beauty", price: 410000, fee: 55000, stock: 9, deadline: "8 Sep", image: "🧴" }
];

export const rupiah = (n: number) => new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR", maximumFractionDigits: 0 }).format(n);
