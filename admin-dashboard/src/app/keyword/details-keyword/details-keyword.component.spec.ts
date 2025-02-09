import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DetailsKeywordComponent } from './details-keyword.component';

describe('DetailsKeywordComponent', () => {
  let component: DetailsKeywordComponent;
  let fixture: ComponentFixture<DetailsKeywordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DetailsKeywordComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DetailsKeywordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
