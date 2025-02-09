import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-subject',
  imports: [],
  templateUrl: './delete-subject.component.html',
  styleUrl: './delete-subject.component.css'
})
export class DeleteSubjectComponent {
constructor(
    @Inject(MAT_DIALOG_DATA) public data: { message: string,name: string},
    public dialogRef: MatDialogRef<DeleteSubjectComponent>
  ) {}

  onNoClick(): void {
    this.dialogRef.close(); 
  }

  onConfirm(): void {
    this.dialogRef.close('confirm'); 
  }
}
