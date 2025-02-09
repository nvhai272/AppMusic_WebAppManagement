import { Component, ElementRef, Inject, ViewChild } from '@angular/core';
import {
  MAT_DIALOG_DATA,
  MatDialogModule,
  MatDialogRef,
} from '@angular/material/dialog';
import { OnInit } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { AsyncPipe, CommonModule } from '@angular/common';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-edit-playlist',
  standalone: true,
  imports: [
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    ReactiveFormsModule,CommonModule
  ],
  templateUrl: './edit-playlist.component.html',
  styleUrl: './edit-playlist.component.css',
})
export class EditPlaylistComponent implements OnInit {
  
  formEdit!: FormGroup;
  submitted = false;
  data: any;

  constructor(
    @Inject(MAT_DIALOG_DATA) public idDetail: any,
    public dialogRef: MatDialogRef<EditPlaylistComponent>,
    private fb: FormBuilder,
    private commonService: CommonService
  ) {}
  ngOnInit(): void {
    this.formEdit = this.fb.group({
      title: ['', Validators.required],
    });
    this.fetchDataDetail();
  }

  fetchDataDetail(): void {
    this.commonService
      .fetchDataEdit('playlists', this.idDetail.id)
      .subscribe((data) => {
        this.data = data;
        this.formEdit.patchValue({
          title: data.title || '',
        });
      });
  }

  edit() {
    this.submitted = true;
    if (this.formEdit.invalid) {
      return;
    }

    const song = {
      id: this.idDetail?.id,
      title: this.formEdit.value.title,
      userId: this.data.userId ,
    };

    this.commonService.editData('playlists', song).subscribe({
      next: (res) => {
        this.dialogRef.close('saved');
      },

      error: (err) => {
        if (err.status === 400 && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.title) {
              this.formEdit.controls['title'].setErrors({
                backendError: e.title,
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
}
