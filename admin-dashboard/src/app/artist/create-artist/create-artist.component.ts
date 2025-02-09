import { CommonModule } from '@angular/common';
import { Component, ElementRef, ViewChild } from '@angular/core';
import {
  AbstractControl,
  FormBuilder,
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-create-artist',
  standalone: true,
  imports: [MatDialogModule, ReactiveFormsModule, CommonModule],
  templateUrl: './create-artist.component.html',
  styleUrl: './create-artist.component.css',
})
export class CreateArtistComponent {
  triggerFileInput(): void {
    const fileInput = document.getElementById('imageUpload') as HTMLElement;
    fileInput.click();
  }
  constructor(
    public dialogRef: MatDialogRef<CreateArtistComponent>,
    private formBuilder: FormBuilder,
    private commonService: CommonService
  ) {}

  submitted = false;
  selectedFile: File | null = null;
  imageError: string | null = null;
  formCreateArt: FormGroup = new FormGroup({});

  ngOnInit(): void {
    this.formCreateArt = this.formBuilder.group({
      artistName: ['', Validators.required],
      bio: ['', Validators.required],
      // image: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreateArt.controls;
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

  createArt() {
    this.submitted = true;
    if (this.selectedFile == null) {
      this.imageError = 'Choose file again!';
      return;
    }

    if (this.formCreateArt.invalid) {
      return;
    }
    this.commonService.uploadImage(this.selectedFile!).subscribe({
      next: (stringNameImg: string) => {
        
        // this.formCreateArt.controls['image'].setValue(stringNameImg);

        const formData = {
          image: stringNameImg,
          ...this.formCreateArt.value
         
        };

        console.log('show'+formData);

        this.commonService.create('artists', formData).subscribe({
          next: (res) => {
            this.dialogRef.close('saved');
          },
          error: (err) => {
            console.log(err.errors);
            if (err && err.errors && Array.isArray(err.errors)) {
              err.errors.forEach((e: any) => {
                if (e.artistNameError) {
                  this.formCreateArt.controls['artistName'].setErrors({
                    backendError: e.artistNameError,
                  });
                }
                if (e.bioError) {
                  this.formCreateArt.controls['bio'].setErrors({
                    backendError: e.bioError,
                  });
                }
                // if (e.imageError) {
                //   this.formCreateArt.controls['image'].setErrors({
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
