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
varying vec4 v_texCoords;
uniform sampler2D u_texture;
uniform vec2 u_centerPoint;
uniform float u_maxVertDistInv;
void main()
{
 lowp vec4 hexTex = texture2D(u_texture, v_texCoords.xy);
 vec2 p = v_texCoords.zw;
 float centerDist = length(p - u_centerPoint);
 float hexDim = 0.4 + 0.8 * centerDist * u_maxVertDistInv;
 hexTex.a *= clamp(hexDim, 0.0, 1.0);
 gl_FragColor = v_color * hexTex;
}

