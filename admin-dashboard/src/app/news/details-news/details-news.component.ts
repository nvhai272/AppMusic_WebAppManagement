import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { EditNewsComponent } from '../edit-news/edit-news.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
import { DeleteNewsComponent } from '../delete-news/delete-news.component';
@Component({
  selector: 'app-details-news',
  imports: [
    FooterComponent,
    NavbarComponent,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
    RouterLink,
  ],
  templateUrl: './details-news.component.html',
  styleUrl: './details-news.component.css',
})
export class DetailsNewsComponent implements OnInit {
  constructor(
    private dialog: MatDialog,
    private commonService: CommonService,
    private route: ActivatedRoute
  ) {}

  openEditDialog(dataEdit: any) {
    const dialogRef = this.dialog.open(EditNewsComponent, {
      width: '800px',
      data: dataEdit,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.loadDetail();
      }
    });
  }
  detailData: any;
  imageName: string | undefined;
  imageUrl: string | undefined;

  async ngOnInit(): Promise<void> {
    await this.loadDetail();
    if (this.imageName) {
      await this.loadImage();
    }
  }
  private async loadImage(): Promise<void> {
    try {
      const blob = await lastValueFrom(
        this.commonService.downloadImage(this.imageName!)
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
        this.detailData = await this.commonService.getDetail('news', id);
        this.imageName = this.detailData.image;
      } catch (error) {
        console.error('Error fetching details:', error);
      }
    }
  }

  openEditGenreDialog(): void {
    const dialogRef = this.dialog.open(EditNewsComponent, {
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
    const dialogRef = this.dialog.open(DeleteNewsComponent, {
      data: {
        message: `Are you sure you want to delete this news `,
      },
    });
  }
}
