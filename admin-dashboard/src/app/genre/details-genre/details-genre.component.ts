import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { EditGenreComponent } from '../edit-genre/edit-genre.component';
import { AutocompleteSearchDropdownComponent } from '../../common/autocomplete-search-dropdown/autocomplete-search-dropdown.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { CreateSongComponent } from '../../song/create-song/create-song.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
import { PageEvent } from '@angular/material/paginator';
import { DeleteGenreComponent } from '../delete-genre/delete-genre.component';

@Component({
  selector: 'app-details-genre',
  standalone: true,
  imports: [
    FooterComponent,
    NavbarComponent,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
  ],
  templateUrl: './details-genre.component.html',
  styleUrl: './details-genre.component.css',
})
export class DetailsGenreComponent {
  detailData: any;
  image: string | undefined;
  imageUrl: string | undefined;

  constructor(
    private dialog: MatDialog,
    private route: ActivatedRoute,
    private commonService: CommonService,
   
  ) {}
  async ngOnInit(): Promise<void> {
    await this.loadDetail();
    if (this.image) {
      await this.loadImage();
    }
    
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
        this.detailData = await this.commonService.getDetail('genres', id);
        this.image = this.detailData.image;
      } catch (error:any) {
        
      }
    }
  }

  openEditGenreDialog(): void {
    const dialogRef = this.dialog.open(EditGenreComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('Dialog result:', result);
      if (result === 'saved') {
        console.log('genres edit successfully');
      }
    });
  }

   openConfirmDialog(): void {
            const dialogRef = this.dialog.open(DeleteGenreComponent, {
              data: {
                message: `Are you sure you want to delete this genre `,
              },
            });
          }
}
