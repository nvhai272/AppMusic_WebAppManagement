import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AutocompleteSearchDropdownComponent } from './autocomplete-search-dropdown.component';

describe('AutocompleteSearchDropdownComponent', () => {
  let component: AutocompleteSearchDropdownComponent;
  let fixture: ComponentFixture<AutocompleteSearchDropdownComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AutocompleteSearchDropdownComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AutocompleteSearchDropdownComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
