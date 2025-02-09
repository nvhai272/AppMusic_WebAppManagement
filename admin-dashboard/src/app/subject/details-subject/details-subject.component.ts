import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { EditSubjectComponent } from '../edit-subject/edit-subject.component';
import { CreateAlbumComponent } from '../../album/create-album/create-album.component';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AutocompleteSearchDropdownComponent } from '../../common/autocomplete-search-dropdown/autocomplete-search-dropdown.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteSubjectComponent } from '../delete-subject/delete-subject.component';

@Component({
  selector: 'app-details-subject',
  standalone: true,
  imports: [
    FooterComponent,
    NavbarComponent,
    RouterLink,
    CommonModule,
    MatDialogModule,
    FormsModule,
    AutocompleteSearchDropdownComponent,
    SidebarComponent,
    MatPaginatorModule
  ],
  templateUrl: './details-subject.component.html',
  styleUrl: './details-subject.component.css',
})
export class DetailsSubjectComponent {
  detailData: any;
  listSong: any;
  pageIndex: number = 0;
  totalAlbum: number = 0;
  constructor(
    private dialog: MatDialog,
    private route: ActivatedRoute,
    private commonService: CommonService
  ) {}
  async ngOnInit(): Promise<void> {
    this.loadDetail();
    this.loadListAlbumOfCate();
  }

  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('categories', id);
        this.totalAlbum = this.detailData.totalAlbum;
      } catch (error) {
        console.error(error);
      }
    }
  }

  private async loadListAlbumOfCate() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.listSong = await this.commonService.getListAlbumBySomeThing(
          'byCategory',
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
    this.loadListAlbumOfCate();
  }

  openEditSubjectDialog(): void {
    const dialogRef = this.dialog.open(EditSubjectComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('Dialog result:', result);
      if (result === 'saved') {
        console.log('User added successfully');
      }
    });
  }

  openAddNewAlbumToSubjectDialog(): void {
    const dialogRef = this.dialog.open(CreateAlbumComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('Dialog result:', result);
      if (result === 'saved') {
        console.log('User added successfully');
      }
    });
  }
openConfirmDialog(): void {
            const dialogRef = this.dialog.open(DeleteSubjectComponent, {
              data: {
                message: `Are you sure you want to delete this category `,
              },
            });
          }

}
