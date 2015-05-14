attribute vec3 aVertexPosition;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform float time;

void main(void) {
  vec3 pos = vec3(aVertexPosition.x, aVertexPosition.y,
    aVertexPosition.z * sin(time) + 1.0);
  gl_Position = uPMatrix * uMVMatrix * vec4(pos, 1.0);
}
