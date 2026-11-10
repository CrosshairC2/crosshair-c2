export interface NavLink {
  id: string;
  label: string;
}

export const NAV_LINKS: NavLink[] = [
  { id: 'capabilities', label: 'Capabilities' },
  { id: 'audience', label: 'Who We Serve' },
  { id: 'about', label: 'About' },
  { id: 'contact', label: 'Contact' },
];
