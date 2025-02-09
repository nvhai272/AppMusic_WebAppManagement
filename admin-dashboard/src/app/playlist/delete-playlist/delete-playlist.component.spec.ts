import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeletePlaylistComponent } from './delete-playlist.component';

describe('DeletePlaylistComponent', () => {
  let component: DeletePlaylistComponent;
  let fixture: ComponentFixture<DeletePlaylistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DeletePlaylistComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DeletePlaylistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
