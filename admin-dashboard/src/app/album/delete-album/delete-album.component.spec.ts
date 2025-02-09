import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteAlbumComponent } from './delete-album.component';

describe('DeleteAlbumComponent', () => {
  let component: DeleteAlbumComponent;
  let fixture: ComponentFixture<DeleteAlbumComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DeleteAlbumComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DeleteAlbumComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
