import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { RouterLink } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { CreateKeywordComponent } from '../create-keyword/create-keyword.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteKeywordComponent } from '../delete-keyword/delete-keyword.component';
@Component({
  selector: 'app-overview-keyword',
  imports: [
    MatPaginatorModule,
    FooterComponent,
    NavbarComponent,
    RouterLink,
    SidebarComponent,
    CommonModule,
  ],
  templateUrl: './overview-keyword.component.html',
  styleUrl: './overview-keyword.component.css',
})
export class OverviewKeywordComponent {
openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteKeywordComponent, {
      data: {
        message: `Are you sure you want to delete this keyword: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('keywords', id).subscribe({
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
    this.commonService.fetchListData('keywords', this.pageIndex).subscribe(
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
    this.commonService.getDataCount('keywords').subscribe({
      next: (res) => {
        this.totalItems = res.qty;
      },
      error: (err) => {
        console.error('Error fetching count:', err);
      },
    });
  }
  openAddKeywordDialog(): void {
    const dialogRef = this.dialog.open(CreateKeywordComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.loadPageData();
         this.commonService.updateKeywordCount();
        this.toastr.success('', 'created keyword!');
       
      }
    });
  }

  async activeKeyword(id:any){
    try {
      await this.commonService.changeStatusKeyword(id);
     } catch (error) {
       console.error(error);
     }
      this.loadPageData();
    } 
}
