library periodic_table;

import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart' as THREE;
import 'package:three/extras/controls/trackball_controls.dart';

var camera, scene, renderer;
var geometry, material, mesh;

var controls;

var objects = [];

init() {

  var targets = { "table": [], "sphere": [], "helix": [], "grid": [] };

  camera = new THREE.PerspectiveCamera( 75.0, window.innerWidth / window.innerHeight, 1.0, 5000.0 );
  camera.position.z = 1800.0;
  
  scene = new THREE.Scene();
  
  var loader = new THREE.STLLoader();
  loader.load( './resources/stl/4-5.40-0.stl').then((geometry) {
    var material = new THREE.MeshPhongMaterial( ambient: 0xff5533, color: 0xff5533, specular: 0x111111, shininess: 200 );
    var mesh = new THREE.Mesh( geometry, material );

  //  mesh.position.setValues( 0.0, - 0.37, - 0.6 );
  //  mesh.rotation.setValues( - Math.PI / 2, 0.0, 0.0 );
  // mesh.scale.setValues( 2.0, 2.0, 2.0 );
    
  //  mesh.castShadow = true;
 // mesh.receiveShadow = true;

    scene.add(mesh);
  });
  
  // Lights
  scene.add( new THREE.AmbientLight( 0x777777 ) );

  addShadowedLight( 1.0, 1.0, 1.0, 0xffffff, 1.35 );
  addShadowedLight( 0.5, 1.0, -1.0, 0xffaa00, 1.0 );
  
  // renderer
  renderer = new THREE.WebGLRenderer( antialias: true, alpha: false );
  renderer.setSize( window.innerWidth, window.innerHeight );

  renderer.setClearColor( new THREE.Color(0x111111), 1 );

  renderer.gammaInput = true;
  renderer.gammaOutput = true;
  renderer.physicallyBasedShading = true;

  renderer.shadowMapEnabled = true;
  //renderer.shadowMapCullFace = CullFaceBack;

  document.querySelector( '#container' ).children.add( renderer.domElement );

  // controls
  controls = new TrackballControls( camera, renderer.domElement )
  ..rotateSpeed = 0.5
  ..addEventListener( 'change', (_) => render() );

 // document.querySelector( '#table' ).onClick.listen((e) => transform( e.target, targets["table"], 2000 ));
  //document.querySelector( '#sphere' ).onClick.listen((e) => transform( e.target, targets["sphere"], 2000 ));
 // document.querySelector( '#helix' ).onClick.listen((e) => transform( e.target, targets["helix"], 2000 ));
 // document.querySelector( '#grid' ).onClick.listen((e) => transform( e.target, targets["grid"], 2000 ));
  
//  renderer.render( scene, camera );

  window.onResize.listen(onWindowResize);
}

addShadowedLight( x, y, z, color, intensity ) {

  var directionalLight = new THREE.DirectionalLight( color, intensity );
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

  render();
  controls.update();
}

render() {
  renderer.render( scene, camera );
}

main() {
  init();
  animate(0);
}