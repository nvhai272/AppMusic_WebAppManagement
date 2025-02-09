import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, map, Observable, throwError } from 'rxjs';
import { CommonService } from './common.service';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient,private commonService : CommonService) {}

  createUser(userData: any): Observable<any> {

    const baseUrl = this.commonService.getBaseUrl(); 

    return this.http.post<any>(`${baseUrl}/registerForAdmin`, userData).pipe(
      catchError((err) => {
        return throwError(() => ({
          status: err.status,
          errors: err.error?.listError || [],
        }));
      })
    );
  }

  detailUser(userId: number): Observable<any> {
    const baseUrl = this.commonService.getBaseUrl(); 
    
    return this.http.get<any>(`${baseUrl}/public/users/${userId}`).pipe(
      catchError((err) => {
        return throwError(() => ({
          status: err.status,
          errors: err.error?.listError || [],
        }));
      })
    );
  }
}
