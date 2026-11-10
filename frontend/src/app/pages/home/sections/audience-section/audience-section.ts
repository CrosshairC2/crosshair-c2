import { Component } from '@angular/core';

interface Audience {
  title: string;
  description: string;
}

@Component({
  selector: 'app-audience-section',
  templateUrl: './audience-section.html',
  styleUrl: './audience-section.scss',
})
export class AudienceSection {
  protected readonly audiences: readonly Audience[] = [
    {
      title: 'Government',
      description:
        'Defense and government organizations that need airspace data delivered in the formats their C2 systems require.',
    },
    {
      title: 'Commercial',
      description:
        'Commercial and other non-government organizations working with radar and sensor-based airspace security.',
    },
  ];
}
