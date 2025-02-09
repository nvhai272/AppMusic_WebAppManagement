import { Component } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { FormsModule } from '@angular/forms';
import { EditSongComponent } from '../edit-song/edit-song.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { MatPaginatorModule } from '@angular/material/paginator';
import { CommonService } from '../../services/common.service';
import { DeleteSongComponent } from '../delete-song/delete-song.component';
import { ToastrService } from 'ngx-toastr';
import { EditFileComponent } from '../edit-file/edit-file.component';

@Component({
  selector: 'app-details-song',
  imports: [
    FooterComponent,
    NavbarComponent,
    CommonModule,
    MatDialogModule,
    FormsModule,
    SidebarComponent,
    MatPaginatorModule,
  ],
  templateUrl: './details-song.component.html',
  styleUrl: './details-song.component.css',
})
export class DetailsSongComponent {
openEditFile(id: any) {
  const dialogRef = this.dialog.open(EditFileComponent, {
    width: '1000px',
    data: { id: id }
    
  });
  
  dialogRef.afterClosed().subscribe((result) => {
    if (result === 'saved') {
      this.loadDetail();
    }
  });}
  openEditDialog(id: any): void {
    const dialogRef = this.dialog.open(EditSongComponent, {
      width: '1000px',
      data: { id: id }
      
    });
    
    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'saved') {
        this.toastr.success('', 'updated song!');
        this.loadDetail();
      }
    });
  }
  
  async pendingToggle() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        await this.commonService.changeStatusSong('songs', id);
      } catch (error) {
        console.error(error);
      }
    }
    this.loadDetail();
  }
  detailData: any;
  constructor(
    private dialog: MatDialog,
    private route: ActivatedRoute,
    private commonService: CommonService,
    private toastr: ToastrService
  ) {}
  async ngOnInit(): Promise<void> {
    this.loadDetail();
  }

  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('songs', id);
      } catch (error) {
        console.error(error);
      }
    }
  }

  openConfirmDialog(): void {
    const dialogRef = this.dialog.open(DeleteSongComponent, {
      data: {
        message: `Are you sure you want to delete this song `,
      },
    });
  }
}
