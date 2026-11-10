import { Component, input } from '@angular/core';

@Component({
  selector: 'app-crosshair-mark',
  templateUrl: './crosshair-mark.html',
  styleUrl: './crosshair-mark.scss',
})
export class CrosshairMark {
  readonly size = input<number>(32);
}
