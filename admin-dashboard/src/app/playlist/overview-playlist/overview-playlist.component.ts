import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { CreatePlaylistComponent } from '../create-playlist/create-playlist.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { ToastrService } from 'ngx-toastr';
import { DeletePlaylistComponent } from '../delete-playlist/delete-playlist.component';

@Component({
  selector: 'app-overview-playlist',
  imports: [
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
    MatPaginatorModule,
  ],
  templateUrl: './overview-playlist.component.html',
  styleUrl: './overview-playlist.component.css',
})
export class OverviewPlaylistComponent implements OnInit {
openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeletePlaylistComponent, {
      data: {
        message: `Are you sure you want to delete this playlist: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('playlists', id).subscribe({
          next: (response: any) => {
            this.toastr.success('deleted successfully!');
            this.loadPageData();
          },
          error: (error: any) => {
            console.error('Error delete:', error);
            this.toastr.error('Error delete');
          },
          complete: () => {
            console.log('Delete operation completed');
          },
        });
      }
    });
  }
  data: any[] = [];
  totalItems = 0;
  pageIndex = 0;

  constructor(
    private dialog: MatDialog,
    private commonService: CommonService,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {
    this.count();
    this.loadPageData();
  }

  loadPageData(): void {
    this.commonService.fetchListData('playlists', this.pageIndex).subscribe(
      (response) => {
        this.data = response;
      },
      (error) => {
        console.error('Error fetching data:', error);
      }
    );
  }

  onPageChange(event: PageEvent): void {
    this.pageIndex = event.pageIndex;
    this.loadPageData();
  }

  count(): void {
    this.commonService.getDataCount('playlists').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }

  openAddPlaylistDialog(): void {
    const dialogRef = this.dialog.open(CreatePlaylistComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.commonService.updatePlaylistCount();
        this.toastr.success('', 'created playlist!');
        this.loadPageData();
      }
    });
  }
}
