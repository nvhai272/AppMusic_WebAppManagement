import { Component } from '@angular/core';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { OnInit } from '@angular/core';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { CommonService } from '../../services/common.service';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { ButtonModule } from 'primeng/button';
import { map, Observable, startWith } from 'rxjs';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-create-album',
  standalone: true,
  imports: [
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    ReactiveFormsModule,
    AutoCompleteModule,
    ButtonModule,
    ReactiveFormsModule,
    CommonModule,
  ],
  templateUrl: './create-album.component.html',
  styleUrl: './create-album.component.css',
})
export class CreateAlbumComponent implements OnInit {
  notSelected: number = 0;
  triggerFileInput(): void {
    const fileInput = document.getElementById('imageUpload') as HTMLElement;
    fileInput.click();
  }
  private _formBuilder = new FormBuilder();
  artistForm = this._formBuilder.group({
    artistGroup: ['', Validators.required],
  });

  artists: any[] = [];
  filteredArtists: Observable<any[]> | undefined;
  selectedArtist: any | undefined;
  id: number = 0;
  submitted = false;
  selectedFile: File | null = null;
  imageError: string | null = null;

  formCreateAlbum: FormGroup = new FormGroup({});

  constructor(
    public dialogRef: MatDialogRef<CreateAlbumComponent>,
    private commonService: CommonService,
    private formBuilder: FormBuilder
  ) {}
  ngOnInit() {
    this.commonService.fetchListData('artists').subscribe((data) => {
      this.artists = data;
    });

    this.filteredArtists = this.artistForm
      .get('artistGroup')!
      .valueChanges.pipe(
        startWith(''),
        map((value) =>
          this.commonService.filterData('artistName', this.artists, value || '')
        )
      );
    this.formCreateAlbum = this.formBuilder.group({
      title: ['', Validators.required],
      artistId: ['', Validators.required],
      releaseDate: ['', Validators.required],
      // image: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreateAlbum.controls;
  }

  onFileSelected(event: any): void {
    const file: File = event.target.files[0];
    const validation = this.commonService.validateImage(file);

    if (!validation.valid) {
      this.imageError = validation.error;
      this.selectedFile = null;
    } else {
      this.selectedFile = file;
      this.imageError = null;
    }
  }

  createAlbum() {
    this.submitted = true;
    if (this.selectedFile == null) {
      this.imageError = 'Choose file again!';
      return;
    }
    this.formCreateAlbum.controls['artistId'].setValue(this.id);

    if (this.formCreateAlbum.invalid || this.artistForm.invalid) {
      return;
    }
    console.log(this.id);
    this.commonService.uploadImage(this.selectedFile!).subscribe({
      next: (stringNameImg: string) => {
        //this.formCreateAlbum.controls['image'].setValue(stringNameImg);
        const formData = {
          ...this.formCreateAlbum.value,
          image: stringNameImg,
          cateIds: [],
        };
        console.log(this.id);
        console.log(formData.image);
        console.log(formData);

        this.commonService.create('albums', formData).subscribe({
          next: (res) => {
            this.dialogRef.close('saved');
          },
          error: (err) => {
            if (Array.isArray(err.errors)) {
              err.errors.forEach((e: any) => {
                if (e.artistError) {
                  this.formCreateAlbum.controls['artistId'].setErrors({
                    backendError: e.artistError,
                  });
                }
                if (e.titleError) {
                  this.formCreateAlbum.controls['title'].setErrors({
                    backendError: e.titleError,
                  });
                }

                if (e.imageError) {
                  this.formCreateAlbum.controls['image'].setErrors({
                    backendError: e.imageError,
                  });
                }
              });
            } else {
              console.error(
                'Error response does not contain expected errors:',
                err
              );
            }
          },
        });
      },
    });
  }

  onArtistSelected(artistName: string): void {
    this.selectedArtist = this.artists.find(
      (artist) => artist.artistName === artistName
    );
    if (this.selectedArtist) {
      this.id = this.selectedArtist.id;
      console.log('Selected Artist id:', this.id);
    } else {
      this.id = this.notSelected;
      console.log('Artist not found');
    }
  }

  onBlurDi(event: any) {
    console.log('Hell: ', event.target.value);
    this.onArtistSelected(event.target.value);
  }
}
