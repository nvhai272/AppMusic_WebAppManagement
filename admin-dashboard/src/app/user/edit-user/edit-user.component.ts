import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import {
  ActivatedRoute,
  Router,
  RouterLink,
  RouterModule,
  RouterOutlet,
} from '@angular/router';
import { CommonModule } from '@angular/common';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-edit-user',
  standalone: true,
  imports: [
    NavbarComponent,
    FooterComponent,
    CommonModule,
    FormsModule,
    SidebarComponent,
    ReactiveFormsModule,
  ],
  templateUrl: './edit-user.component.html',
  styleUrl: './edit-user.component.css',
})
export class EditUserComponent implements OnInit {
  formEditUser: FormGroup | any;
  user: any;
  submitted = false;

  constructor(
    private formBuilder: FormBuilder,
    private commonService: CommonService,
    private route: ActivatedRoute,
    private router: Router,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {
    const userState = history.state.user;
    if (!userState) {
      console.log('Không có dữ liệu từ trang detail user');
      return;
    }
    this.user = userState;
    const userId = this.route.snapshot.paramMap.get('id');

    this.formEditUser = this.formBuilder.group({
      username: [
        this.user.username,
        [Validators.required, Validators.minLength(8)],
      ],
      fullName: [this.user.fullName, Validators.required],
      phone: [
        this.user.phone,
        [Validators.required, Validators.pattern(/^\d{10,11}$/)],
      ],
      email: [this.user.email, [Validators.required, Validators.email]],
      dob: [this.user.dob, Validators.required],
      role: [this.user.role, Validators.required],
    });
  }

  get f() {
    return this.formEditUser!.controls;
  }

  editUser(): void {
    this.submitted = true;
    if (this.formEditUser!.invalid) {
      console.log("Please");
      return;
    }

    const updatedUser = {
      ...this.formEditUser!.value,
      id: this.user.id,
      password: '',
    };

    this.commonService.updateData(updatedUser).subscribe({
      next: (res) => {
        this.router.navigate(['/users']);
        this.toastr.success('', 'edit user success!');
      },

      error: (err) => {
        //  console.log('Error creating user:', JSON.stringify(err.errors, null, 2));

        if (err.status === 400 && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.usernameError) {
              this.formEditUser.controls['username'].setErrors({
                backendError: e.usernameError,
              });
            }
            if (e.phoneError) {
              this.formEditUser.controls['phone'].setErrors({
                backendError: e.phoneError,
              });
            }
            if (e.emailError) {
              this.formEditUser.controls['email'].setErrors({
                backendError: e.emailError,
              });
            }
            // if (e.passwordError) {
            //   this.formEditUser.controls['password'].setErrors({
            //     backendError: e.passwordError,
            //   });
            // }
          });
        }
      },
    });
  }
}
