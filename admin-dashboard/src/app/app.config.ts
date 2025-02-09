import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideToastr } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, provideHttpClient } from '@angular/common/http';
import { JwtInterceptor } from '../jwt.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideAnimationsAsync(),
    provideToastr({
      enableHtml: true,
      closeButton: true,
      positionClass: 'toast-top-left',
      timeOut: 3000,
      easeTime: 300,
      progressBar: true,
    }),
    provideHttpClient(),
    {
      provide: HTTP_INTERCEPTORS, // Cung cấp interceptor
      useClass: JwtInterceptor, // Sử dụng JwtInterceptor
      multi: true, // Cho phép thêm nhiều interceptor
    },
  ],
};
