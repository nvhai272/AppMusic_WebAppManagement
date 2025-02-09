import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FooterComponent } from '../common/footer/footer.component';
import { NavbarComponent } from '../common/navbar/navbar.component';
import { SidebarComponent } from '../common/sidebar/sidebar.component';
import { BieudoComponent } from '../bieudo/bieudo.component';
import { CommonService } from '../services/common.service';

@Component({
  selector: 'admin-overview',
  standalone: true,
  imports: [
    NavbarComponent,
    FooterComponent,
    CommonModule,
    SidebarComponent,
    BieudoComponent,
    SidebarComponent,
  ],
  templateUrl: './admin-overview.component.html',
  styleUrl: './admin-overview.component.css',
})
export class AdminOverviewComponent implements OnInit {
  songs: any;
  song: any;
  views: any;
  currentMonth: any;
  numberMonth: number = 0;
  constructor(private commonService: CommonService) {}
  months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  ngOnInit(): void {
    this.numberMonth = new Date().getMonth() + 1;
    this.currentMonth = this.months[new Date().getMonth()];
    this.getSongMostListenedInMonth();
    this.getSongsTop5();
    this.getTotalviews();
  }
  getSongsTop5(): void {
    this.commonService
      .getSongDashboard('topFive')
      .then((data) => {
        this.songs = data;
      })
      .catch((error: any) => {
        console.error('Error fetching songs:', error);
      });
  }

  getSongMostListenedInMonth(): void {
    this.commonService
      .getSongDashboard('mostListened')
      .then((data) => {
        this.song = data;
      })
      .catch((error: any) => {
        this.song = 'Currently Not Available!';
      });
  }

  getTotalviews(): void {
    this.commonService
      .getTotalViewInMonth(this.numberMonth)
      .then((data) => {
        this.views = data.total_listen;
      })
      .catch((error: any) => {
        console.error('Error fetching most listened songs:', error);
      });
  }
}
