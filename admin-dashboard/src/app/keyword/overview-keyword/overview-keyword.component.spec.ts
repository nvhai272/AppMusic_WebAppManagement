import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewKeywordComponent } from './overview-keyword.component';

describe('OverviewKeywordComponent', () => {
  let component: OverviewKeywordComponent;
  let fixture: ComponentFixture<OverviewKeywordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewKeywordComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewKeywordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
