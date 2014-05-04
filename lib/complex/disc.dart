library disc;

import 'dart:math' as Math;
import 'package:three/three.dart' as THREE;
import 'package:three/extras/geometry_utils.dart' as GeometryUtils;
import 'package:vector_math/vector_math.dart' show Vector3;
import 'complex.dart';

part 'circline.dart';
part 'circle.dart';
part 'line.dart';
part 'region.dart';
part 'edge.dart';
part 'face.dart';

class Disc {
  Region region;
  double sizeLimit;
  int maxRegions;
  List<THREE.Geometry> geometry;
  Function fn;
  
  Face initialFace;
  List<Face> faces = [];
  int drawCount = 1;
  int totalDraw = 0;
  
  THREE.Geometry discGeom;

  Disc(this.region, this.sizeLimit, this.maxRegions, this.geometry, this.fn) { 
    initialFace = new Face(region, geometry);
   	faces.add(initialFace);
  
    initFaces();
    toolFunction(discGeom, fn);
  }
  
  static THREE.Geometry toolFunction(THREE.Geometry geometryIn, Function fn) {
    THREE.Geometry geometry = new THREE.Geometry();
    var vertices = geometryIn.vertices;
    for (int i = 0; i < vertices.length; i++) {
        var vertex = vertices[i].clone();
        geometry.vertices.add(fn(vertex));
    }

    var faces = geometryIn.faces;
    for (var i = 0; i < faces.length; i++) {
        geometry.faces.add(faces[i]);
    }

    return geometry;
  }

  void initFaces() {
    Face seedFace = initialFace;
    List<Face> faceQueue = [seedFace];
    List<Complex> faceCenters = [Complex.zero];
    discGeom = initialFace.geometry[0].clone();

    int count = 1;
    while (faceQueue.length > 0 && count < maxRegions) {
      Face face = faceQueue.removeLast();

      for (int i = 0; i < face.edges.length; i++) {
        Edge edge = face.edges[i];
    //    if (edge.isConvex) continue;

        CircLine c = edge.circLine;
        if (c is! Circle) continue;

        Mobius mobius = edge.circLine.asMobius;
        var image = face.conjugate.transform(mobius);
 
        var p = image.center.asVector3;
        
        var faceCenter = fn(face.center.asVector3);
        var imageCenter = fn(image.center.asVector3);
        double r = (fn(faceCenter) - fn(imageCenter)).length;
        if (r < sizeLimit)
          continue;
        
        p = this.fn(p);
             

        bool halt = false;
        for (var j = 0; j < faceCenters.length; j++) {
          if (faceCenters[j] == image.center) {
            halt = true;
            break;
          }
        }
        if (halt) 
          continue;
        
        var n = 0;
          
        if (r < this.sizeLimit * 5)
            n = 1;
        if (r < this.sizeLimit * 10)
            n = 2;

        GeometryUtils.merge(discGeom, image.geometry[n]);
        faceQueue.add(image);
        faceCenters.add(image.center);
        count++;
       // break;
      }
    }

  }
  
}
