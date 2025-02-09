import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { CreateNewsComponent } from '../create-news/create-news.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteNewsComponent } from '../delete-news/delete-news.component';
@Component({
  selector: 'app-overview-news',
  imports: [
    MatPaginatorModule,
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
  ],
  templateUrl: './overview-news.component.html',
  styleUrl: './overview-news.component.css',
})
export class OverviewNewsComponent implements OnInit {
openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteNewsComponent, {
      data: {
        message: `Are you sure you want to delete this news: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('news', id).subscribe({
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
    this.commonService.fetchListData('news', this.pageIndex).subscribe(
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
    this.commonService.getDataCount('news').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }

  openAddNewsDialog(): void {
    const dialogRef = this.dialog.open(CreateNewsComponent, {
      width: '1000px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('Dialog result:', result);
      if (result === 'saved') {
        this.loadPageData();
        this.commonService.updateNewsCount();
        this.toastr.success('', 'created news!');
      }
    });
  }
}
