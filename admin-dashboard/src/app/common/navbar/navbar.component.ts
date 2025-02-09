import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterLink, CommonModule],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.css',
})
export class NavbarComponent implements OnInit {
  currentUrl: string = '';
  roleAdmins: boolean = false;
  fullName: string ='';
  constructor(private router: Router) {}
  ngOnInit(): void {
    this.currentUrl = this.router.url;
   this.checkUserRole();
  }

  getPageTitle(): string {
    if (this.currentUrl.includes('dashboard')) {
      return 'Dashboard';
    } else if (this.currentUrl.includes('user')) {
      return 'User';
    } else if (this.currentUrl.includes('song')) {
      return 'Song';
    } else if (this.currentUrl.includes('playlist')) {
      return 'Playlist';
    } else if (this.currentUrl.includes('album')) {
      return 'Album';
    } else if (this.currentUrl.includes('artist')) {
      return 'Artist';
    } else if (this.currentUrl.includes('genre')) {
      return 'Genre';
    } else if (this.currentUrl.includes('subject')) {
      return 'Subject';
    } else if (this.currentUrl.includes('keywords')) {
      return 'Keyword';
    } else if (this.currentUrl.includes('news')) {
      return 'New';
    } else if (this.currentUrl.match(/settings/)) {
      return 'Settings Page';
    } else {
      return 'Artist-Overview';
    }
  }

  getPageTitle2(): string {
    if (this.currentUrl.includes('add')) {
      return 'Create New Page';
    } else if (this.currentUrl.includes('dashboard')) {
      return 'Dashboard';
    } else if (this.currentUrl.includes('details')) {
      return 'Details Page ';
    } else if (this.currentUrl.includes('edit')) {
      return 'Edit Page ';
    } else if (this.currentUrl.match(/settings/)) {
      return 'Settings Page';
    } else if (this.currentUrl.includes('overview')) {
      return 'Account';
    } else{
      return 'List Page';
    }
  }

  checkUserRole(): void {
    const userInfoRaw = localStorage.getItem('userInfo');
    if (userInfoRaw) {
      try {
        const userInfo = JSON.parse(userInfoRaw);

        if (userInfo.role === 'ROLE_ADMIN') {
          this.roleAdmins = true; 
          this.fullName = userInfo.fullName;
        }else{
          this.fullName = userInfo.fullName;
        }
      } catch (error) {
        console.error('Failed to parse userInfo:', error);
      }
    }
  }
}
