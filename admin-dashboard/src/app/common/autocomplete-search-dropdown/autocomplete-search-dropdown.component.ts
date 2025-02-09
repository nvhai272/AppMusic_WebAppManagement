import { AsyncPipe, CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { map, Observable, startWith } from 'rxjs';
import { CommonService } from '../../services/common.service';

// export const _filter = (
//   opt: { id: number; artistName: string }[],
//   value: string
// ): { id: number; artistName: string }[] => {
//   return opt.filter((item) =>
//     item.artistName.toLowerCase().includes(value.toLowerCase())
//   );
// };

@Component({
  selector: 'app-autocomplete-search-dropdown',
  standalone: true,
  imports: [
    FormsModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    AsyncPipe,
    CommonModule,
  ],
  templateUrl: './autocomplete-search-dropdown.component.html',
  styleUrl: './autocomplete-search-dropdown.component.css',
})
export class AutocompleteSearchDropdownComponent implements OnInit {
  private _formBuilder = new FormBuilder();
  artistForm = this._formBuilder.group({
    artistGroup: '',
  });

  artists: any[] = [];
  filteredArtists: Observable<any[]> | undefined;
  selectedArtist: any | undefined;

  constructor(private commonService: CommonService) {}
  ngOnInit() {
    this.commonService.fetchListData('artists').subscribe((data) => {
      this.artists = data;
    });

    this.filteredArtists = this.artistForm
      .get('artistGroup')!
      .valueChanges.pipe(
        startWith(''),
        map((value) => this._filterArtists(value || ''))
      );
  }

  private _filterArtists(value: string): any[] {
    return this.artists.filter((artist) =>
      artist.artistName.toLowerCase().includes(value.toLowerCase()),
    );
  }

  onArtistSelected(artistName: string): void {
    this.selectedArtist = this.artists.find(
      (artist) => artist.artistName === artistName
    );
    console.log('Selected Artist:', this.selectedArtist);
  }
}
