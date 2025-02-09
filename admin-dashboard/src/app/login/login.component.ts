import { CommonModule } from '@angular/common';
import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import {
  AbstractControl,
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { AuthService } from '../services/auth.service';
import { Subscription, interval } from 'rxjs';
import { jwtDecode } from 'jwt-decode';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  currentYear = new Date().getFullYear();
  submitted = false;
  private authCheckSubscription: Subscription | undefined;
  formLogin!: FormGroup ;

  constructor(
    private toastr: ToastrService,
    private router: Router,
    private formBuilder: FormBuilder,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/dashboard']);
    } else {
      this.router.navigate(['/login']);
    }

    this.authCheckSubscription = interval(60000 * 10).subscribe(() => {
      if (!this.authService.isAuthenticated()) {
        this.authService.logout().then(() => {
           this.toastr.info('Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.');
           alert('Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.');
          this.router.navigate(['/login']);
        });
      }
    });

    this.formLogin = this.formBuilder.group({
      username: ['', [Validators.required, Validators.minLength(5)]],
      password: ['', [Validators.required, Validators.minLength(8)]],
    });
  }

  ngOnDestroy(): void {
    // Hủy subscription khi component bị hủy
    if (this.authCheckSubscription) {
      this.authCheckSubscription.unsubscribe();
    }
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formLogin.controls;
  }

  onLogin() {
    this.submitted = true;
    if (this.formLogin.invalid) {
      return;
    }
    const formData = this.formLogin.value;
    this.authService.login(formData.username, formData.password).subscribe({
      next: (response) => {
        const decodedToken: any = jwtDecode(response.token);

        const id = decodedToken.id;
        const fullName = decodedToken.fullName;
        const role = decodedToken.role;
        const exp = decodedToken.exp;
        const username = decodedToken.sub;

        const user:any = {
          id: id,
          fullName: fullName,
          role: role,
          username: username
        };
        if (!this.authService.checkRoll(role)) {
          this.toastr.warning('Account without permission!');
          return;
        }
        this.authService.saveTokenAndUserInfo(response.token, user, exp);
        if(role==='ROLE_ADMIN'){
          this.router.navigate(['/dashboard']);
          this.toastr.info('Hello, Admin<br>'+fullName);
        }
        else{
          this.router.navigate(['/art-overview']);
          this.toastr.info('Hello, Artist<br>'+fullName);
        }
       
      },
      error: (error) => {
        this.toastr.error(error);
      },
      complete: () => {
        console.log('Login attempt completed');
      },
    });
  }
}
