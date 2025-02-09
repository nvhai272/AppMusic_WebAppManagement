import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { CreateSubjectComponent } from '../create-subject/create-subject.component';
import { MatDialog } from '@angular/material/dialog';
import { RouterLink } from '@angular/router';
import { EditSubjectComponent } from '../edit-subject/edit-subject.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';

import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteSubjectComponent } from '../delete-subject/delete-subject.component';

@Component({
  selector: 'app-overview-subject',
  imports: [
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
    MatPaginatorModule,
  ],
  templateUrl: './overview-subject.component.html',
  styleUrl: './overview-subject.component.css',
})
export class OverviewSubjectComponent implements OnInit {
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
    this.commonService.fetchListData('categories', this.pageIndex).subscribe(
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
    this.commonService.getDataCount('categories').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }
  openAddSubjectDialog(): void {
    const dialogRef = this.dialog.open(CreateSubjectComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.commonService.updateCategoryCount();
        this.toastr.success('', 'created category!');
        this.loadPageData();
      }
    });
  }

  openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteSubjectComponent, {
      data: {
        message: `Are you sure you want to delete this category: `,
        name: name,
      },
    });
    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('categories', id).subscribe({
          next: (response: any) => {
            this.toastr.success('deleted category!');
            this.loadPageData();
          },
          error: (error: any) => {
            console.error('Error deleting user:', error);
            this.toastr.error('Error delete');
          },
          complete: () => {
            console.log('Delete operation completed');
          },
        });
      }
    });
  }
}
