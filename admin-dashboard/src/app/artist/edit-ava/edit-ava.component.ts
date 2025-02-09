import { CommonModule } from '@angular/common';
import { Component, Inject } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-edit-ava',
  imports: [
    MatDialogModule,
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatSelectModule,
    MatFormFieldModule,
  ],
  templateUrl: './edit-ava.component.html',
  styleUrl: './edit-ava.component.css',
})
export class EditAvaComponent {
  submitted = false;
    selectedFile: File | null = null;
    imageError: string | null = null;
  
    constructor(
      @Inject(MAT_DIALOG_DATA) public idDetail: any,
      private commonService: CommonService,
      private dialogRef: MatDialogRef<EditAvaComponent>,
      private toastr: ToastrService
    ) {}
  
    triggerFileInput(): void {
      const fileInput = document.getElementById('imageUpload') as HTMLElement;
      fileInput.click();
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
  
    edit() {
      this.submitted = true;
      if (this.selectedFile == null) {
        this.imageError = 'Choose file required!';
        return;
      }
      if (this.selectedFile && this.imageError == null) {
        this.commonService.uploadImage(this.selectedFile!).subscribe({
          next: (stringNameAvatar: string) => {
            const data = {
              id: this.idDetail.id,
              fileName: stringNameAvatar,
            };
            console.log(data);
            this.commonService.editAvaFile('artists/change/image', data).subscribe({
              next: (response) => {
                console.log('avatar file updated successfully:', response);
                this.toastr.success('', 'updated image file!');
                this.dialogRef.close('saved');
              },
              error: (error) => {
                console.error('Error updating name image:', error);
                this.toastr.error('', 'Error updating name image file!');
              },
            });
          },
          error: (error) => {
            console.error('Error uploading image:', error);
            const errorMessage = error?.message || 'An unexpected error occurred';
            this.toastr.error('', `Error uploading image: ${errorMessage}`);
          },
        });
      }
    }
}
