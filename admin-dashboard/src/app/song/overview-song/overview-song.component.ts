import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { CreateSongComponent } from '../create-song/create-song.component';
import { MatDialog } from '@angular/material/dialog';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { CreateSubjectComponent } from '../../subject/create-subject/create-subject.component';
import { ToastrService } from 'ngx-toastr';
import { DeleteSongComponent } from '../delete-song/delete-song.component';

@Component({
  selector: 'app-overview-song',
  imports: [
    MatPaginatorModule,
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
  ],
  templateUrl: './overview-song.component.html',
  styleUrl: './overview-song.component.css',
})
export class OverviewSongComponent implements OnInit {
 openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteSongComponent, {
      data: {
        message: `Are you sure you want to delete this song: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('songs', id).subscribe({
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
    this.countSongs();
    this.loadPageData();
  }

  loadPageData(): void {
    this.commonService.fetchListData('songs', this.pageIndex).subscribe(
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

  countSongs(): void {
    this.commonService.getDataCount('songs').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }

  openAddSongDialog(): void {
    const dialogRef = this.dialog.open(CreateSongComponent, {
      width: '1000px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.commonService.updateSongCount();
        this.toastr.success('', 'created song!');
        this.loadPageData();
      }
    });
  }

  
}
