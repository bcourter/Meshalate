part of disc;

class Circle implements CircLine {
  final double a, c;
  final Complex b;
  
  static final unit = new Circle.centerRadius(Complex.zero, 1.0);
  
	Circle(this.a, this.b, this.c);
	Circle.centerRadius(Complex center, double radius) : this(1.0, -center, center.modulusSquared - radius * radius);
	
// properties

  Complex get center => -b / a; 
  double get radiusSquared => center.modulusSquared - c / a;
  double get radius => Math.sqrt(radiusSquared);
  CircLine get conjugate => new Circle(a, b.conjugate, c); 
  CircLine get normalized => new Circle(1.0, b / a, c / a);

  CircLine get inverse {
    if (Accuracy.lengthIsZero((center.modulusSquared - radiusSquared))) {
      return new Line(-b.conjugate, 1.0);
    }

    return new Circle(center.modulusSquared - radiusSquared, -center.conjugate, 1.0);
  }

  Mobius get asMobius => new Mobius(center, new Complex(radiusSquared - center.modulusSquared, 0.0), Complex.one, b.conjugate);

	/*
	public override List<Intersection> Intersect(CircLine other) {
		List<Intersection > intersections = new List<Intersection>();

		if (other is Circle) {
			Circle otherC = (Circle)other;

			Complex p0 = this.Center;
			Complex p1 = otherC.Center;
			double d = (p1 - p0).Modulus;
			double r0 = this.Radius;
			double r1 = otherC.Radius;

			if (d > (r0 + r1)) // outside
				return null;
			if (d < Math.Abs(r0 - r1))
				return intersections;
			if (d == 0)
				return intersections;

			double a = (r0 * r0 - r1 * r1 + d * d) / (2 * d);
			double h = Math.Sqrt(r0 * r0 - a * a);
			Complex p2 = p0 + a * (p1 - p0) / d;

			Complex intersect;
			intersect = new Complex(
					p2.Re + h * (p1.Im - p0.Im) / d,
					p2.Im - h * (p1.Re - p0.Re) / d
				);

			intersections.Add(new Intersection(
				intersect,
				Math.Atan2(p0.Im - intersect.Im, p0.Re - intersect.Re),
				Math.Atan2(p1.Im - intersect.Im, p1.Re - intersect.Re)
			));

			intersect = new Complex(
				p2.Re - h * (p1.Im - p0.Im) / d,
				p2.Im + h * (p1.Re - p0.Re) / d
			);

			intersections.Add(new Intersection(
				intersect,
				Math.Atan2(p0.Im - intersect.Im, p0.Re - intersect.Re),
				Math.Atan2(p1.Im - intersect.Im, p1.Re - intersect.Re)
			));

			return intersections;
		}

		Line line = (Line)other;

		Complex nearPoint = line.Project(Center).Point - line.Origin;

		double dist = (Center - nearPoint).Modulus;
		if (dist - Radius > 0)
			return null;

		Complex p;

		p = Line.Create(nearPoint, line.Angle).Evaluate(Math.Sqrt(RadiusSquared - dist * dist));
		intersections.Add(new Intersection(
			p,
			line.Angle - Math.Asin(dist / Radius),
			line.Project(p).Param
		));

		p = Line.Create(nearPoint, line.Angle).Evaluate(-Math.Sqrt(RadiusSquared - dist * dist));
		intersections.Add(new Intersection(
			p,
			line.Angle + Math.Asin(dist / Radius) + Math.PI,
			line.Project(p).Param
		));

		return intersections;
	}

	public override Interval MinorInterval(double param0, double param1) {
		if (param0 < 0)
			param0 = 2 * Math.PI + (param0 % (2 * Math.PI));
		if (param1 < 0)
			param1 = 2 * Math.PI + (param1 % (2 * Math.PI));
		param0 %= 2 * Math.PI;
		param1 %= 2 * Math.PI;

		double min = Math.Min(param0, param1);
		double max = Math.Max(param0, param1);

		if (max - min < Math.PI)
			return new Interval(min, max);

		return new Interval(max, min + 2 * Math.PI);
	}

	public override Evaluation Project(Complex p) {
		double nearParam = (p - Center).Argument;
		Complex nearPoint = Evaluate(nearParam);
		return new Evaluation(nearPoint, nearParam);
	}

	public override Complex Evaluate(double t) {
		return Center + Complex.CreatePolar(Radius, t);
	}

	public override CircLine Translate(Complex translation) {
		return CreateFromRadiusSquared(Center + translation, RadiusSquared);
	}

	public override CircLine Scale(Complex scale) {
		return Create(Center * scale, Radius * scale.Modulus);
	}

	public override bool IsNormalTo(CircLine circLine) {
		if (circLine is Line)
			return circLine.IsNormalTo(this);

		List<Intersection > intersections = this.Intersect(circLine);
		if (intersections == null || intersections.Count == 0)
			return false;

		Circle other = (Circle)circLine;
		Complex p = intersections[0].Point;

		return Accuracy.AngularTolerance > 
			Math.Abs((p - this.Center).ModulusSquared + (p - other.Center).ModulusSquared - (this.Center - other.Center).ModulusSquared);
	}
	
	*/
}

