import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CreateAlbumComponent } from '../../album/create-album/create-album.component';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AutocompleteSearchDropdownComponent } from '../../common/autocomplete-search-dropdown/autocomplete-search-dropdown.component';
import { EditPlaylistComponent } from '../edit-playlist/edit-playlist.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeletePlaylistComponent } from '../delete-playlist/delete-playlist.component';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-details-playlist',
  imports: [
    FooterComponent,
    NavbarComponent,
    RouterLink,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,MatPaginatorModule
  ],
  templateUrl: './details-playlist.component.html',
  styleUrl: './details-playlist.component.css',
})
export class DetailsPlaylistComponent implements OnInit {
  constructor(
    private route: ActivatedRoute,
    private commonService: CommonService,
    private dialog: MatDialog,   
    private toastr: ToastrService
    
  ) {}
 openEditDialog(id: any): void {
    const dialogRef = this.dialog.open(EditPlaylistComponent, {
      width: '1000px',
      data: { id: id }
      
    });
    
    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.toastr.success('', 'updated playlist!');
        this.loadDetail();
      }
    });
  }
  detailData: any;
  listSong: any;
  pageIndex: number = 0;
  totalSongOfPlaylist: number=0;
 
  async ngOnInit(): Promise<void> {
    this.loadDetail();
    this.loadListSongOfPlaylist();
  }

  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('playlists', id);
        this.totalSongOfPlaylist = this.detailData.totalSong;
      } catch (error) {
        console.error(error);
      }
    }
  }

  private async loadListSongOfPlaylist() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.listSong = await this.commonService.getListSongBySomeThing(
          'byPlaylist',
          id,
          this.pageIndex
        );
      } catch (error) {
        console.error(error);
      }
    }
  }

  onPageChange(event: PageEvent): void {
    this.pageIndex = event.pageIndex;
    this.loadListSongOfPlaylist();
  }

  openConfirmDialog(): void {
      const dialogRef = this.dialog.open(DeletePlaylistComponent, {
        data: {
          message: `Are you sure you want to delete this playlist `,
        },
      });
    }
}
