// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
const vec3 xm_color = vec3(0.3789, 0.4648, 1.0);
varying vec2 v_texCoord0;
varying float v_alpha;
uniform mat4 u_modelViewProject;
uniform vec2 u_scale;
uniform vec2 u_mapCenter;
uniform float u_timeSec;
uniform vec4 u_globParams[120];
attribute vec3 a_position;
attribute vec2 a_texCoord0;
attribute float a_scale;
attribute float a_speed;
attribute float a_portalIndex;
attribute float a_index;
const vec3 y_hat = vec3(0.0, 1.0, 0.0);
void main() {
 int portalIndex = int(a_portalIndex);
 float nOffset = u_globParams[portalIndex].w;
 if (a_index >= 3.0  + nOffset || a_index < nOffset) {
 gl_Position = vec4(2.0, 0.0, 0.0, 1.0);
 } else {
 vec3 position = vec3(u_globParams[portalIndex].x + u_mapCenter.x,
 0.0,
 u_globParams[portalIndex].z + u_mapCenter.y);
 float timeOffset = nOffset - floor(nOffset);
 float elapsedTime = timeOffset * 30.0 + u_timeSec;
 float t = mod(a_speed * elapsedTime, 30.0);
 float tm = t * (1.0 / 30.0);
 v_alpha = floor(u_globParams[portalIndex].y);
 float hoover = u_globParams[portalIndex].y - v_alpha;
 v_alpha *= 1.0 / 128.0 ;
 float normIndex = (a_index - nOffset) * (1.0 / 3.0 );
 vec3 hooverDynamics = -position * min(1.0, hoover * (1.0 + normIndex));
 vec3 dynamics = a_position * 14.0 * (-2.0 + 2.0 * tm - 4.0 * step(tm, 0.5) * (tm - 0.5));
 v_texCoord0 = a_texCoord0;
 gl_Position = u_modelViewProject * vec4(position + dynamics + hooverDynamics, 1.0);
 float camScale = pow(gl_Position.z, 0.125);
 gl_Position.xy += u_scale * (a_texCoord0.xy - vec2(0.5)) * a_scale * camScale;
 }
}

