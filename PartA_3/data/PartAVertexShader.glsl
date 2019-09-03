#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec3 normal;

varying vec3 normalInterp;
varying vec3 vertPos;

void main(){

  gl_Position = transform * vertex;
  
  vec4 vertPos4 = modelview * vec4(vertex.xyz, 1.0);
  vertPos = vec3(vertPos4) / vertPos4.w;
  normalInterp = vec3(normalMatrix * normal);
    
}

