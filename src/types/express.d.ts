declare namespace Express {
  export interface Request {
    userId?: string;
    userType: 'guest' | 'pengguna' | 'pekerja';
  }
}
