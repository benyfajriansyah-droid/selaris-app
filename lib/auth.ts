import { SignJWT, jwtVerify } from 'jose';
import { cookies } from 'next/headers';

export type Session = { userId: string; email: string; role: 'customer'|'admin'; name: string };
const key = () => new TextEncoder().encode(process.env.AUTH_SECRET || 'dev-only-change-me');
export async function signSession(payload: Session) { return new SignJWT(payload).setProtectedHeader({alg:'HS256'}).setIssuedAt().setExpirationTime('7d').sign(key()); }
export async function readSession(): Promise<Session|null> {
  const token = (await cookies()).get('jp_session')?.value;
  if (!token) return null;
  try { const { payload } = await jwtVerify(token,key()); return payload as unknown as Session; } catch { return null; }
}
export async function requireAdmin(){ const s=await readSession(); if(!s||s.role!=='admin') throw new Error('UNAUTHORIZED'); return s; }
