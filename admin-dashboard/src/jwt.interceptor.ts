import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse,
} from '@angular/common/http';
import { Router } from '@angular/router';
import { catchError, Observable, throwError } from 'rxjs';
import { ToastrService } from 'ngx-toastr';

@Injectable({
  providedIn: 'root',
})
export class JwtInterceptor implements HttpInterceptor {
  constructor(private router: Router, private toastr: ToastrService) {}

  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    const token = localStorage.getItem('authToken');
    if (token) {
      console.log('Interceptor: Token found, adding to request header'); 
      console.log(token);
      req = req.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`,
        },
      });
    }else{
      console.log('Interceptor: No token found');
    }

    return next.handle(req).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401) {
          this.toastr.error(
            'Token is invalid or expired. Please log in again.',
            'Unauthorized',
            {
              timeOut: 3000,
            }
          );

          this.router.navigate(['/login']);
          
          return throwError(() => new Error('Unauthorized - Token expired or invalid'));
        }

        this.toastr.error(
          error.message || 'An unknown error occurred',
          'Error',
          {
            timeOut: 3000,
          }
        );

        return throwError(() => error); 
      })
    );
  }
}
