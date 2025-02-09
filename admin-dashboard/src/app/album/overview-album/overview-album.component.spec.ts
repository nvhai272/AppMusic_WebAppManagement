import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewAlbumComponent } from './overview-album.component';

describe('OverviewAlbumComponent', () => {
  let component: OverviewAlbumComponent;
  let fixture: ComponentFixture<OverviewAlbumComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewAlbumComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewAlbumComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
