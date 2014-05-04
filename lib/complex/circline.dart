part of disc;

// http://www.cefns.nau.edu/~schulz/moe.pdf
abstract class CircLine {
	final double a, c;
	final Complex b;
	
	factory CircLine(a, b, c) {
		if (Accuracy.lengthIsZero(a)) {
			double scale = 1 / b.modulus;
			return new Line(b * scale, c * scale);
		}
		
		return new Circle(1.0, b / a, c / a);
	}
	
  bool operator ==(other) {
    if (other is! CircLine) return false;
    CircLine circLine = other;
    return Accuracy.lengthEquals(a, circLine.a) && b == circLine.b && Accuracy.lengthEquals(c, circLine.c);  
  }
  
  int get hashCode => a.hashCode ^ b.hashCode ^ c.hashCode;
  
  CircLine get conjugate;
  CircLine get inverse;
  CircLine get normalized;
  Mobius get asMobius;
	
// TODO port
	/*
	public abstract Complex Evaluate(double t);

	public abstract List<Intersection> Intersect(CircLine other);


*/
	
  /*
		public abstract CircLine Translate(Complex translation);

		public abstract CircLine Scale(Complex scale);

		public abstract Interval MinorInterval(double param0, double param1);

		public abstract Evaluation Project(Complex c);

		public abstract bool IsNormalTo(CircLine circLine);
*/

		/*
		public abstract Complex[] Polyline { get; }

		public struct Intersection {
			Complex point;
			double paramA, paramB;

			public Intersection(Complex point, double paramA, double paramB) {
				this.point = point;
				this.paramA = paramA;
				this.paramB = paramB;
			}

			public Complex Point { get { return point; } }

			public double ParamA { get { return paramA; } }

			public double ParamB { get { return paramB; } }
		}

		public struct Evaluation {
			Complex point;
			double param;

			public Evaluation(Complex point, double param) {
				this.point = point;
				this.param = param;
			}

			public Complex Point { get { return point; } }

			public double Param { get { return param; } }
		}

		public bool IsPointOnLeft(Complex p) {
			return a * p.ModulusSquared + (b.Conjugate * p + b * p.Conjugate).Re + c + Accuracy.LinearTolerance > 0;
		}
		
		public bool ContainsPoint(Complex p) {
			return Accuracy.LengthIsZero(a * p.ModulusSquared + (b.Conjugate * p + b * p.Conjugate).Re + c);
		}
		
		public bool ArePointsOnSameSide(Complex p1, Complex p2) {
			if (p1 == p2)
				return true;	
			
//			if (ContainsPoint(p1) || ContainsPoint(p2))
//				return true;
		
		return IsPointOnLeft(p1) ^ IsPointOnLeft(p2);
	}
	*/
	
}

