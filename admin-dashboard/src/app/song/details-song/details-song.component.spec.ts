import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DetailsSongComponent } from './details-song.component';

describe('DetailsSongComponent', () => {
  let component: DetailsSongComponent;
  let fixture: ComponentFixture<DetailsSongComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DetailsSongComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DetailsSongComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
