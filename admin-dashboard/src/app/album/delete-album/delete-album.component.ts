import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-album',
  imports: [],
  templateUrl: './delete-album.component.html',
  styleUrl: './delete-album.component.css'
})
export class DeleteAlbumComponent {
constructor(
    @Inject(MAT_DIALOG_DATA) public data: { message: string,name: string},
    public dialogRef: MatDialogRef<DeleteAlbumComponent>
  ) {}

  onNoClick(): void {
    this.dialogRef.close(); 
  }

  onConfirm(): void {
    this.dialogRef.close('confirm'); 
  }
}
