import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';

@Component({
  selector: 'app-create-subject',
  imports: [MatDialogModule, CommonModule, ReactiveFormsModule],
  standalone: true,
  templateUrl: './create-subject.component.html',
  styleUrl: './create-subject.component.css',
})
export class CreateSubjectComponent {
  formCreateCategory!: FormGroup;

  constructor(
    public dialogRef: MatDialogRef<CreateSubjectComponent>,
    private formBuilder: FormBuilder,
    private commonService: CommonService
  ) {}

  submitted = false;

  ngOnInit(): void {
    this.formCreateCategory = this.formBuilder.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreateCategory.controls;
  }

  createCategory() {
    this.submitted = true;

    if (this.formCreateCategory.invalid) {
      return;
    }

    const formData = {
      ...this.formCreateCategory.value,
    };

    console.log(formData);

    this.commonService.create('categories', formData).subscribe({
      next: (res) => {
        this.dialogRef.close('saved');
      },
      error: (err) => {
        console.log(err.errors);
        if (err && err.errors && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.descriptionError) {
              this.formCreateCategory.controls['description'].setErrors({
                backendError: e.descriptionError,
              });
            }
            if (e.titleError) {
              this.formCreateCategory.controls['title'].setErrors({
                backendError: e.titleError,
              });
            }
          });
        } else {
          console.error(
            'Error response does not contain expected errors:',
            err
          );
        }
      },
    });
  }
}
