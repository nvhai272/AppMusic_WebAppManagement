import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-artist',
  imports: [],
  templateUrl: './delete-artist.component.html',
  styleUrl: './delete-artist.component.css'
})
export class DeleteArtistComponent {
constructor(
    @Inject(MAT_DIALOG_DATA) public data: { message: string,name: string},
    public dialogRef: MatDialogRef<DeleteArtistComponent>
  ) {}

  onNoClick(): void {
    this.dialogRef.close(); 
  }

  onConfirm(): void {
    this.dialogRef.close('confirm'); 
  }
}
