import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BieudoComponent } from './bieudo.component';

describe('BieudoComponent', () => {
  let component: BieudoComponent;
  let fixture: ComponentFixture<BieudoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BieudoComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(BieudoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
