import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-keyword',
  imports: [],
  templateUrl: './delete-keyword.component.html',
  styleUrl: './delete-keyword.component.css'
})
export class DeleteKeywordComponent {
constructor(
    @Inject(MAT_DIALOG_DATA) public data: { message: string,name: string},
    public dialogRef: MatDialogRef<DeleteKeywordComponent>
  ) {}

  onNoClick(): void {
    this.dialogRef.close(); 
  }

  onConfirm(): void {
    this.dialogRef.close('confirm'); 
  }
}
