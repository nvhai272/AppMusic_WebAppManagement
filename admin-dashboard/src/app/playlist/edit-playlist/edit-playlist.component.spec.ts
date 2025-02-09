import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditPlaylistComponent } from './edit-playlist.component';

describe('EditPlaylistComponent', () => {
  let component: EditPlaylistComponent;
  let fixture: ComponentFixture<EditPlaylistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditPlaylistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditPlaylistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
