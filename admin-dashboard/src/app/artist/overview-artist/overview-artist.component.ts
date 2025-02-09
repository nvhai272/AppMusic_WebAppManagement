import { Component, OnInit } from '@angular/core';
import { CreateArtistComponent } from '../create-artist/create-artist.component';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteArtistComponent } from '../delete-artist/delete-artist.component';

@Component({
  selector: 'app-overview-artist',
  standalone: true,
  imports: [
    MatPaginatorModule,
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
  ],
  templateUrl: './overview-artist.component.html',
  styleUrl: './overview-artist.component.css',
})
export class OverviewArtistComponent implements OnInit {
openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteArtistComponent, {
      data: {
        message: `Are you sure you want to delete this artist: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('artists', id).subscribe({
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
    this.commonService.fetchListData('artists', this.pageIndex).subscribe(
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
    this.commonService.getDataCount('artists').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }
  openAddArtistDialog(): void {
    const dialogRef = this.dialog.open(CreateArtistComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.commonService.updateArtistCount();
        this.toastr.success('', 'created artist!');
        this.loadPageData();
      }
    });
  }
}
