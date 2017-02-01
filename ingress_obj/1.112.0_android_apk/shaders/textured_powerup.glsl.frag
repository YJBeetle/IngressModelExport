// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform sampler2D u_texture2;
uniform mat4 u_modelViewProject;
uniform float u_flicker;
varying vec2 v_texCoord0;
varying vec4 v_texCoord0And1;
vec4 getPowerupColor() {
 vec4 tex = texture2D(u_texture, v_texCoord0And1.xy);
 vec4 tex2 = texture2D(u_texture2, v_texCoord0And1.zw);
 vec3 outColor = tex.rgb;
 outColor.rb += vec2(tex2.r * 1.5);
 float alpha = tex.a * u_flicker;
 return vec4(outColor, alpha);
}
void main() {
 vec4 outColor = getPowerupColor();
 gl_FragColor = vec4(outColor.rgb, outColor.a);
}

