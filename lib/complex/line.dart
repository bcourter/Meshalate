part of disc;

class Line implements CircLine {
  final double a = 0.0, c;
  final Complex b;
  
  Line(this. b, this.c) {
  	assert(b != Complex.zero);
  	assert(!c.isNaN);
  }
 
  Line.fromParameters(double a, double b, double c) : this(new Complex(a, b) / 2.0, c);  

  factory Line.pointAngle(Complex point, double angle) => new Line.throughPoints(point, point - new Complex.polar(1.0, angle));
 
  factory Line.throughPoints(Complex p1, Complex p2) {
  	double dx = p2.re - p1.re;
  	double dy = p2.im - p1.im;
  
  	return new Line.fromParameters(-dy, dx, dx * p1.im - dy * p1.re);
  }
   
  Complex evaluate(double t) {
  	// TBD scale t for lines so +/-pi -> infinity
  	double aa = 2 * b.re;
  	double bb = 2 * b.im;
  	if (Accuracy.lengthIsZero(aa))
  		return new Complex(t, c / bb);
  
  	if (Accuracy.lengthIsZero(bb))
  		return new Complex(c / aa, t);
  
  	Complex p0 = new Complex(c / aa, 0.0);
  	Complex p1 = new Complex(0.0, c / bb);
  	if (p1 == Complex.zero)
  		p1 = new Complex.polar(1.0, angle);
  
  	return p0 + (p1 - p0).normalized * t;
  }
  
  //properties
  Complex get origin => evaluate(0.0);
  double get angle => Math.PI - Math.atan2(b.re, b.im);
  Complex get direction => evaluate(1.0) - evaluate(0.0);
  CircLine get conjugate => new Line(b.conjugate, c);
  
  CircLine get inverse {
    if (Accuracy.lengthIsZero(c / 1000))
      return new Line(b.conjugate, 0.0);

    return new Circle(
      1.0, 
      b.conjugate / c, // similarly, this was b.conjugate, but the paper says this... http://www.cefns.nau.edu/~schulz/moe.pdf
      b.modulus / c
    );
  }
  
  CircLine get normalized => new Line(b / c, 1.0);
  Mobius get asMobius => new Mobius(b, Complex.one * c, Complex.zero, -b.conjugate);
  
  
  
  /*
  public override CircLine Translate(Complex translation) {
  	return Create(Origin + translation, Angle);
  }
  
  public override CircLine Scale(Complex scale) {
  	return Create(Origin * scale, Angle + scale.Argument);
  }
  
  public override Interval MinorInterval(double param0, double param1) {
  	double min = Math.Min(param0, param1);
  	double max = Math.Max(param0, param1);
  
  	return new Interval(min, max);
  }
  
  public override Evaluation Project(Complex p) {
  	double nearParam = Complex.Dot(p - Origin, Direction);
  	Complex nearPoint = Evaluate(nearParam);
  	return new Evaluation(nearPoint, nearParam);
  }
  
  public override List<Intersection> Intersect(CircLine other) {
  	List<Intersection > intersections = new List<Intersection>();
  
  	if (other is Circle) {
  		Circle otherC = (Circle)other;
  		intersections = otherC.Intersect(this);
  		if (intersections == null)
  			intersections = otherC.Intersect(this);
  
  		return intersections.Select(i => new CircLine.Intersection(i.Point, i.ParamB, i.ParamA)).ToList();
  	}
  
  	Line line = (Line)other;
  
  	Complex denominator = b.Conjugate * line.b - b * line.b.Conjugate;
  	if (denominator == Complex.Zero)
  		return null;
  
  	Complex z = -(b * line.c - line.b * c) / denominator;
  	intersections.Add(new Intersection(z, Project(z).Param, line.Project(z).Param));
  
  	return intersections;
  }
  
  public override bool IsNormalTo(CircLine circLine) {
  	if (circLine is Line)
  		return Math.Abs(Angle - ((Line)circLine).Angle) % (2 * Math.PI) == Math.PI;
  
  	Complex center = ((Circle)circLine).Center;
  	return this.Project(center).Point == center;
  }
  */
 
}
