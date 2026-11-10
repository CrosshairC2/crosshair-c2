import { Component } from '@angular/core';

interface Capability {
  title: string;
  description: string;
}

@Component({
  selector: 'app-capabilities-section',
  templateUrl: './capabilities-section.html',
  styleUrl: './capabilities-section.scss',
})
export class CapabilitiesSection {
  protected readonly capabilities: readonly Capability[] = [
    {
      title: 'Multi-format ingestion',
      description: 'Works with radar and sensor data feeds across a range of source formats.',
    },
    {
      title: 'Parsing & normalization',
      description: 'Turns raw feed data into a consistent internal model.',
    },
    {
      title: 'Jamming detection',
      description: 'Flags anomalies in sensor data consistent with jamming activity.',
    },
    {
      title: 'Intrusion anomaly detection',
      description: 'Surfaces unauthorized or unexpected activity in monitored airspace.',
    },
    {
      title: 'C2-ready format conversion',
      description: 'Outputs data in the format your downstream systems need.',
    },
    {
      title: 'Flexible integration',
      description: 'Fits into existing C2 architectures rather than replacing them.',
    },
  ];
}
