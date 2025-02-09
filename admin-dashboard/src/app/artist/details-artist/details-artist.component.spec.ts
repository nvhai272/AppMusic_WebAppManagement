import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DetailsArtistComponent } from './details-artist.component';

describe('DetailsArtistComponent', () => {
  let component: DetailsArtistComponent;
  let fixture: ComponentFixture<DetailsArtistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DetailsArtistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DetailsArtistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
