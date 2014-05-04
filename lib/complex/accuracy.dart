part of complex;

class Accuracy {
  
  static const double linearTolerance = 1E-5;
  static const double angularTolerance = 1E-2;
  static const double linearToleranceSquared = linearTolerance * linearTolerance;
  static const double maxLength = 100.0;
  
  static bool lengthEquals(a, b) {
  	return (a - b).abs() < linearTolerance;
  }
  
  static bool lengthIsZero(a) {
  	return a.abs() < linearTolerance;
  }
  
  static bool angleEquals(a, b) {
  	return (a - b).abs() < angularTolerance;
  }
  
  static bool angleIsZero(a) {
  	return a.abs() < angularTolerance;
  }
	
}