import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OverviewSubjectComponent } from './overview-subject.component';

describe('OverviewSubjectComponent', () => {
  let component: OverviewSubjectComponent;
  let fixture: ComponentFixture<OverviewSubjectComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OverviewSubjectComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OverviewSubjectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
