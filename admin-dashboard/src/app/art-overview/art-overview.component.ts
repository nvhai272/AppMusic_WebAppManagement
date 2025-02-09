import { Component } from '@angular/core';
import { FooterComponent } from "../common/footer/footer.component";
import { NavbarComponent } from "../common/navbar/navbar.component";
import { SidebarComponent } from "../common/sidebar/sidebar.component";

@Component({
  selector: 'app-art-overview',
  imports: [FooterComponent, NavbarComponent, SidebarComponent],
  templateUrl: './art-overview.component.html',
  styleUrl: './art-overview.component.css'
})
export class ArtOverviewComponent {

}
