import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../../common/footer/footer.component';
import {
  ActivatedRoute,
  Router,
  RouterLink,
  RouterOutlet,
} from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NavbarComponent } from '../../common/navbar/navbar.component';
import { SidebarComponent } from '../../common/sidebar/sidebar.component';
import { CommonService } from '../../services/common.service';
import { lastValueFrom } from 'rxjs';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { DeleteUserComponent } from '../delete-user/delete-user.component';
import { MatDialog } from '@angular/material/dialog';
import { ToastrService } from 'ngx-toastr';
import { EditAvaComponent } from '../edit-ava/edit-ava.component';

@Component({
  selector: 'app-details-user',
  imports: [
    FormsModule,
    NavbarComponent,
    FooterComponent,
    CommonModule,
    NavbarComponent,
    SidebarComponent,
    MatPaginatorModule,
    RouterLink,
  ],
  templateUrl: './details-user.component.html',
  styleUrl: './details-user.component.css',
})
export class DetailsUserComponent implements OnInit {
  openEditAva(id: any) {
    const dialogRef = this.dialog.open(EditAvaComponent, {
      width: '1000px',
      data: { id: id },
    });

    dialogRef.afterClosed().subscribe(async (result) => {
      if (result === 'saved') {
        await this.loadDetail();
        if (this.imageName) {
          await this.loadImage();
        }
      }
    });
  }
  editUser() {}
  detailData: any;
  imageName: string | undefined;
  imageUrl: string | undefined;

  pageIndex: number = 0;
  listData: any;
  begin: number = 0;
  username: string | undefined;
  id: any;
  constructor(
    private route: ActivatedRoute,
    private commonService: CommonService,
    private dialog: MatDialog,
    private toastr: ToastrService,
    private router: Router
  ) {}
  async ngOnInit(): Promise<void> {
    await this.loadDetail();
    if (this.imageName) {
      await this.loadImage();
    }
    this.loadDataBasedOnBegin();
  }

  private async loadImage(): Promise<void> {
    try {
      const blob = await lastValueFrom(
        this.commonService.downloadImage(this.imageName!)
      );
      this.imageUrl = URL.createObjectURL(blob);
    } catch (error) {
      console.error('Error downloading image:', error);
    }
  }

  private async loadDetail() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      try {
        this.detailData = await this.commonService.getDetail('users', id);
        this.imageName = this.detailData.avatar;
        this.id = this.detailData.id;
        this.username = this.detailData.username;
      } catch (error) {
        console.error('Error loading user details:', error);
      }
    }
  }

  private async loadDataBasedOnBegin(): Promise<void> {
    const id = this.route.snapshot.paramMap.get('id');
    if (!id) return;

    if (this.begin === 0) {
      await this.loadListSong(id);
    } else if (this.begin === 1) {
      await this.loadListAlbum(id);
    }
  }

  private async loadListSong(userId: string): Promise<void> {
    try {
      this.listData = await this.commonService.getListSongBySomeThing(
        'byUser',
        userId,
        this.pageIndex
      );
    } catch (error) {
      console.error('Error loading song list:', error);
    }
  }

  private async loadListAlbum(userId: string): Promise<void> {
    try {
      this.listData = await this.commonService.getListAlbumBySomeThing(
        'byUser',
        userId,
        this.pageIndex
      );
    } catch (error) {
      console.error('Error loading album list:', error);
    }
  }

  toggleFavoriteList(): void {
    this.begin = this.begin === 0 ? 1 : 0;
    this.loadDataBasedOnBegin();
  }

  onPageChange(event: PageEvent): void {
    this.pageIndex = event.pageIndex;
    this.loadDataBasedOnBegin();
  }

  openConfirmDialog(): void {
    const dialogRef = this.dialog.open(DeleteUserComponent, {
      data: {
        message: `Are you sure you want to delete this user with username: `,
        username: this.username,
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === 'confirm') {
        this.commonService.deleteData('users', this.id).subscribe({
          next: (response: any) => {
            this.router.navigate(['/users']);
            this.toastr.success('User deleted successfully');
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
