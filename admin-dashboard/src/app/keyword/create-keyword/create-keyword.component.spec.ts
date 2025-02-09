import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateKeywordComponent } from './create-keyword.component';

describe('CreateKeywordComponent', () => {
  let component: CreateKeywordComponent;
  let fixture: ComponentFixture<CreateKeywordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CreateKeywordComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CreateKeywordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
