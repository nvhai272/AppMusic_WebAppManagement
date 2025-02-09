import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewGenreComponent } from './overview-genre.component';

describe('OverviewGenreComponent', () => {
  let component: OverviewGenreComponent;
  let fixture: ComponentFixture<OverviewGenreComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewGenreComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewGenreComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
