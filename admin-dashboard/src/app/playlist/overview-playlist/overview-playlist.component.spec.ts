import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewPlaylistComponent } from './overview-playlist.component';

describe('OverviewPlaylistComponent', () => {
  let component: OverviewPlaylistComponent;
  let fixture: ComponentFixture<OverviewPlaylistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewPlaylistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewPlaylistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
