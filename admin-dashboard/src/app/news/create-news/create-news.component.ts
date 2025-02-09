import { Component, OnInit } from '@angular/core';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-create-news',
  templateUrl: './create-news.component.html',
  imports: [ReactiveFormsModule, MatDialogModule, CommonModule],
  styleUrls: ['./create-news.component.css'],
})
export class CreateNewsComponent implements OnInit {
  submitted = false;
  selectedFile: File | null = null;
  imageError: string | null = null;
  formCreateNews!: FormGroup;

  constructor(
    public dialogRef: MatDialogRef<CreateNewsComponent>,
    private formBuilder: FormBuilder,
    private commonService: CommonService,
  ) {}

  ngOnInit(): void {
    this.formCreateNews = this.formBuilder.group({
      title: ['', Validators.required],
      content: ['', Validators.required],
      // image: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreateNews.controls;
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

  createNews() {
    this.submitted = true;
    if (this.selectedFile == null) {
      this.imageError = 'Choose file again!';
      return;
    }
    if (this.formCreateNews.invalid) {
      return;
    }
    this.commonService.uploadImage(this.selectedFile!).subscribe({
      next: (stringNameAvatar: string) => {
        // this.formCreateNews.controls['image'].setValue(stringNameAvatar);
        const formData = {
          ...this.formCreateNews.value,
          isActive: true,
          image: stringNameAvatar
        };
  
        console.log(formData);
  
        this.commonService.create('news',formData).subscribe({
          next: (res) => {
            this.commonService.updateNewsCount();  
            this.dialogRef.close('saved');
          },
          error: (err) => {
            if (Array.isArray(err.errors)) {
              err.errors.forEach((e: any) => {
                if (e.contentError) {
                  this.formCreateNews.controls['content'].setErrors({
                    backendError: e.contentError,
                  });
                }
                if (e.titleError) {
                  this.formCreateNews.controls['title'].setErrors({
                    backendError: e.titleError,
                  });
                }
                // if (e.imageError) {
                //   this.formCreateNews.controls['image'].setErrors({
                //     backendError: e.imageError,
                //   });
                // }
              });
            } else {
              console.error('Error response does not contain expected errors:', err);
            }
          },
        });
      }
    });
  }
  
  
}
