part of disc;

class Face {
  Region region;
  List<THREE.Geometry> geometry;
  Complex center;
  bool isFlipped;
  List<Edge> edges = <Edge>[];
  Edge edge;
  Face.fromScratch(this.region, this.center, this.geometry, this.isFlipped);
  
  var origVertices;  
  Face(this.region, this.geometry) {
    int p = region.p;
    Mobius increment = new Mobius.rotation(2.0 * Math.PI / p);
    Complex midvertex = region.p1;
  
    var face = new Face.fromScratch(region, Complex.zero, [], false);
    edge = new Edge(this, region.c, midvertex, increment.inverse * midvertex);

    for (var n = 0; n < geometry.length; n++) {
      var geom = geometry[n].clone(); 
      face.geometry.add(new THREE.Geometry());
      origVertices = geom.vertices;

      var geomC = geom.clone();
     	var faces = geomC.faces;
    	for (var i = 0; i < faces.length; i++) {
    		var tmp = faces[i].a;
    		faces[i].a = faces[i].b;
    		faces[i].b = tmp;
    	}
  
      var rotation = Mobius.identity;
      for (var i = 0; i < p; i++) {
        rotation *= increment;
        
        if (n == 0) edges.add(edge.transform(rotation));
         
      	var newGeom = geom.clone(); 
      	var newGeomC = geomC.clone(); 
     		var newVertices = newGeom.vertices;
     		var newVerticesC = newGeomC.vertices;

    		for (var j = 0; j < geom.vertices.length; j++) {
    			Complex z = new Complex(geom.vertices[j].x, geom.vertices[j].y);
    			Complex zc = rotation * z.conjugate;
    			z = rotation * z;

    			newVertices[j] = new Vector3(z.re, z.im, geom.vertices[j].z);
    			newVerticesC[j] = new Vector3(zc.re, zc.im, geom.vertices[j].z);
    		}

    		GeometryUtils.merge(face.geometry[n], newGeom);
    		GeometryUtils.merge(face.geometry[n], newGeomC);
      }

      face.geometry[n].mergeVertices();
    }

    center = face.center;
    geometry = face.geometry;
    isFlipped = face.isFlipped;
  }
  
  Face.fromExisting(previous, edges, this.center, this.geometry, this.isFlipped) {
    region = previous.region;
    this.edges = edges;
  }
  
  Face transform(mobius) {  
    var geom = <THREE.Geometry>[];
    for (var n = 0; n < this.geometry.length; n++) {
    	geom.add(this.geometry[n].clone()); 
    	geom[n].vertices = geom[n].vertices.map((v) => (mobius * new Complex.fromVector3(v)).asVector3..z = v.z).toList();
    }

    var edges = this.edges.map((e) => e.transform(mobius)).toList();
    return new Face.fromExisting(this, edges, mobius * this.center, geom, isFlipped);
  }
  
  Face get conjugate {
    var geom = <THREE.Geometry>[];
    for (var n = 0; n < this.geometry.length; n++) {
    	geom.add(this.geometry[n].clone()); 
      geom[n].vertices = geom[n].vertices.map((v) => new Vector3(v.x, -v.y, v.z)).toList();


    	geom[n].faces.forEach((f) {
        var tmp = f.a;
        f.a = f.b;
        f.b = tmp;
        if (f is THREE.Face4) {
          tmp = f.c;
          f.c = f.d;
          f.d = tmp;          
        }
    	});

    }
  
    var edges = this.edges.map((e) => e.conjugate).toList();
 
    return new Face.fromExisting(this, edges, this.center.conjugate, geom, !isFlipped);
  }
  
}
