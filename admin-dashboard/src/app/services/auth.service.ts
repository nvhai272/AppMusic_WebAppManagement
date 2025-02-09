import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private loginUrl = 'http://localhost:8080/api/loginForAdmin';
  private TOKEN_KEY = 'authToken';
  private EXPIRE_TIME_KEY = 'expireTime';
  private USER_KEY = 'userInfo';
  constructor(private http: HttpClient) {}

  login(username: string, password: string): Observable<any> {
    return this.http
      .post<any>(this.loginUrl, { username, password })
      .pipe(catchError(this.handleError));
  }

  checkRoll(role: string): boolean {
    const allowedRoles = ['ROLE_ADMIN', 'ROLE_ARTIST'];
    return allowedRoles.includes(role);
  }

  saveTokenAndUserInfo(token: string, user: any, exp: number): void {
    const expireTime = exp * 1000;
    // su dung time cua token

    localStorage.setItem(this.TOKEN_KEY, token);

    localStorage.setItem(this.EXPIRE_TIME_KEY, expireTime.toString());

    localStorage.setItem(this.USER_KEY, JSON.stringify(user));
  }

  getToken(): string | null {
    return localStorage.getItem(this.TOKEN_KEY);
  }

  getUserInfo(): any {
    const user = localStorage.getItem(this.USER_KEY);
    return user ? JSON.parse(user) : null;
  }

  isAuthenticated(): boolean {
    const token = this.getToken();
    const expireTime = localStorage.getItem(this.EXPIRE_TIME_KEY);

    if (!token || !expireTime) {
      return false;
    }

    const now = new Date().getTime();
    return now < parseInt(expireTime);
  }

  logout(): Promise<void> {
    return new Promise((resolve) => {
      localStorage.removeItem(this.TOKEN_KEY);
      localStorage.removeItem(this.USER_KEY);
      localStorage.removeItem(this.EXPIRE_TIME_KEY);
      resolve();
    });
  }

  private handleError(error: any) {
    let errorMessage;
    if (error.status === 0) {
      errorMessage = 'Network connection error';
    } else if (error.status === 400) {
      errorMessage = 'Incorrect information provided';
    } else if (error.status === 401) {
      errorMessage = 'Unauthorized:<br>Incorrect account';
    } else if (error.status === 500) {
      errorMessage = 'Server error';
    } else {
      errorMessage = 'An unknown error occurred';
    }

    return throwError(() => errorMessage);
  }
}
