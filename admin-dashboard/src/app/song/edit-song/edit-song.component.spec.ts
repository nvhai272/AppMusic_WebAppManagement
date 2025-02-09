import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditSongComponent } from './edit-song.component';

describe('EditSongComponent', () => {
  let component: EditSongComponent;
  let fixture: ComponentFixture<EditSongComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EditSongComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditSongComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
