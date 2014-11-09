precision highp float;
varying lowp vec4 vColor;

uniform float time;
float yCoord;

void main(void) {
  gl_FragColor = vec4(time, gl_FragCoord.y + gl_FragCoord.x / 2.0, time, 1.0);
  //gl_FragColor = vColor; 
}
