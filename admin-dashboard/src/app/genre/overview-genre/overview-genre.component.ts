import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { CreateGenreComponent } from '../create-genre/create-genre.component';
import { MatDialog } from '@angular/material/dialog';
import { RouterLink } from '@angular/router';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteGenreComponent } from '../delete-genre/delete-genre.component';

@Component({
  selector: 'app-overview-genre',
  imports: [
    MatPaginatorModule,
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
  ],
  standalone: true,
  templateUrl: './overview-genre.component.html',
  styleUrl: './overview-genre.component.css',
})
export class OverviewGenreComponent implements OnInit {
openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteGenreComponent, {
      data: {
        message: `Are you sure you want to delete this genre: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('genres', id).subscribe({
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
    this.commonService.fetchListData('genres', this.pageIndex).subscribe(
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
    this.commonService.getDataCount('genres').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }

  openAddGenreDialog(): void {
    const dialogRef = this.dialog.open(CreateGenreComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.commonService.updateGenreCount();
        this.toastr.success('', 'created genre!');
        this.loadPageData();
      }
    });
  }

  closeDialog(): void {
    const openDialog = this.dialog.openDialogs.find(
      (dialog) => dialog.componentInstance instanceof CreateGenreComponent
    );
    if (openDialog) {
      openDialog.close();
    }
  }
}
