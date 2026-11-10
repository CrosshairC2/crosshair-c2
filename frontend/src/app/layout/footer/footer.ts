import { Component } from '@angular/core';
import { CrosshairMark } from '../../shared/icons/crosshair-mark/crosshair-mark';
import { NAV_LINKS } from '../../core/nav-links';

@Component({
  selector: 'app-footer',
  imports: [CrosshairMark],
  templateUrl: './footer.html',
  styleUrl: './footer.scss',
})
export class Footer {
  protected readonly navLinks = NAV_LINKS;
  protected readonly year = new Date().getFullYear();
}
