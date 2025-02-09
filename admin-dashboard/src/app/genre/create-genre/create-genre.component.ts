import { Component } from '@angular/core';

import {
  AbstractControl,
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators,FormsModule
} from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-create-genre',
  imports: [MatDialogModule, ReactiveFormsModule, CommonModule,FormsModule],
  templateUrl: './create-genre.component.html',
  styleUrl: './create-genre.component.css',
})
export class CreateGenreComponent {
  selectedColor: string = '';
  errColor: string = 'Select color is required';
  triggerFileInput(): void {
    const fileInput = document.getElementById('imageUpload') as HTMLElement;
    fileInput.click();
  }
  constructor(
    public dialogRef: MatDialogRef<CreateGenreComponent>,
    private formBuilder: FormBuilder,
    private commonService: CommonService
  ) {}

  submitted = false;
  selectedFile: File | null = null;
  imageError: string | null = null;

  formCreateGenre: FormGroup = new FormGroup({});

  ngOnInit(): void {
    this.formCreateGenre = this.formBuilder.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      // image: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreateGenre.controls;
  }

  onFileSelected(event: any): void {
    const file: File = event.target.files[0];
    const validation = this.commonService.validateImage(file);

    if (!validation.valid) {
      this.imageError = validation.error;
      this.selectedFile = null;
    } else {
      this.selectedFile = file;
      this.imageError = null;
    }
  }

  createGenre() {
    this.submitted = true;
    if (this.selectedFile == null) {
      this.imageError = 'Choose file again!';
      return;
    }
    if (this.formCreateGenre.invalid) {
      return;
    }
    if (this.selectedColor === '') {
      console.log(this.selectedColor);
      return;  
    }
    this.commonService.uploadImage(this.selectedFile!).subscribe({
      next: (stringNameImg: string) => {
        // this.formCreateGenre.controls['image'].setValue(stringNameImg);

        
        const formData = {
          ...this.formCreateGenre.value,
          colorId: this.selectedColor,
          image: stringNameImg
        };

        console.log(formData);

        this.commonService.create('genres', formData).subscribe({
          next: (res) => {
            this.dialogRef.close('saved');
          },
          error: (err) => {
            console.log(err.errors);
            if (err && err.errors && Array.isArray(err.errors)) {
              err.errors.forEach((e: any) => {
                if (e.descriptionError) {
                  this.formCreateGenre.controls['description'].setErrors({
                    backendError: e.descriptionError,
                  });
                }
                if (e.titleError) {
                  this.formCreateGenre.controls['title'].setErrors({
                    backendError: e.titleError,
                  });
                }
                // if (e.imageError) {
                //   this.formCreateGenre.controls['image'].setErrors({
                //     backendError: e.imageError,
                //   });
                // }
              });
            } else {
              console.error(
                'Error response does not contain expected errors:',
                err
              );
            }
          },
        });
      },
    });
  }
}
