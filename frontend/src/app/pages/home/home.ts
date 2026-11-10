import { Component, DestroyRef, ElementRef, afterNextRender, inject } from '@angular/core';
import { ActiveSectionService } from '../../core/active-section';
import { HeroSection } from './sections/hero-section/hero-section';
import { CapabilitiesSection } from './sections/capabilities-section/capabilities-section';
import { AudienceSection } from './sections/audience-section/audience-section';
import { AboutSection } from './sections/about-section/about-section';
import { ContactSection } from './sections/contact-section/contact-section';

@Component({
  selector: 'app-home',
  imports: [
    HeroSection,
    CapabilitiesSection,
    AudienceSection,
    AboutSection,
    ContactSection,
  ],
  templateUrl: './home.html',
  styleUrl: './home.scss',
})
export class Home {
  private readonly elementRef = inject(ElementRef<HTMLElement>);
  private readonly activeSection = inject(ActiveSectionService);
  private readonly destroyRef = inject(DestroyRef);

  constructor() {
    afterNextRender(() => {
      this.activeSection.observe(this.elementRef.nativeElement);
    });
    this.destroyRef.onDestroy(() => this.activeSection.disconnect());
  }
}
