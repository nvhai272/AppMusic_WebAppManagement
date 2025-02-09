import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { AutocompleteSearchDropdownComponent } from '../../common/autocomplete-search-dropdown/autocomplete-search-dropdown.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { EditKeywordComponent } from '../edit-keyword/edit-keyword.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
@Component({
  selector: 'app-details-keyword',
  imports: [
    FooterComponent,
    NavbarComponent,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
    CommonModule,
  ],
  templateUrl: './details-keyword.component.html',
  styleUrl: './details-keyword.component.css',
})
export class DetailsKeywordComponent implements OnInit {
  detailData: any;
  imageName: string | undefined;
  imageUrl: string | undefined;
  constructor(
    private dialog: MatDialog,
    private commonService: CommonService,
    private route: ActivatedRoute
  ) {}

  async ngOnInit(): Promise<void> {
    this.loadDetail();
  }
  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('keywords', id);
      } catch (error) {
        console.error('Error fetching details:', error);
      }
    }
  }

  openEditGenreDialog(): void {
    const dialogRef = this.dialog.open(EditKeywordComponent, {
      width: '800px',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('Dialog result:', result);
      if (result === 'saved') {
        console.log('User added successfully');
      }
    });
  }
}
