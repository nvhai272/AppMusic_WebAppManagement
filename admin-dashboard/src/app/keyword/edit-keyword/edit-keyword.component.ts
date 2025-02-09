import { Component } from '@angular/core';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-edit-keyword',
  standalone:true,
  imports: [MatDialogModule],
  templateUrl: './edit-keyword.component.html',
  styleUrl: './edit-keyword.component.css'
})
export class EditKeywordComponent {
constructor(public dialogRef: MatDialogRef<EditKeywordComponent>) {}

  saveGenre(): void {
    // Logic để lưu user mới
    console.log('User saved!');
    this.dialogRef.close('saved');
  }
}
