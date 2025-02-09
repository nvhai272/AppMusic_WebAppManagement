import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { Component, ElementRef, ViewChild } from '@angular/core';
@Component({
  selector: 'app-edit-news',
  imports: [MatDialogModule],
  templateUrl: './edit-news.component.html',
  styleUrl: './edit-news.component.css'
})
export class EditNewsComponent {
constructor(public dialogRef: MatDialogRef<EditNewsComponent>) {}

  saveGenre(): void {
    // Logic để lưu user mới
    console.log('User saved!');
    this.dialogRef.close('saved');
  }


  // xu li anh tai len
    @ViewChild('fileInput', { static: false }) fileInput!: ElementRef;
    selectedFile: File | null = null;
    previewUrl: string | null = null;
    imageError: boolean = false;
  
    // Kích hoạt file input
    triggerFileInput(): void {
      const fileInput = document.getElementById('imageUpload') as HTMLElement;
      fileInput.click();
    }
  
    // Xử lý file được chọn
    onFileSelected(event: Event): void {
      const input = event.target as HTMLInputElement;
  
      if (input.files && input.files[0]) {
        const file = input.files[0];
  
        if (file.type.startsWith('image/')) {
          this.selectedFile = file;
          this.imageError = false;
  
          // Tạo URL xem trước
          const reader = new FileReader();
          reader.onload = (e: ProgressEvent<FileReader>) => {
            this.previewUrl = e.target?.result as string;
          };
          reader.readAsDataURL(file);
        } else {
          this.imageError = true;
          this.previewUrl = null;
          alert('Please select a valid image file.');
        }
      } else {
        this.imageError = true;
        this.previewUrl = null;
      }
    }
}
