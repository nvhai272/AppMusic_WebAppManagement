import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DetailsGenreComponent } from './details-genre.component';

describe('DetailsGenreComponent', () => {
  let component: DetailsGenreComponent;
  let fixture: ComponentFixture<DetailsGenreComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DetailsGenreComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DetailsGenreComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
