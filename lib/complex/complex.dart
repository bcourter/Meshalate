library complex;

import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' show Vector3;
import 'disc.dart';

part 'accuracy.dart';
part 'mobius.dart';

class Complex {
  final double re, im;

  Complex(this.re, this.im) {
    assert(!re.isNaN);
    assert(!im.isNaN);
  }

  Complex.polar(double r, double theta) : this(r * Math.cos(theta), r * Math.sin(theta));
  Complex.fromVector3(Vector3 v) : this(v.x, v.y);

  // complex operators
  bool operator ==(other) {
    if (other is! Complex) return false;
    Complex z = other;
    return (this - z).modulusSquared < Accuracy.linearToleranceSquared;  
  }
  
  Complex operator +(Complex z) {
    return new Complex(re + z.re, im + z.im); 
  }
  
  Complex operator -(Complex z) {
    return new Complex(re - z.re, im - z.im); 
  }
  
  Complex operator -() {
    return new Complex(-re, -im); 
  }
  
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg as double);
    }
    if (arg is Complex) {
      return _mul_complex(arg);
    }
    throw new ArgumentError(arg);
  }
  
  Complex _mul_scale(double s) {
    return new Complex(re * s, im * s); 
  }
  
  Complex _mul_complex(Complex z) {
    return new Complex(re * z.re - im * z.im, re * z.im + im * z.re); 
  }
  
  dynamic operator/(dynamic arg) {
    if (arg is double) {
      return _div_scale(arg);
    }
    if (arg is Complex) {
      return _div_complex(arg);
    }
    throw new ArgumentError(arg);
  }
  
  Complex _div_scale(double s) {
    assert(!Accuracy.lengthIsZero(s));
    return new Complex(re / s, im / s); 
  }
  
  Complex _div_complex(Complex z) {
    double automorphy = z.re * z.re + z.im * z.im;
    assert(!Accuracy.lengthIsZero(Math.sqrt(automorphy)));
    return new Complex((re * z.re + im * z.im) / automorphy, (im * z.re - re * z.im) / automorphy);
  }
  
  // functions  
  double dot(Complex z) {
    return re * z.re + im * z.im;   
  }
  
  String toString() {
    return "(${re}, ${im})";
  }
  
  // constants
  static final Complex zero = new Complex(0.0, 0.0);
  static final Complex one = new Complex(1.0, 0.0);
  static final Complex i = new Complex(0.0, 1.0);
  
  // properties
  double get modulus => Math.sqrt(re * re + im * im);
  double get modulusSquared => re * re + im * im;
  double get argument => Math.atan2(im, re);
  
  Complex get conjugate => new Complex(re, -im);
  
  Complex get normalized {
    double m = modulus;
    if (Accuracy.lengthIsZero(m))
      throw new ArgumentError("Zero modulus");
    
    return this / m;
  }
  
  Vector3 get asVector3 => new Vector3(re, im, 0.0);
  int get hashCode => re.hashCode ^ im.hashCode;  

  // static math fucntions
  static Complex sqrt(z) {
    var re = z.re;
    var im = z.im;
    
    if (im == 0) {
      if (re >= 0)
        return one * Math.sqrt(re);
      else
        return i * Math.sqrt(-re);
    }
    
    double m = z.modulus;
    return new Complex(
        Math.sqrt((re + m) / 2),
        Math.sqrt((-re + m) / 2) * im.sign          
    );
  }
  

  
}


//TODO: Implement

//  
//  Complex.exp = function(z) {
//  	return z.createPolar(z.modulus(), z.argument());
//  };
//  			
//  Complex.log = function(z) {
//   	return new Complex(Math.log(z.modulus()), z.argument());
//  };
//  
//  Complex.sinh = function(z) {
//   	return (Complex.exp(z) - Complex.exp(z.negative())).multiplyScalar(0.5);
//  };
//  
//  Complex.cosh = function(z) {
//   	return (Complex.exp(z) - Complex.exp(z.negative())).multiplyScalar(0.5);
//  };
//  
//  Complex.tanh = function(z) {
//   	return Complex.divide(Complex.sinh(z), Complex.cosh(z));
//  };
//  
//  
//  			// // For perfect band, use: pos = (4.0 / pi) * cAtanh(pos);
//  			// return 0.5 * (cLog(one + z) - cLog(one - z));
//  Complex.atanh = function(z) {
//  	return Complex.subtract(
//  		Complex.log(Complex.add(Complex.one, z)),
//  		Complex.log(Complex.subtract(Complex.one, z))
//  		).scale(0.5);
//  };
