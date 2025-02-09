import { AsyncPipe, CommonModule } from '@angular/common';
import {
  Component,
  Inject,
  OnInit
} from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import {
  MAT_DIALOG_DATA,
  MatDialogModule,
  MatDialogRef,
} from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { map, Observable, startWith } from 'rxjs';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-edit-album',
  imports: [
    MatDialogModule,
    MatInputModule,
    MatAutocompleteModule,
    ReactiveFormsModule,
    MatSelectModule,
    FormsModule,
    MatFormFieldModule,
    AsyncPipe,
    CommonModule,
  ],
  templateUrl: './edit-album.component.html',
  styleUrl: './edit-album.component.css',
})
export class EditAlbumComponent implements OnInit {
  constructor(
    @Inject(MAT_DIALOG_DATA) public idDetail: any,
    private fb: FormBuilder,
    private commonService: CommonService,
    private dialogRef: MatDialogRef<EditAlbumComponent>
  ) {}

  formEdit!: FormGroup;
  artistForm!: FormGroup;
  submitted = false;
  notSelected = 0;

  artists: any[] = [];
  filteredArtists!: Observable<any[]>;
  selectedArtist: any | undefined;
  artId = this.notSelected;
  data: any;

  ngOnInit(): void {
    this.fetchAndFilterArtists();
    this.formEdit = this.fb.group({
      title: ['', Validators.required],
    });

    this.artistForm = this.fb.group({
      artistGroup: ['', Validators.required],
    });
    if (this.idDetail) {
      this.fetchDetail();
    }
  }

  fetchDetail(): void {
    this.commonService.fetchDataEdit('albums', this.idDetail.id).subscribe({
      next: (data) => {
        if (data) {
          this.data = data;

          this.selectedArtist = this.artists.find(
            (artist) => artist.id === this.data.artistId
          );

          if (this.selectedArtist) {
            this.formEdit.patchValue({
              title: this.data.title || '',
            });

            this.artistForm.patchValue({
              artistGroup: this.selectedArtist.artistName || '',
            });

            this.artId = this.selectedArtist.id;
          } else {
            console.error('Artist not found');
          }
        } else {
          console.error('No data received');
        }
      },
      error: (error) => {
        console.error('Error fetching data:', error);
      },
    });
  }

  onBlurArt(event: any) {
    console.log('Hell: ', event.target.value);
    this.onArtSelected(event.target.value);
  }
  onArtSelected(artistName: string): void {
    this.selectedArtist = this.artists.find(
      (obj) => obj.artistName === artistName
    );
    if (this.selectedArtist) {
      this.artId = this.selectedArtist.id;
    } else {
      this.artId = this.notSelected;
      console.log(this.notSelected);
    }
    // console.log('Selected Art id:', this.artId);
  }

  private fetchAndFilterArtists(): void {
    this.commonService.fetchListData('artists').subscribe((data) => {
      this.artists = data;
      console.log('Artists:', this.artists.toString());

      this.filteredArtists = this.artistForm
        .get('artistGroup')!
        .valueChanges.pipe(
          startWith(''),
          map((value) =>
            this.commonService.filterData(
              'artistName',
              this.artists,
              value || ''
            )
          )
        );
    });
  }

  edit() {
    this.submitted = true;
    if (this.formEdit.invalid) {
      return;
    }
    console.log(this.data);
    console.log('hehehehe');
    console.log(this.data.cateIds);
    const dataEdit = {
      id: this.idDetail.id,
      title: this.formEdit.value.title,
      cateIds: this.data.categoryIds,
      releaseDate: this.data.releaseDate,
      artistId: this.artId,
    };

    this.commonService.editData('albums', dataEdit).subscribe({
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
            if (e.artistId) {
              this.artistForm.controls['artistId'].setErrors({
                backendError: e.artistId,
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
