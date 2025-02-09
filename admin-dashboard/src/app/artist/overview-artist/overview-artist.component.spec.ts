import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewArtistComponent } from './overview-artist.component';

describe('OverviewArtistComponent', () => {
  let component: OverviewArtistComponent;
  let fixture: ComponentFixture<OverviewArtistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewArtistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewArtistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
