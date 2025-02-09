import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditNewsComponent } from './edit-news.component';

describe('EditNewsComponent', () => {
  let component: EditNewsComponent;
  let fixture: ComponentFixture<EditNewsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditNewsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditNewsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
