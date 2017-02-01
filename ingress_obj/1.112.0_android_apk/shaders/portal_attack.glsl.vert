// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
varying float v_alpha;
varying vec2 v_texCoord0;
uniform mat4 u_modelViewProject;
uniform vec2 u_xz0;
uniform vec2 u_xz1;
uniform float u_time;
attribute vec3 v_interps;
void main() {
 float stripA = v_interps.x;
 float rowA = v_interps.y;
 float edgeA = v_interps.z;
 vec3 u_pos0 = vec3(u_xz0, 1.0).xzy;
 vec3 u_pos1 = vec3(u_xz1, 3.2).xzy;
 float randStep = 1.0;
 float randCount = 3.0;
 float randTime = (u_time / randStep) + stripA + 5.0;
 float time0 = floor(randTime);
 float time1 = time0 + 1.0;
 vec2 time = vec2(time0, time1);
 vec2 rand = fract(time * time * time / (31.415926 + stripA));
 rand = (rand + mod(time + randCount * stripA, randCount)) / randCount;
 rand.y = rand.y + step(rand.y, rand.x);
 float randA = (randTime - time0) / (time1 - time0);
 float timeA = fract(mix(rand.x, rand.y, randA));
 vec3 axis = u_pos1 - u_pos0;
 float axisL = length(axis);
 axis = axis * 1.0 / axisL;
 vec3 tangent = normalize(vec3(-axis.z, 0.0, axis.x));
 float widthL = 10.0;
 float widthA = (0.5 - edgeA) * min(0.67 + 0.33 * rowA, 1.33 - 0.67 * rowA);
 vec3 width = tangent * widthA * widthL;
 float wanderL = 4.0 * min(rowA * rowA + 0.05 , 2.2 - 2.0 * rowA);
 float wanderA = fract(timeA);
 wanderA = fract(timeA + 1.0 - rowA);
 wanderA = 1.0 - (wanderA * wanderA * wanderA);
 wanderA = (min(wanderA, 1.0 - wanderA) - 0.25) * 4.0;
 wanderA = clamp(wanderA, -0.81, 0.81) + 2.0 * (stripA - 0.5);
 vec3 wander = tangent * wanderL * wanderA;
 float arcL = 4.0 * log(1.0 + 0.1 * axisL);
 float arcH = 2.0 * rowA - 1.0;
 float arc = arcL * (1.0 - arcH * arcH);
 vec3 pos = mix(u_pos0, u_pos1, rowA) + width + wander;
 pos.y = pos.y + arc;
 gl_Position = u_modelViewProject * vec4(pos, 1.0);
 v_alpha = min(1.0, 25.0 * min(rowA, 1.0 - rowA));
 v_alpha = v_alpha * step(0.25, mod(timeA + stripA, 0.5));
 v_texCoord0 = vec2(rowA * (pow(axisL, 0.9) / 12.0) - timeA, edgeA);
}

