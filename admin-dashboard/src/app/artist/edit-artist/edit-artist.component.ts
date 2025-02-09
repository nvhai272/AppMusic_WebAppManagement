import {
  Component,
  ElementRef,
  Inject,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import {
  MAT_DIALOG_DATA,
  MatDialogModule,
  MatDialogRef,
} from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-edit-artist',
  standalone: true,
  imports: [MatDialogModule,
    CommonModule,ReactiveFormsModule
  ],
  templateUrl: './edit-artist.component.html',
  styleUrl: './edit-artist.component.css',
})
export class EditArtistComponent implements OnInit {
  edit() {
    this.submitted = true;
    if (this.formEdit.invalid) {
      return;
    }
    const dataEdit = {
      id: this.idDetail.id,
      bio: this.formEdit.value.bio,
      artistName: this.formEdit.value.artistName
    };

    this.commonService.editData('artists', dataEdit).subscribe({
      next: (res) => {
        this.dialogRef.close('saved');
      },

      error: (err) => {
        if (err.status === 400 && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.bio) {
              this.formEdit.controls['bio'].setErrors({
                backendError: e.bio,
              });
            }
            if (e.artistName) {
              this.formEdit.controls['artistName'].setErrors({
                backendError: e.artistName,
              });
            }
            // if (e.emailError) {
            //   this.formCreateSong.controls['email'].setErrors({
            //     backendError: e.emailError,
            //   });
            // }
            // if (e.passwordError) {
            //   this.formCreateSong.controls['password'].setErrors({
            //     backendError: e.passwordError
            //   });
            // }
          });
        }
      },
    });
  
  }
  formEdit!: FormGroup;
  submitted = false;
  data: any;

  constructor(
    @Inject(MAT_DIALOG_DATA) public idDetail: any,
    public dialogRef: MatDialogRef<EditArtistComponent>,
    private fb: FormBuilder,
    private commonService: CommonService
  ) {}

  ngOnInit(): void {
    this.formEdit = this.fb.group({
      bio: ['', Validators.required],
      artistName: ['', Validators.required],
    });
    this.fetchDataDetail();
  }

  fetchDataDetail(): void {
    this.commonService
      .fetchDataEdit('artists', this.idDetail.id)
      .subscribe((data) => {
        this.data = data;
        this.formEdit.patchValue({
          bio: data.bio || '',
          artistName: data.artistName || '',
        });
      });
  }
}
