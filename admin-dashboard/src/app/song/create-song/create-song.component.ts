import { Component, ElementRef, ViewChild } from '@angular/core';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { OnInit } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { forkJoin, Observable, Subscribable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { AsyncPipe, CommonModule } from '@angular/common';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-create-song',
  standalone: true,
  imports: [
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    ReactiveFormsModule,
    AsyncPipe,
    CommonModule,
    MatSelectModule,
  ],
  templateUrl: './create-song.component.html',
  styleUrl: './create-song.component.css',
})
export class CreateSongComponent implements OnInit {
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

  genres: any[] = [];
  fileAudioError: string | null = null;
  fileLrcError: string | null = null;

  selectedLrcFile: File | null = null;
  selectedAudioFile: File | null = null;
  // selectedGenres: any[] = [];

  constructor(
    private commonService: CommonService,
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<CreateSongComponent>
  ) {}

  ngOnInit(): void {
    console.log('Component has initialized!');
    this.formCreateSong = this.fb.group({
      title: ['', Validators.required],
      featureArtist: [''],
      genreIds: [[], Validators.required],
      // audioFile: ['', Validators.required],
      // lrcFile: ['', Validators.required],
    });

    this.artistForm = this.fb.group({
      artistGroup: ['', Validators.required],
    });

    // this.albumForm = this.fb.group({
    //   albumGroup: ['', Validators.required],
    // });

    this.fetchAndFilterArtists();
    // this.fetchAndFilterAlbums();
    this.fetchGenres();
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

  // private fetchAndFilterAlbums(): void {
  //   this.commonService.fetchListData('albums').subscribe((data) => {
  //     this.albums = data;
  //     console.log('Albums:', this.albums);

  //     this.filteredAlbums = this.albumForm.get('albumGroup')!.valueChanges.pipe(
  //       startWith(''),
  //       map((value) =>
  //         this.commonService.filterData('title', this.albums, value || '')
  //       )
  //     );
  //   });
  // }

  private fetchGenres(): void {
    this.commonService.fetchListData('genres').subscribe((data) => {
      this.genres = data;
      console.log('Genres:', this.genres);
    });
  }
  // onGenresSelected(event: any): void {
  //   this.selectedGenres = event.value;
  // }

  // createSong() {
  //   this.submitted = true;
  //   console.log('oke');

  //   if (this.selectedAudioFile == null) {
  //     this.fileAudioError = 'Choose audio file again!';
  //     return;
  //   }
  //   if (this.selectedLrcFile == null) {
  //     this.fileLrcError = 'Choose LRC file again!';
  //     return;
  //   }
  //   console.log('oke');

  //   if (this.formCreateSong.invalid || this.artistForm) {
  //     return;
  //   }
  //   console.log('oke');

  //   if (this.selectedAudioFile && this.selectedLrcFile) {
  //     forkJoin({
  //       audioUpload: this.commonService.uploadFileAudio(this.selectedAudioFile),
  //       lrcUpload: this.commonService.uploadFileLrc(this.selectedLrcFile),
  //     }).subscribe({
  //       next: (response) => {
  //         console.log('Audio Upload Response:', response.audioUpload);
  //         console.log('Lrc Upload Response:', response.lrcUpload);

  //         const formData = {
  //           title: this.formCreateSong.get('title')?.value,
  //           genreIds: this.formCreateSong.get('genreIds')?.value,
  //           featureArtist: this.formCreateSong.get('featureArtist')?.value,
  //           audioPath: response.audioUpload,
  //           lyricFilePath: response.lrcUpload,
  //           artistId: this.artId,
  //         };
  //         console.log('Form Data:', formData);

  //         this.commonService.create('songs', formData).subscribe({
  //           next: (res) => {
  //             console.log('Song created successfully:', res);
  //           },
  //         });
  //       },
  //       error: (err) => {
  //         if (Array.isArray(err.errors)) {
  //           err.errors.forEach((e: any) => {
  //             if (e.featureArtist) {
  //               this.formCreateSong.controls['featureArtist'].setErrors({
  //                 backendError: e.featureArtist,
  //               });
  //             }
  //             if (e.title) {
  //               this.formCreateSong.controls['title'].setErrors({
  //                 backendError: e.title,
  //               });
  //             }
  //             if (e.artistId) {
  //               this.formCreateSong.controls['artistId'].setErrors({
  //                 backendError: e.artistId,
  //               });
  //             }
  //             if (e.genreIds) {
  //               this.formCreateSong.controls['genreIds'].setErrors({
  //                 backendError: e.genreIds,
  //               });
  //             }
  //           });
  //         }
  //       },
  //       complete: () => {
  //         // Thực hiện khi cả hai yêu cầu tải lên hoàn thành
  //         console.log('Both files uploaded successfully!');
  //       },
  //     });
  //   }
  // }

  createSong() {
    this.submitted = true;
    if (this.selectedAudioFile == null) {
      return;
    }
    if (this.selectedLrcFile == null) {
      return;
    }

    if (this.formCreateSong.invalid || this.artistForm.invalid) {
      return;
    }

    if (this.selectedAudioFile && this.selectedLrcFile) {
      forkJoin({
        audioUpload: this.commonService.uploadFileAudio(this.selectedAudioFile),
        lrcUpload: this.commonService.uploadFileLrc(this.selectedLrcFile),
      }).subscribe({
        next: (response) => {
          console.log('Audio Upload Response:', response.audioUpload);
          console.log('Lrc Upload Response:', response.lrcUpload);

          const formData = {
            title: this.formCreateSong.get('title')?.value,
            genreIds: this.formCreateSong.get('genreIds')?.value,
            featureArtist: this.formCreateSong.get('featureArtist')?.value,
            audioPath: response.audioUpload,
            lyricFilePath: response.lrcUpload,
            artistId: this.artId,
          };
          console.log('Form Data:', formData);

          this.commonService.create('songs', formData).subscribe({
            next: (res) => {
              this.dialogRef.close('saved');

              console.log('Song created successfully:', res);
            },
            error: (err) => {
              console.log('Error creating song:', err);
            
            },
          });
        },
        error: (err) => {
          console.log('Error in file uploads:', err);
        },
      });
    }
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

    console.log('Selected Art id:', this.artId);
  }

  // onBlurAlb(event: any){
  //   console.log('Hell: ', event.target.value);
  //   this.onAlbumSelected(event.target.value);
  // }
  // onAlbumSelected(title: string): void {
  //   this.selectedAlbum = this.albums.find((obj) => obj.title === title);
  //   if (this.selectedAlbum) {
  //     this.albId = this.selectedAlbum.id;
  //   } else{
  //     this.albId = this.notSelected;
  //     console.log(this.notSelected);
  //   }

  //   console.log('Selected albId id:', this.albId);
  // }

  triggerFileInput(fileType: string) {
    const fileInput = document.getElementById(fileType) as HTMLInputElement;
    fileInput?.click();
  }
  onFileSelectedAudio(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input?.files) {
      const file = input.files[0];
      const validation = this.commonService.validateFile(file);

      if (!validation.valid) {
        this.fileAudioError = validation.error;
        this.selectedAudioFile = null;
      } else {
        this.selectedAudioFile = file;
        this.fileAudioError = null;
      }
    }
  }
  onFileSelectedLrc(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input?.files) {
      const file = input.files[0];
      const validation = this.commonService.validateFileLrc(file);

      if (!validation.valid) {
        this.fileLrcError = validation.error;
        this.selectedLrcFile = null;
      } else {
        this.selectedLrcFile = file;
        this.fileLrcError = null;
      }
    }
  }
}
