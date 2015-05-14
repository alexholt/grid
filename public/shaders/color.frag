precision mediump float;

uniform float viewportWidth;
uniform int cubeId;
uniform vec3 cubeColor;

void main(void) {
  gl_FragColor = vec4( cubeColor, 1.0);
}
