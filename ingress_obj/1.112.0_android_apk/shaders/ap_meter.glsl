/**
* Custom sprite batch vertex shader.
*
* The shader was copied from
* {@link com.badlogic.gdx.graphics.g2d.SpriteBatch#createDefaultShader()}, and differs from the
* normal sprite batch vertex shader in these ways:
*
* The right half of the image is a mask with a special alpha blend function. Texture coordinates
* are adjusted, rgba is sampled from the left half, and a pixel mask value from the right. The
* pixel mask value is combined with the mask uniform and used to modulate alpha.
*
* It uses the different custom uniforms (as all custom shaders do).
*/
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec4 v_color;
// The xy are the rgba xy, z is the mask x (y is the same for rgba and mask).
varying vec3 v_texCoords;

#ifdef VERTEX
attribute vec2 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord0;
uniform mat4 u_projTrans;
uniform float regionX;
uniform float regionWidth;

void main()
{
  v_color = a_color;
  float rgbaX = regionX + 0.5 * (a_texCoord0.x - regionX);
  float maskX = rgbaX + regionWidth;
  v_texCoords = vec3(rgbaX, a_texCoord0.y, maskX);
  gl_Position =  u_projTrans * vec4(a_position, 0.0, 1.0);
}
#endif

#ifdef FRAGMENT
// The color to use as the highlight, proportional to the highlightFactor. The highlight
// applies as the given mask value approaches very close to the texture's mask value, e.g used
// to highlight the current level.
const vec3 HIGHLIGHT_COLOR = vec3(1.0, .9, .7);

uniform sampler2D u_texture;
uniform float mask;
// The amount of highlight to apply.
uniform float highlightFactor;
uniform vec4 overdriveColor;
uniform float overdriveFactor;

void main()
{
  vec4 maskColor = texture2D(u_texture, v_texCoords.zy);
  vec4 rgbaColor = texture2D(u_texture, v_texCoords.xy);
  float overdriveThreshold = step(maskColor.a, overdriveFactor);
  vec4 factionColor = vec4(mix(overdriveColor.rgb, v_color.rgb, overdriveThreshold), v_color.a);
  float maskDiff = max(0.0, maskColor.a - mask);
  float highlightDiff = abs(maskColor.a - mask);
  // This affects a steep linear alpha ramp at the edge of the mask, for softer animation.
  // TOOD(leorleor): Parameterize this alpha ramp calc as needed.
  float maskAlpha = max(0.0, 1.0 - (50.0 * maskDiff));
  // Highlight the edge of the mask according to the highlight factor.
  float highlightAlpha = highlightFactor * max(0.0, 1.0 - (10.0 * highlightDiff));
  vec3 frag_rgb = mix(factionColor.rgb * rgbaColor.rgb, HIGHLIGHT_COLOR, highlightAlpha);
  gl_FragColor = vec4(frag_rgb, factionColor.a * rgbaColor.a * maskAlpha);
}
#endif

