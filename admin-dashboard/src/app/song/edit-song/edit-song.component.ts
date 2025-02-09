import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
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
import { map, startWith, switchMap } from 'rxjs/operators';
import { AsyncPipe, CommonModule } from '@angular/common';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-edit-song',
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
  templateUrl: './edit-song.component.html',
  styleUrl: './edit-song.component.css',
})
export class EditSongComponent implements OnInit {
  formCreateSong!: FormGroup;
  artistForm!: FormGroup;
  albumForm!: FormGroup;
  submitted = false;
  notSelected = 0;

  artists: any[] = [];
  filteredArtists!: Observable<any[]>;
  selectedArtist: any | undefined;
  artId = this.notSelected;

  albums: any[] = [];
  filteredAlbums!: Observable<any[]>;
  selectedAlbum: any | undefined;
  albId = this.notSelected;

  selectedGenres: any[] = [];
  genres: any[] = [];
  dataEdit: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public idDetailOfSong: any,
    private fb: FormBuilder,
    private commonService: CommonService,   
    private dialogRef: MatDialogRef<EditSongComponent>
    
  ) {}
  ngOnInit(): void {
   
    this.initializeForms();
    this.loadInitialData(); 
 
    if (this.idDetailOfSong) {
      this.fetchSongDetail(); 
    }
  }
  
  initializeForms(): void {
    this.formCreateSong = this.fb.group({
      title: ['', Validators.required],
      featureArtist: [''],
      genreIds: [[], Validators.required],
    });
  
    this.artistForm = this.fb.group({
      artistGroup: ['', Validators.required],
    });
  
    this.albumForm = this.fb.group({
      albumGroup: ['', Validators.required],
    });
  }
  
  loadInitialData(): void {
    this.fetchAndFilterArtists();
    this.fetchAndFilterAlbums();
    this.fetchGenres();
  }
  
  fetchSongDetail(): void {
    this.commonService
      .fetchDataEdit('songs', this.idDetailOfSong.id)
      .subscribe((data) => {
        this.handleFetchedSongData(data);
      });
  }
  
  handleFetchedSongData(data: any): void {
    this.dataEdit = data;
  
    this.selectedAlbum = this.albums.find(
      (album) => album.id === this.dataEdit.albumId
    );
    this.selectedArtist = this.artists.find(
      (artist) => artist.id === this.dataEdit.artistId
    );
  console.log('art Id:'+this.selectedArtist);
    this.setAlbumFormValues();

    this.setArtistFormValues();
  console.log('art name:'+this.selectedArtist.artistName);

    this.setSongFormValues();
  }
  
  setAlbumFormValues(): void {
    if (this.selectedAlbum) {
      this.albumForm.patchValue({
        albumGroup: this.selectedAlbum.title,
      });
  
      this.albId = this.selectedAlbum.id; // Gán id album vào albId
    }
  }
  
  setArtistFormValues(): void {
    if (this.selectedArtist) {
      this.artistForm.patchValue({
        artistGroup: this.selectedArtist.artistName,
      });
  
      this.artId = this.selectedArtist.id; // Gán id nghệ sĩ vào artId
    }
  }
  
  setSongFormValues(): void {
    this.selectedGenres = Array.isArray(this.dataEdit.genreIds)
      ? this.dataEdit.genreIds
      : [];
  
    this.formCreateSong.patchValue({
      title: this.dataEdit.title || '',
      featureArtist: this.dataEdit.featureArtist || '',
      genreIds: this.selectedGenres,
    });
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

  private fetchAndFilterAlbums(): void {
    this.commonService.fetchListData('albums').subscribe((data) => {
      this.albums = data;
      console.log('Albums:', this.albums);

      this.filteredAlbums = this.albumForm.get('albumGroup')!.valueChanges.pipe(
        startWith(''),
        map((value) =>
          this.commonService.filterData('title', this.albums, value || '')
        )
      );
    });
  }

  private fetchGenres(): void {
    this.commonService.fetchListData('genres').subscribe((data) => {
      this.genres = data;
      console.log('Genres:', this.genres);
    });
  }
  // onGenresSelected(event: any): void {
  //   this.selectedGenres = event.value;
  // }

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

  onBlurAlb(event: any) {
    console.log('Hell: ', event.target.value);
    this.onAlbumSelected(event.target.value);
  }
  onAlbumSelected(title: string): void {
    this.selectedAlbum = this.albums.find((obj) => obj.title === title);
    if (this.selectedAlbum) {
      this.albId = this.selectedAlbum.id;
    } else {
      this.albId = this.notSelected;
      console.log(this.notSelected);
    }

    // console.log('Selected albId id:', this.albId);
  }

  editSong() {
    this.submitted = true;
    if (this.formCreateSong.invalid) {
      return;
    }

    const song = {
      id: this.idDetailOfSong?.id,
      title: this.formCreateSong.value.title,
      artistId: this.artId,
      albumId: this.albId,
      featureArtist: this.formCreateSong.value.featureArtist,
      genreIds: this.formCreateSong.value.genreIds,
      listenAmount: this.dataEdit.listenAmount
    };

    this.commonService.editData('songs', song).subscribe({
      next: (res) => {
        this.dialogRef.close('saved');
        console.log('Song created successfully:', res);
      },

      error: (err) => {
        if (err.status === 400 && Array.isArray(err.errors)) {
          err.errors.forEach((e: any) => {
            if (e.title) {
              this.formCreateSong.controls['title'].setErrors({
                backendError: e.title,
              });
            }
            if (e.genreIds) {
              this.formCreateSong.controls['genreIds'].setErrors({
                backendError: e.genreIds,
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
