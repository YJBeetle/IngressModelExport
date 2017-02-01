// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec3 v_texCoord0;
varying vec3 v_texCoord1;
varying vec4 v_color;
uniform sampler2D u_texture;
void main() {
 vec4 color0 = texture2D(u_texture, v_texCoord0.xy);
 vec4 color1 = texture2D(u_texture, v_texCoord1.xy);
 float noise = color0.b - color1.b;
 float pattern = color0.r;
 float tears = color0.g;
 float health = v_texCoord1.z;
 float tearMagnitude = 0.75;
 float tearSoftness = 10.0;
 float tearEdge = (health - (tears + noise * tearMagnitude)) * tearSoftness;
 float edgeMagnitude = 10.0;
 float dist = v_texCoord0.z - abs(noise) * edgeMagnitude;
 gl_FragColor.rgb = v_color.rgb * pattern;
 gl_FragColor.a = v_color.a * clamp(dist, 0.0, 1.0) * min(1.0, tearEdge);
}

