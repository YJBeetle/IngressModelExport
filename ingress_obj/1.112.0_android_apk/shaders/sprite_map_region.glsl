// Regional map rectangle shader that blends a 1-dimensional edge texture with a
// texture that is dimmed towards the center of a quad.
#ifdef FRAGMENT
#define LOWP lowp
precision mediump float;
#else
#define LOWP
#endif

#pragma optimize none

varying LOWP vec4 v_color;
varying vec4 v_texCoords;

#ifdef VERTEX

attribute vec2 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord0;
uniform mat4 u_projTrans;

void main()
{
  v_color = a_color;
  v_texCoords = vec4(a_texCoord0, a_position);
  gl_Position = u_projTrans * vec4(a_position, 0.0, 1.0);
}

#endif


#ifdef FRAGMENT

uniform sampler2D u_texture;
uniform vec2 u_centerPoint;
uniform float u_maxVertDistInv;

void main()
{
  LOWP vec4 hexTex = texture2D(u_texture, v_texCoords.xy);

  // p is inside the rectangle
  vec2 p = v_texCoords.zw;

  // compute dist from center point outward
  float centerDist = length(p - u_centerPoint);

  // dim the hexes near the center of the rectangle
  float hexDim = 0.4 + 0.8 * centerDist * u_maxVertDistInv;
  // the following clamp should not be necessary but it fixes a rendering
  // issue encountered on the Nexus 10.
  hexTex.a *= clamp(hexDim, 0.0, 1.0);

  gl_FragColor = v_color * hexTex;
}

#endif
