import { Component, OnInit } from '@angular/core';
import { FooterComponent } from "../../common/footer/footer.component";
import { NavbarComponent } from "../../common/navbar/navbar.component";
import { MatDialog } from '@angular/material/dialog';
import { RouterLink } from '@angular/router';
import { CreateAlbumComponent } from '../create-album/create-album.component';
import { SidebarComponent } from "../../common/sidebar/sidebar.component";

import { CommonModule } from '@angular/common';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { ToastrService } from 'ngx-toastr';
import { DeleteAlbumComponent } from '../delete-album/delete-album.component';
@Component({
  selector: 'app-overview-album',
  imports: [MatPaginatorModule,FooterComponent, NavbarComponent, RouterLink, SidebarComponent,CommonModule],
  templateUrl: './overview-album.component.html',
  styleUrl: './overview-album.component.css'
})
export class OverviewAlbumComponent implements OnInit {

openConfirmDialog(id: number, name: string): void {
    const dialogRef = this.dialog.open(DeleteAlbumComponent, {
      data: {
        message: `Are you sure you want to delete this album: `,name: name
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('albums', id).subscribe({
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
      this.commonService.fetchListData('albums', this.pageIndex).subscribe(
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
      this.commonService.getDataCount('albums').subscribe({
        next: (res) => {
          this.totalItems = res.qty;
        },
        error: (err) => {
          console.error('Error fetching count:', err);
        },
      });
    }

  openAddAlbumDialog(): void {
    const dialogRef = this.dialog.open(CreateAlbumComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe(result => {

      if (result === 'saved') {
        this.commonService.updateAlbumCount();
        this.toastr.success('', 'created album!');
        this.loadPageData();
      
              }
    });
  }
}
