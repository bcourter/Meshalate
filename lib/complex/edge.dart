part of disc;

class Edge {
  Face face;
  CircLine circLine;
  Complex start, end;
  
  Edge(this.face, this.circLine, this.start, this.end);
  
  Edge transform(Mobius mobius) => new Edge(
    face, 
    mobius * circLine, 
    mobius * start, 
    mobius * end
  );
  
  Edge get conjugate => new Edge(
    face, 
    circLine.conjugate, 
    end.conjugate, 
    start.conjugate
  );
  
  bool get isConvex {
    if (circLine is! Circle) return false;

    double a1 = (end - start).argument;
    double a2 = ((circLine as Circle).center - start).argument;
  //  print("$a1 $a2 ${((a1 - a2 + 4.0 * Math.PI) % (2.0 * Math.PI)) < Math.PI + Accuracy.angularTolerance}");
    return ((a1 - a2 + 4.0 * Math.PI) % (2.0 * Math.PI)) < Math.PI + Accuracy.angularTolerance;
  }
}

