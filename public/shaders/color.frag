precision highp float;

uniform float time;
uniform float viewportWidth;

void main(void) {
  float y = gl_FragCoord.y / viewportWidth;
  float x = gl_FragCoord.x / viewportWidth;
  float deltaTime = x - time;
  if (deltaTime < 0.0)
    deltaTime = -deltaTime;
  if (deltaTime <= 0.6 && 0.7 >= deltaTime)
    y = 1.0;
  gl_FragColor = vec4(y, x, y, 1.0);
}
