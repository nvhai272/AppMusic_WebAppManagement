import { CommonModule } from '@angular/common';
import { AfterViewInit, Component } from '@angular/core';
import { Chart } from 'chart.js/auto';
import ChartDataLabels from 'chartjs-plugin-datalabels'; // Import plugin
import { CommonService } from '../services/common.service';
import { forkJoin, Observable } from 'rxjs';

Chart.register(ChartDataLabels); 

@Component({
  selector: 'app-bieudo',
  imports: [CommonModule],
  templateUrl: './bieudo.component.html',
  styleUrls: ['./bieudo.component.css'],
})
export class BieudoComponent implements AfterViewInit {
  datalist: any[] = [];
  currentYear : number =new Date().getFullYear();

  constructor(private commonService: CommonService) {}
  getDataListViews12Month(): Observable<any> {
    const observables = [];

    for (let i = 1; i <= 12; i++) {
      observables.push(this.commonService.getTotalViewInMonth(i));
    }

    return forkJoin(observables);
  }

  ngAfterViewInit() {
    // this.createPieChart();

    this.getDataListViews12Month().subscribe(
      (dataList) => {
        // Dữ liệu từ các tháng được trả về trong `dataList`
        this.datalist = dataList.map((data: any) => data.total_listen);
        this.createRankingChart();
      },
      (error) => {
        console.error('Lỗi khi lấy dữ liệu:', error);
      }
    );
  }

  createRankingChart() {
    const ctx = document.getElementById('rankingChart') as HTMLCanvasElement;

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ],
        datasets: [
          {
            label: 'Views Of Month',
            data: this.datalist,
            backgroundColor: 'rgba(75, 192, 192, 0.4)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2,
            fill: true,
            pointBackgroundColor: 'rgba(75, 192, 192, 1)',
            pointBorderColor: '#fff',
            pointRadius: 4,
            pointHoverRadius: 8,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {
            ticks: {
              color: 'black',
              font: {
                size: 14,
              },
            },
          },
          y: {
            beginAtZero: true,
            ticks: {
              color: 'black',
              font: {
                size: 14,
              },
            },
          },
        },
        plugins: {
          legend: {
            display: true, 
            position: 'top',
          },
          datalabels: {
            display: true,
            color: 'black', 
            font: {
              size: 12,
            },
            anchor: 'end', 
            align: 'top', 
          },
        },
      },
    });
  }

  // createPieChart() {
  //   const ctx = document.getElementById('pieChart') as HTMLCanvasElement;

  //   new Chart(ctx, {
  //     type: 'pie',
  //     data: {
  //       labels: [
  //         'Pop',
  //         'Rock',
  //         'Hip-Hop/Rap',
  //         'Jazz',
  //         'Classical',
  //         'Country',
  //         'Electronic',
  //         'Blues',
  //         'Folk',
  //         'R&B/Soul',
  //       ],
  //       datasets: [
  //         {
  //           data: [12, 19, 3, 66, 5,99,3,2,5,0],
  //           backgroundColor: [
  //             'rgba(255, 0, 0, 0.6)', // Red
  //             'rgba(0, 255, 0, 0.6)', // Green
  //             'rgba(0, 0, 255, 0.6)', // Blue
  //             'rgba(255, 255, 0, 0.6)', // Yellow
  //             'rgba(0, 255, 255, 0.6)', // Cyan
  //             'rgba(255, 0, 255, 0.6)', // Magenta
  //             'rgba(255, 165, 0, 0.6)', // Orange
  //             'rgba(128, 0, 128, 0.6)', // Purple
  //             'rgba(255, 192, 203, 0.6)', // Pink
  //             'rgba(128, 128, 128, 0.6)', //Gray
  //           ],
  //         },
  //       ],
  //     },
  //     options: {
  //       responsive: true,
  //       maintainAspectRatio: false,
  //       plugins: {
  //         legend: {
  //           display: true, // Hiển thị legend
  //           position: 'left', // Đặt legend sang bên phải
  //           labels: {
  //             color: 'black', // Màu sắc của text trong legend
  //             font: {
  //               size: 15, // Cỡ chữ
  //             },
  //           },
  //         },
  //         datalabels: {
  //           display: false,
  //           color: 'black',
  //           font: {
  //             size: 15,
  //           },
  //           formatter: (value: string) => {
  //             return value + '%'; // Hiển thị phần trăm trên biểu đồ
  //           },
  //         },
  //       },
  //     },
  //   });
  // }
}
