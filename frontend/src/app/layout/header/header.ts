import { Component, inject, signal } from '@angular/core';
import { CrosshairMark } from '../../shared/icons/crosshair-mark/crosshair-mark';
import { ActiveSectionService } from '../../core/active-section';
import { NAV_LINKS } from '../../core/nav-links';

@Component({
  selector: 'app-header',
  imports: [CrosshairMark],
  templateUrl: './header.html',
  styleUrl: './header.scss',
  host: {
    '(document:keydown.escape)': 'closeNav()',
  },
})
export class Header {
  private readonly activeSection = inject(ActiveSectionService);

  protected readonly navLinks = NAV_LINKS;
  protected readonly activeId = this.activeSection.activeId;
  protected readonly mobileNavOpen = signal(false);

  protected toggleNav(): void {
    this.mobileNavOpen.update((open) => !open);
  }

  protected closeNav(): void {
    this.mobileNavOpen.set(false);
  }
}
