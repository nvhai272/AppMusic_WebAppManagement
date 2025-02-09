import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteAlbumComponent } from '../delete-album/delete-album.component';
import { EditAlbumComponent } from '../edit-album/edit-album.component';
import { ToastrService } from 'ngx-toastr';
import { EditAvaComponent } from '../edit-ava/edit-ava.component';
@Component({
  selector: 'app-details-album',
  standalone: true,
  imports: [
    FooterComponent,
    NavbarComponent,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
    MatPaginatorModule,
  ],
  templateUrl: './details-album.component.html',
  styleUrl: './details-album.component.css',
})
export class DetailsAlbumComponent {
  openEditAva(id: any) {
    const dialogRef = this.dialog.open(EditAvaComponent, {
      width: '1000px',
      data: { id: id },
    });

    dialogRef.afterClosed().subscribe(async (result) => {
      await this.loadDetail();
      if (this.image) {
        await this.loadImage();
      }
    });
  }
  openEditDialog(id: any): void {
    const dialogRef = this.dialog.open(EditAlbumComponent, {
      width: '1000px',
      data: { id: id },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.toastr.success('', 'updated album!');
        this.loadDetail();
      }
    });
  }
  async changeRelease() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        await this.commonService.changeReleaseAlbum(id);
      } catch (error) {
        console.error(error);
      }
    }
    this.loadDetail();
  }
  detailData: any;
  image: string | undefined;
  imageUrl: string | undefined;
  totalSong: unknown;
  listSong: any;
  pageIndex: number = 0;

  constructor(
    private route: ActivatedRoute,
    private commonService: CommonService,
    private dialog: MatDialog,
    private toastr: ToastrService
  ) {}
  async ngOnInit(): Promise<void> {
    await this.loadDetail();
    if (this.image) {
      await this.loadImage();
    }
    this.loadListSong();
  }
  private async loadImage(): Promise<void> {
    try {
      const blob = await lastValueFrom(
        this.commonService.downloadImage(this.image!)
      );
      this.imageUrl = URL.createObjectURL(blob); // Tạo URL từ Blob
    } catch (error) {
      console.error('Error downloading image:', error);
    }
  }
  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('albums', id);
        this.image = this.detailData.image;
        this.totalSong = this.detailData.totalSong;
      } catch (error) {
        console.error(error);
      }
    }
  }

  private async loadListSong() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.listSong = await this.commonService.getListSongBySomeThing(
          'byAlbum',
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
    this.loadListSong();
  }

  openConfirmDialog(): void {
    const dialogRef = this.dialog.open(DeleteAlbumComponent, {
      data: {
        message: `Are you sure you want to delete this album `,
      },
    });
  }
}
