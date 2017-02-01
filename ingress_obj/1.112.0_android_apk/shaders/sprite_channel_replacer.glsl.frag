// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying lowp vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;
uniform vec4 u_replaceColor;
uniform int u_replaceChannel;
void main()
{
 lowp vec4 tex = texture2D(u_texture, v_texCoords);
 float replaceFactor = tex.r;
 tex = vec4(0.0, tex.gba);
 vec4 replaceColor = vec4(u_replaceColor.rgb, tex.a * u_replaceColor.a);
 vec4 newColor = mix(tex, replaceColor, replaceFactor);
 gl_FragColor = v_color * newColor;
}

