import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { UserService } from '../../services/user.service';
import { CommonModule } from '@angular/common';
import { Replace5CharsPipe } from '../../services/replace5-chars.pipe';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { Paginator, PaginatorModule } from 'primeng/paginator';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatDialog } from '@angular/material/dialog';
import { DeleteUserComponent } from '../delete-user/delete-user.component';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-overview-user',
  standalone: true,
  imports: [
    FooterComponent,
    NavbarComponent,
    RouterLink,
    CommonModule,
    PaginatorModule,
    Replace5CharsPipe,
    SidebarComponent,
    MatPaginatorModule,
  ],
  templateUrl: './overview-user.component.html',
  styleUrl: './overview-user.component.css',
})
export class OverviewUserComponent implements OnInit {
  data: any[] = [];
  totalItems = 0;
  pageIndex = 0;
  constructor(
    private commonService: CommonService,
    private dialog: MatDialog,
    private toastr: ToastrService
  ) {}
  ngOnInit(): void {
    this.countUsers();
    this.loadPageData();
  }

  loadPageData(): void {
    this.commonService.fetchListData('users', this.pageIndex).subscribe(
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

  countUsers(): void {
    this.commonService.getDataCount('users').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching user count:', err);
      },
    });
  }

  openConfirmDialog(id: number, username: string): void {
    const dialogRef = this.dialog.open(DeleteUserComponent, {
      data: {
        message: `Are you sure you want to delete this user with username: `,username: username
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('users', id).subscribe({
          next: (response: any) => {
            this.toastr.success('User deleted successfully');
            this.loadPageData();
          },
          error: (error: any) => {
            console.error('Error deleting user:', error);
            this.toastr.error('Error deleting user. Please try again.');
          },
          complete: () => {
            console.log('Delete operation completed');
          },
        });
      }
    });
  }
}
