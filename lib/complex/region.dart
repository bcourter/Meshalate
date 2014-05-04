part of disc;

class Region {
  final int p, q;
  double r, d, phi;
  Line l1, l2;
  Circle c;
  Complex p0, p1, p2;
  
  Region(this.p, this.q) {
      double sinP2 = Math.pow(Math.sin(Math.PI / p), 2);
      double cosQ2 = Math.pow(Math.cos(Math.PI / q), 2);
      r = Math.sqrt(sinP2 / (cosQ2 - sinP2));
      d = Math.sqrt(cosQ2 / (cosQ2 - sinP2));
      phi = Math.PI * (0.5 - (1.0 / p + 1.0 / q));
  
      l1 = new Line.throughPoints(Complex.zero, Complex.one);
      l2 = new Line.pointAngle(Complex.zero, Math.PI / p);
      c = new Circle.centerRadius(new Complex(d, 0.0), r);
  
      Complex polar = new Complex.polar(r, Math.PI - phi);
      p0 = Complex.zero;
      p1 = new Complex(d, 0.0) + polar;
      p2 = new Complex(d - r, 0.0);
  }
}
