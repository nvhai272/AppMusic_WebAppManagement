import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'replace3Chars'
})
export class Replace3CharsPipe implements PipeTransform {
  transform(value: string, replaceLength: number = 3, replacement: string = '***'): string {
    if (value && value.length > replaceLength) {
      return replacement + value.slice(replaceLength); 
    }
    return value;
  }
}
