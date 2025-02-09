import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditArtistComponent } from './edit-artist.component';

describe('EditArtistComponent', () => {
  let component: EditArtistComponent;
  let fixture: ComponentFixture<EditArtistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditArtistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditArtistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
