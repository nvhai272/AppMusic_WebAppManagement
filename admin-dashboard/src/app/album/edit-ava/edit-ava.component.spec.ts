import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditAvaComponent } from './edit-ava.component';

describe('EditAvaComponent', () => {
  let component: EditAvaComponent;
  let fixture: ComponentFixture<EditAvaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditAvaComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditAvaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
