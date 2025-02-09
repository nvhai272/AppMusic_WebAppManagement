import { Component, ElementRef, ViewChild } from '@angular/core';
import { MatDialogRef,MatDialogModule  } from '@angular/material/dialog';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-edit-subject',
  standalone: true,
  imports: [MatDialogModule,RouterLink
  ],
  templateUrl: './edit-subject.component.html',
  styleUrl: './edit-subject.component.css'
})
export class EditSubjectComponent {
  constructor(public dialogRef: MatDialogRef<EditSubjectComponent>) {}

  saveSubject(): void {
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
