import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'replace5Chars'
})
export class Replace5CharsPipe implements PipeTransform {

  transform(value: string, replaceLength: number = 5, replacement: string = '*****'): string {
    if (value && value.length > replaceLength) {
      return replacement + value.slice(replaceLength); 
    }
    return value;
  }

}
