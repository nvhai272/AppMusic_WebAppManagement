import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditSubjectComponent } from './edit-subject.component';

describe('EditSubjectComponent', () => {
  let component: EditSubjectComponent;
  let fixture: ComponentFixture<EditSubjectComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditSubjectComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditSubjectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
