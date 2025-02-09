import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { AutocompleteSearchDropdownComponent } from '../../common/autocomplete-search-dropdown/autocomplete-search-dropdown.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { EditArtistComponent } from '../edit-artist/edit-artist.component';
import { CreateSongComponent } from '../../song/create-song/create-song.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteArtistComponent } from '../delete-artist/delete-artist.component';
import { ToastrService } from 'ngx-toastr';
import { EditAvaComponent } from '../edit-ava/edit-ava.component';

@Component({
  selector: 'app-details-artist',
  standalone: true,
  imports: [
    FooterComponent,
    NavbarComponent,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
    MatPaginatorModule,
  ],
  templateUrl: './details-artist.component.html',
  styleUrl: './details-artist.component.css',
})
export class DetailsArtistComponent {
  constructor(
    private route: ActivatedRoute,
    private commonService: CommonService,
    private dialog: MatDialog,
    private toastr: ToastrService
  ) {}
  openEditAva(id: any) {
      const dialogRef = this.dialog.open(EditAvaComponent, {
        width: '1000px',
        data: { id: id },
      });
  
      dialogRef.afterClosed().subscribe(async (result) => {
        await this.loadDetail();
        if (this.imageName) {
          await this.loadImage();
        }
      });
    }
  openEditDialog(id: any): void {
    const dialogRef = this.dialog.open(EditArtistComponent, {
      width: '1000px',
      data: { id: id },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.toastr.success('', 'updated artist!');
        this.loadDetail();
      }
    });
  }

  detailData: any;
  imageName: string | undefined;
  imageUrl: string | undefined;

  pageIndex: number = 0;
  listData: any;
  begin: number = 0;
  totalSong: number = 0;
  totalAlbum: number = 0;

  async ngOnInit(): Promise<void> {
    await this.loadDetail();
    if (this.imageName) {
      await this.loadImage();
    }
    this.loadDataBasedOnBegin();
  }

  private async loadImage(): Promise<void> {
    try {
      const blob = await lastValueFrom(
        this.commonService.downloadImage(this.imageName!)
      );
      this.imageUrl = URL.createObjectURL(blob);
    } catch (error) {
      console.error('Error downloading image:', error);
    }
  }

  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('artists', id);
        this.imageName = this.detailData.image;
        this.totalSong = this.detailData.totalSong;
        this.totalAlbum = this.detailData.totalAlbum;
      } catch (error) {
        console.error('Error loading art details:', error);
      }
    }
  }

  private async loadDataBasedOnBegin(): Promise<void> {
    const id = this.route.snapshot.paramMap.get('id');
    if (!id) return;

    if (this.begin === 0) {
      await this.loadListSong(id);
    } else if (this.begin === 1) {
      await this.loadListAlbum(id);
    }
  }

  private async loadListSong(Id: string): Promise<void> {
    try {
      this.listData = await this.commonService.getListSongBySomeThing(
        'byArtist',
        Id,
        this.pageIndex
      );
    } catch (error) {
      console.error('Error loading song list:', error);
    }
  }

  private async loadListAlbum(Id: string): Promise<void> {
    try {
      this.listData = await this.commonService.getListAlbumBySomeThing(
        'byArtist',
        Id,
        this.pageIndex
      );
    } catch (error) {
      console.error('Error loading album list:', error);
    }
  }

  toggleList(): void {
    this.begin = this.begin === 0 ? 1 : 0;
    this.loadDataBasedOnBegin();
  }

  onPageChange(event: PageEvent): void {
    this.pageIndex = event.pageIndex;
    this.loadDataBasedOnBegin();
  }

  openConfirmDialog(): void {
    const dialogRef = this.dialog.open(DeleteArtistComponent, {
      data: {
        message: `Are you sure you want to delete this artist `,
      },
    });
  }
}
