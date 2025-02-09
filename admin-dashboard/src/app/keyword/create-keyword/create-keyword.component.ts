import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';

@Component({
  selector: 'app-create-keyword',
  standalone: true,
  imports: [MatDialogModule, ReactiveFormsModule, CommonModule],
  templateUrl: './create-keyword.component.html',
  styleUrl: './create-keyword.component.css'
})
export class CreateKeywordComponent {
  keywordForm: FormGroup;
  isSubmitted = false;
  constructor(
    public dialogRef: MatDialogRef<CreateKeywordComponent>,
    private fb: FormBuilder,
    private commonService: CommonService 
  ) 
  {
    this.keywordForm = this.fb.group({
      content: ['', Validators.required]
    });
  }

  async saveKeyword(): Promise<void> {
    this.isSubmitted = true;
    if (this.keywordForm.valid) {
      const keyword = {
        ...this.keywordForm.value,
        'isActive': true
      };
  
      try {
        const response = await lastValueFrom(this.commonService.create('keywords', keyword));
        this.dialogRef.close('saved');

      } catch (err: any) {
        if (err.status === 400 && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.contentError) {
              this.keywordForm.controls['content'].setErrors({
                backendError: e.contentError
              });
            };

          });
        } else {
          console.error('Error creating keyword:', err);
        }
      }
    } else {
      this.keywordForm.markAllAsTouched();
    }
  }
  
  
}
