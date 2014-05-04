part of complex;

class Mobius {
  final Complex a, b, c, d;
  
  static final Mobius identity = new Mobius(Complex.one, Complex.zero, Complex.zero, Complex.one);  

  Mobius(this.a, this.b, this.c, this.d) {
   //assert(a * d - b * c != Complex.zero);
  }
  
  Mobius.rotation(double phi) : this(new Complex.polar(1.0, phi), Complex.zero, Complex.zero, Complex.one);  
  Mobius.translation(Complex translation) : this(Complex.one, translation, Complex.zero, Complex.one);
  factory Mobius.discAutomorphism(Complex a, double phi) => new Mobius.rotation(phi) * new Mobius(Complex.one, -a, a.conjugate, -Complex.one);
  factory Mobius.discTranslation(Complex a, Complex b) => new Mobius.discAutomorphism(b, 0.0) * new Mobius.discAutomorphism(a, 0.0).inverse;
          
// operators
  dynamic operator*(dynamic arg) {
    if (arg is Complex) return _mul_complex(arg);
    if (arg is Mobius) return _mul_mobius(arg);
    if (arg is CircLine) return _mul_circline(arg);
    if (arg is num) return _mul_scale(arg as double);
    throw new ArgumentError(arg);
  }
  
  Complex _mul_complex(Complex z) {
    return (a * z + b) / (c * z + d); 
  }
  
  Mobius _mul_mobius(Mobius m) {
    return new Mobius(
      a * m.a + b * m.c,
      a * m.b + b * m.d,
      c * m.a + d * m.c,
      c * m.b + d * m.d
    );
  }
     
  Mobius _mul_scale(double s) {
    return new Mobius(a * s, b * s, c, d);
  }
  
  // these sources don't seem to agree, and what I ended up using is still different.  WHY?
  // http://en.wikipedia.org/wiki/Generalised_circle
  // http://www.math.ubc.ca/~cass/research/pdf/Geometry.pdf
  // http://www.math.okstate.edu/~wrightd/INDRA/MobiusonCircles.mpl
  CircLine _mul_circline(CircLine circLine) {
Mobius a = inverse.transpose;
    Mobius b=    new Mobius(new Complex(circLine.a, 0.0), circLine.b.conjugate, circLine.b, new Complex(circLine.c, 0.0)) ; 
    Mobius c = inverse.conjugate;
    Mobius hermitian = inverse.transpose * 
        new Mobius(new Complex(circLine.a, 0.0), circLine.b.conjugate, circLine.b, new Complex(circLine.c, 0.0)) * 
        inverse.conjugate;
    
  //  print("${hermitian.a.re} ${hermitian.c.re} ${hermitian.c.im} ${hermitian.d.re}");
Mobius ab = a*b;
    return new CircLine(hermitian.a.re, hermitian.c, hermitian.d.re);
  }
    
// properties     
  Mobius get inverse => new Mobius(d, -b, -c, a);
  Mobius get conjugate => new Mobius(a.conjugate, b.conjugate, c.conjugate, d.conjugate);
  Mobius get transpose => new Mobius(a, c, b, d);
  Mobius get conjugateTranspose => new Mobius(a.conjugate, c.conjugate, b.conjugate, d.conjugate);

}
