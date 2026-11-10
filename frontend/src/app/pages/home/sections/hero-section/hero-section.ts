import { Component } from '@angular/core';
import { RadarSweep } from '../../../../shared/decorative/radar-sweep/radar-sweep';

@Component({
  selector: 'app-hero-section',
  imports: [RadarSweep],
  templateUrl: './hero-section.html',
  styleUrl: './hero-section.scss',
})
export class HeroSection {}
