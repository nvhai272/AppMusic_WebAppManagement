import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditKeywordComponent } from './edit-keyword.component';

describe('EditKeywordComponent', () => {
  let component: EditKeywordComponent;
  let fixture: ComponentFixture<EditKeywordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditKeywordComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditKeywordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
