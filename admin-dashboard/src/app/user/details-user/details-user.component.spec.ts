import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DetailsUserComponent } from './details-user.component';

describe('DetailsUserComponent', () => {
  let component: DetailsUserComponent;
  let fixture: ComponentFixture<DetailsUserComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DetailsUserComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DetailsUserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
