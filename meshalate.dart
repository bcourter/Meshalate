library meshalate;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' hide Ray;
import 'package:three/three.dart';
import 'package:three/extras/controls/trackball_controls.dart';
import 'package:three/extras/scene_utils.dart';

import 'lib/complex/complex.dart';
import 'lib/complex/disc.dart' ;

var camera, cameraTarget, scene, renderer;
var material, mesh, loader;
var controls;
var container, stats;

List<Geometry> geometry = [];

main() {
  init();
  animate(0);
}

init() {
  document.querySelector('#save').onClick.listen((e) => saveObj());
  container = document.querySelector('#container');

  camera = new PerspectiveCamera( 35.0, window.innerWidth / window.innerHeight, 1.0, 15.0 );
  camera.position.setValues( 3.0, 0.15, 3.0 );

  cameraTarget = new Vector3( 0.0, -0.25, 0.0 );

  scene = new Scene();
  scene.fog = new FogLinear( 0x000000, 2.0, 15.0 );

  // STL
  material = new MeshPhongMaterial( 
      ambient: 0x555555, 
      color: 0xAAAAAA, 
      specular: 0x111111, 
      shininess: 16, 
      side: DoubleSide,
      shading: FlatShading
  );
  
  List<int> indices = [0, 1, 2];
  List<Future> futures = indices.map((i) {
    return new STLLoader()
      .load('./resources/stl/4-5.40-$i.stl')
      .then((geom) {
        geometry.add(centerGeometry(geom));
      })
    ;
  }).toList();
  
  Future.wait(futures).then((List values) {
    Vector3 fn(v) => v;
    Disc disc = new Disc(new Region(4, 5), 0.991, 666, geometry, fn);
    
    //addMeshToScene(new CircleGeometry(1.0)); 
    disc.initialFace.edges.forEach((e) {
      Circle circle = e.circLine as Circle;
      Geometry c = new CircleGeometry(circle.radius, 24);
      Mesh m = new Mesh(c);
      m.translate(circle.center.modulus, circle.center.asVector3);
 //     scene.add(m);      
    });
    
    addMeshToScene(disc.discGeom);
  });
  
  // Lights
  scene.add( new AmbientLight(0x777777) );

  addShadowedLight( 1.0, 1.0, 1.0, 0xaaaaaa, 1.0 );
  addShadowedLight( 1.0, -1.0, 1.0, 0xaaaaaa, 1.0 );

  // renderer
  renderer = new WebGLRenderer( antialias: true, alpha: false );
  renderer.setSize( window.innerWidth, window.innerHeight );

  renderer.setClearColor( scene.fog.color, 1 );

  renderer.gammaInput = true;
  renderer.gammaOutput = true;
  renderer.physicallyBasedShading = true;

  renderer.shadowMapEnabled = true;
  //renderer.shadowMapCullFace = CullFaceBack;

  container.append( renderer.domElement );

  // controls
  controls = new TrackballControls( camera, renderer.domElement )
  ..rotateSpeed = 0.5
  ..addEventListener( 'change', (_) => render() );

  window.onResize.listen(onWindowResize);
}

void addMeshToScene(Geometry geometry) {
  var mesh = new Mesh(geometry, material);
  mesh.castShadow = true;
  mesh.receiveShadow = true;

  scene.add(mesh);
}

Geometry centerGeometry(geometry) {
    geometry.computeBoundingBox();
    var box = geometry.boundingBox;
    var vertices = geometry.vertices;
    for (int i = 0; i < vertices.length; i++) {  
        geometry.vertices[i] -= box.min;
    }

    return geometry;
}

void addShadowedLight( x, y, z, color, intensity ) {
  var directionalLight = new DirectionalLight( color, intensity );
  directionalLight.position.setValues( x, y, z );
  scene.add( directionalLight );

  directionalLight.castShadow = true;
  // directionalLight.shadowCameraVisible = true;

  var d = 1.0;
  directionalLight.shadowCameraLeft = -d;
  directionalLight.shadowCameraRight = d;
  directionalLight.shadowCameraTop = d;
  directionalLight.shadowCameraBottom = -d;

  directionalLight.shadowCameraNear = 1.0;
  directionalLight.shadowCameraFar = 4.0;

  directionalLight.shadowMapWidth = 1024;
  directionalLight.shadowMapHeight = 1024;

  directionalLight.shadowBias = -0.005;
  directionalLight.shadowDarkness = 0.15;
}

onWindowResize(_) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  controls.update();
  render();
}

render() {
  renderer.render( scene, camera );
}

void saveObj() {
  var op = createObjString(scene);
  var newWindow = window.open("", "obj");
  newWindow.document.body.innerHtml = op;
}

String createObjString(object3d) {
  var s = new StringBuffer();
  var offset = 1;

  traverseHierarchy(object3d, (child) {
    if (child is! Mesh) {
      return;
    }
    
    Mesh mesh = child;
    mesh.updateMatrixWorld();
    Geometry geometry = mesh.geometry;
    
    for (int i = 0; i < geometry.vertices.length; i++) {
      Vector3 vector = new Vector3(geometry.vertices[i].x, geometry.vertices[i].y, geometry.vertices[i].z);
      vector = mesh.matrixWorld * vector;
    
      s.write('v ${vector.x} ${vector.y} ${vector.z}<br>');
    }
    
    for (int i = 0; i < geometry.faces.length; i++) {
      s.write('f ');
      var face = geometry.faces[i];
      for (int j = 0; j < face.indices.length; j++) {
        s.write('${face.indices[j] + offset} ');
      }
      s.write('<br>');
    }

    offset += geometry.vertices.length;
  });

  return s.toString();
}