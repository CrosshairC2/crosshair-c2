import { Injectable, signal } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ActiveSectionService {
  readonly activeId = signal<string | null>(null);

  private observer?: IntersectionObserver;

  observe(root: ParentNode): void {
    this.disconnect();

    const sections = root.querySelectorAll<HTMLElement>('section[id]');
    if (!sections.length) {
      return;
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        const mostVisible = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];

        if (mostVisible) {
          this.activeId.set(mostVisible.target.id);
        }
      },
      { rootMargin: '-40% 0px -50% 0px', threshold: [0, 0.25, 0.5, 1] },
    );

    sections.forEach((section) => this.observer!.observe(section));
  }

  disconnect(): void {
    this.observer?.disconnect();
    this.observer = undefined;
  }
}
