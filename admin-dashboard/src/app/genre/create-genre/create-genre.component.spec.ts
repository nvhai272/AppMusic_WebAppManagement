import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateGenreComponent } from './create-genre.component';

describe('CreateGenreComponent', () => {
  let component: CreateGenreComponent;
  let fixture: ComponentFixture<CreateGenreComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CreateGenreComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CreateGenreComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
