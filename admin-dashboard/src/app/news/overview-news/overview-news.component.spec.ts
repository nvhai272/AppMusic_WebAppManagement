import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewNewsComponent } from './overview-news.component';

describe('OverviewNewsComponent', () => {
  let component: OverviewNewsComponent;
  let fixture: ComponentFixture<OverviewNewsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewNewsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewNewsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
