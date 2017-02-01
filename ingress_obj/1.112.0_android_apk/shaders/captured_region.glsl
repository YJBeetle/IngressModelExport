/**
 * The region shader packs the distance between each edge of the region to the center point
 * of the region in the z channel of the position.  This value can be used to figure out how
 * far from the region's boundary a given pixel is, and perform some thresholding or color
 * modulation.
 *
 * This shader scrolls two noise textures, combines them, and uses the combined value to modulate
 * the distance function per-pixel.  The modulated distance is then used to determine where the
 * edge of the region lies (going fully transparent out of the region), giving the appearance that
 * the edge of the region is slowly undulating.
 *
 * The shader also uses a top-down projection to determine texture coordinates for all regions.
 * This ensures that the texture is continuous and seamless between adjacent regions (and makes
 * the edge modulation somewhat coherent as well).  It does however require that the input
 * textures tile.
 *
 * To display health, the region visuals develop "rips" or holes near damaged portals.  Each
 * vertex is provided a health fraction of the portal at that location (or a constant in the
 * region center), and that gives us a value to threshold a texture that is used to modulate
 * the region alpha.
 *
 * The texture that this shader uses has the following breakdown:
 *  red channel - used as a greyscale tint against the region color.
 *  green channel - used as the threshold channel to create rips in the region
 *  blue channel - noise used to generate displacements
 */
#ifdef FRAGMENT
precision mediump float;
#endif

varying vec3 v_texCoord0;         // {tex uv, distance to edge}
varying vec3 v_texCoord1;         // {tex uv, health}
varying vec4 v_color;

#ifdef VERTEX

attribute vec4 a_position;        // {pos xz, distance to edge, health}
attribute vec4 a_color;

uniform mat4 u_modelViewProject;
uniform vec2 u_modelToTexOrigin;
uniform vec2 u_modelToTexScale;
uniform vec2 u_texCoordOffset0;
uniform vec2 u_texCoordOffset1;

void main() {
  v_color = a_color;
  v_texCoord0.xy = a_position.xy * u_modelToTexScale + u_modelToTexOrigin + u_texCoordOffset0;
  v_texCoord1.xy = v_texCoord0.xy + u_texCoordOffset1;
  v_texCoord0.z = a_position.z;
  v_texCoord1.z = pow(a_position.w, 0.75);
  gl_Position = u_modelViewProject * vec4(a_position.x, 0.0, a_position.y, 1.0);
}

#endif


#ifdef FRAGMENT

uniform sampler2D u_texture;

void main() {
  vec4 color0 = texture2D(u_texture, v_texCoord0.xy);
  vec4 color1 = texture2D(u_texture, v_texCoord1.xy);
  // Noise function used for various perturbations
  float noise = color0.b - color1.b;
  // Tiling greyscale pattern applied to the region color
  float pattern = color0.r;
  // Gradient texture used to rip tears in the region near damaged portals
  float tears = color0.g;
  // Modify the health value, pushing it towards a less damaged state.  This is an attempt
  // to modify the linear attribute interpolation to make it biased towards the damaged portal
  // (keeping the damage visuals located mostly near that portal).
  // PERF(jbates): moved pow to vertex for 10% speedup.
  float health = v_texCoord1.z;
  // Magnitude that we displace the edges of the tear texture (0 == use texture directly)
  float tearMagnitude = 0.75;
  // The larger this value, the sharper the transition between tears and the normal texture
  float tearSoftness = 10.0;
  float tearEdge = (health - (tears + noise * tearMagnitude)) * tearSoftness;
  // Size of the edge displacements (larger = bigger displacement from triangle edges)
  float edgeMagnitude = 10.0;
  float dist = v_texCoord0.z - abs(noise) * edgeMagnitude;
  gl_FragColor.rgb = v_color.rgb * pattern;
  gl_FragColor.a = v_color.a * clamp(dist, 0.0, 1.0) * min(1.0, tearEdge);
}

#endif

