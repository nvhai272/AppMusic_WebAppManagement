import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewSongComponent } from './overview-song.component';

describe('OverviewSongComponent', () => {
  let component: OverviewSongComponent;
  let fixture: ComponentFixture<OverviewSongComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewSongComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewSongComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
