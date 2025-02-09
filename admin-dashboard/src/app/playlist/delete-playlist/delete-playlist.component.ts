import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-playlist',
  imports: [],
  templateUrl: './delete-playlist.component.html',
  styleUrl: './delete-playlist.component.css'
})
export class DeletePlaylistComponent {
constructor(
    @Inject(MAT_DIALOG_DATA) public data: { message: string,name: string},
    public dialogRef: MatDialogRef<DeletePlaylistComponent>
  ) {}

  onNoClick(): void {
    this.dialogRef.close(); 
  }

  onConfirm(): void {
    this.dialogRef.close('confirm'); 
  }
}
