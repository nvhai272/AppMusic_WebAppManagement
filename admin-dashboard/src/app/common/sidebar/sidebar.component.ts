import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive],
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
})
export class SidebarComponent implements OnInit {
  userCount: number = 0;
  songCount: number = 0;
  playlistCount: number = 0;
  albumCount: number = 0;
  artistCount: number = 0;
  genreCount: number = 0;
  categoryCount: number = 0;
  keywordCount: number = 0;
  newsCount: number = 0;
  role: any;
  
  constructor(private router: Router, private commonService: CommonService) {}
  checkRoll() :void{
   const userInfo = localStorage.getItem('userInfo');
    if(userInfo) {
      const parsedUserInfo = JSON.parse(userInfo);
      this.role = parsedUserInfo.role;
    }
  }
  
  ngOnInit(): void {
    this.checkRoll();
    if (this.role === 'ROLE_ADMIN') {
      this.countUsers();
      this.countSongs();
      this.countPlaylists();
      this.countAlbums();
      this.countArtists();
      this.countGenres();
      this.countCategories();
      this.countKeywords();
      this.countNews();
    }

    this.commonService.countUpdated$.subscribe((entity) => {
      switch (entity) {
        case 'users':
          this.countUsers();
          break;
        case 'songs':
          this.countSongs();
          break;
        case 'playlists':
          this.countPlaylists();
          break;
        case 'albums':
          this.countAlbums();
          break;
        case 'artists':
          this.countArtists();
          break;
        case 'genres':
          this.countGenres();
          break;
        case 'keywords':
          this.countKeywords();
          break;
        case 'news':
          this.countNews();
          break;
        case 'categories':
          this.countCategories();
          break;
        default:
          break;
      }
    });
  }

  isActive(urls: string[]): boolean {
    return urls.some((url) => this.router.url.startsWith(url));
  }

  onLogout(): void {
    localStorage.clear();
    this.router.navigate(['/login']);
  }

  countUsers(): void {
    this.commonService.getDataCount('users').subscribe({
      next: (res) => {
        this.userCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching user count:', err);
      },
    });
  }

  countSongs(): void {
    this.commonService.getDataCount('songs').subscribe({
      next: (res) => {
        this.songCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching song count:', err);
      },
    });
  }

  countPlaylists(): void {
    this.commonService.getDataCount('playlists').subscribe({
      next: (res) => {
        this.playlistCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching playlist count:', err);
      },
    });
  }

  countAlbums(): void {
    this.commonService.getDataCount('albums').subscribe({
      next: (res) => {
        this.albumCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching album count:', err);
      },
    });
  }

  countArtists(): void {
    this.commonService.getDataCount('artists').subscribe({
      next: (res) => {
        this.artistCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching user count:', err);
      },
    });
  }

  countGenres(): void {
    this.commonService.getDataCount('genres').subscribe({
      next: (res) => {
        this.genreCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching genre count:', err);
      },
    });
  }

  countKeywords(): void {
    this.commonService.getDataCount('keywords').subscribe({
      next: (res) => {
        this.keywordCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching keyword count:', err);
      },
    });
  }

  countNews(): void {
    this.commonService.getDataCount('news').subscribe({
      next: (res) => {
        this.newsCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching news count:', err);
      },
    });
  }

  countCategories(): void {
    this.commonService.getDataCount('categories').subscribe({
      next: (res) => {
        this.categoryCount = res.qty;
      },
      error: (err) => {
        console.error('Error fetching categories count:', err);
      },
    });
  }
}
