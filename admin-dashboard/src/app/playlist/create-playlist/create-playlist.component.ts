import { Component, ElementRef, ViewChild } from '@angular/core';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { OnInit } from '@angular/core';
import {
  AbstractControl,
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
import { CreateAlbumComponent } from '../../album/create-album/create-album.component';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-create-playlist',
  standalone: true,
  imports: [
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    ReactiveFormsModule,
    CommonModule,
  ],
  templateUrl: './create-playlist.component.html',
  styleUrl: './create-playlist.component.css',
})
export class CreatePlaylistComponent implements OnInit {

  private _formBuilder = new FormBuilder();
  userForm = this._formBuilder.group({
    userGroup: ['', Validators.required],
  });

  users: any[] = [];
  filteredUsers: Observable<any[]> | undefined;
  selectedUser: any | undefined;
  notSelected = 0;
  id = this.notSelected;
  submitted = false;

  formCreatePlaylist: FormGroup = new FormGroup({
  });

  constructor(
    public dialogRef: MatDialogRef<CreateAlbumComponent>,
    private commonService: CommonService,
    private formBuilder: FormBuilder
  ) {}
  ngOnInit() {
    this.commonService.fetchListData('users').subscribe((data) => {
      this.users = data;
      console.log(this.users);
    });

    this.filteredUsers = this.userForm.get('userGroup')!.valueChanges.pipe(
      startWith(''),
      map((value) =>
        this.commonService.filterData('username', this.users, value || '')
      )
    );
    this.formCreatePlaylist = this.formBuilder.group({
      title: ['', Validators.required],
      userId: ['', Validators.required],
    });
  }

  get f(): { [key: string]: AbstractControl } {
    return this.formCreatePlaylist.controls;
  }

  createPlaylist() {
    this.submitted = true;

    this.formCreatePlaylist.controls['userId'].setValue(this.id);

    if (this.formCreatePlaylist.invalid || this.userForm.invalid) {
      return;
    }
    console.log(this.id);

    this.commonService
      .create('playlists', this.formCreatePlaylist.value)
      .subscribe({
        next: (res) => {
          this.dialogRef.close('saved');
        },
        error: (err) => {
          if (Array.isArray(err.errors)) {
            err.errors.forEach((e: any) => {
              if (e.userError) {
                this.formCreatePlaylist.controls['userId'].setErrors({
                  backendError: e.userError,
                });
              }
              if (e.titleError) {
                this.formCreatePlaylist.controls['title'].setErrors({
                  backendError: e.titleError,
                });
              }
            });
          } 
        },
      });
  }

  onBlueDi(event: any){
    console.log('Hell: ', event.target.value);
    this.onUserSelected(event.target.value);
  }
    onUserSelected(username: string): void {
    this.selectedUser = this.users.find((user) => user.username === username);
    if (this.selectedUser) {
      this.id = this.selectedUser.id;
    } else{
      this.id = this.notSelected;
      console.log(this.notSelected);
    }

    console.log('Selected User id:', this.id);
  }
}
