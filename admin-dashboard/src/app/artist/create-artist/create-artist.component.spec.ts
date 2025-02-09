import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateArtistComponent } from './create-artist.component';

describe('CreateArtistComponent', () => {
  let component: CreateArtistComponent;
  let fixture: ComponentFixture<CreateArtistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CreateArtistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CreateArtistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
