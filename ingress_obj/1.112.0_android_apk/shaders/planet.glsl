/**
* These shaders implement the rendering of the planet, along with the lat/lon grid and the
* pulsing location beacon.
* The planet rendering consists in a high resolution texture map of the country borders and
* coastlines that's represented as distance fields. We use the distance fields to smooth the
* border outlines and render a glow effect around them.
* Both the glow effect and the borders width is adjusting dynamically, function of the zoom
* level to give a sharp appearance at all times.
*
* The lat/lon grid is rendered by using a lookup texture.  If you want to change the thickness
* of the lines, you'll need to edit the texture.  If you want to keep the line width constant
* as you zoom in, you could use the derivatives of the texture coordinates to estimate how far
* zoomed you are, and threshold the texture value (or custom author mipmaps).
*
* The pulsing location beacon consist in an oscillating cosine wave with a solid center point.
* To make the cosine wave more sharp, we saturate the cosine function and clamp it to [-1 +1]
* The pulsing wave fades out with the distance from the beacon location.
* In order to render a circular beacon based on texture coordinates regardless of location,
* we need to compensate with the texture's aspect ratio as well as the texture mapping
* anisotropy. Without it the beacon would become oval with latitudes.
* Also as a result, the rendering of the beacon will work pretty well between 70 degrees of
* latitude. Beyond that the beacon loses its circular shape due to extreme projection
* anisotropy.
*/
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec4 v_texCoord0AndLatLng;
varying float v_intensity;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform mat4 u_modelView;
uniform vec3 u_lightDir;
attribute vec3 a_position;
attribute vec2 a_texCoord0;
void main() {
  const float pi = 3.14159265;
  gl_Position = u_modelViewProject * vec4(a_position, 1.0);
  vec4 normal = u_modelView * vec4(a_position, 0.0);

  // Determine the frequency of latlng lines
  const float latLinesStep = 360.0 / 10.0;
  const float lngLinesStep = 180.0 / 10.0;
  v_texCoord0AndLatLng.xy = vec2(a_texCoord0.x, a_texCoord0.y);
  v_texCoord0AndLatLng.zw = a_texCoord0 * vec2(latLinesStep, lngLinesStep);

  // TODO -- Don't let lighting go black, but keep a smooth transition. Clamp adds a hard line.
  v_intensity = clamp(dot(normal.xyz, u_lightDir), 0.1, 1.0);
}
#endif

#ifdef FRAGMENT
// TODO(dkornmann): See if some variables can be computed per vertex instead of per fragment.
// TODO(dkornmann): We may want to consider rendering the location beacon as a separate fragment
// shader, should performance become an issue.
uniform sampler2D u_texture;
uniform sampler2D u_borderGradient;
uniform vec3 u_glowRange;
uniform vec3 u_borderRange;
void main() {
  const vec3 borderColor = vec3(1.0, 1.0, 1.0);
  const vec3 glowColor = vec3(1.0, 0.659, 0.0);
  const vec3 gridColor = vec3(0.25, 0.25, 0.25);
  // Accessing alpha channel ONLY, because the source texture is a 1-channel map.
  float i = texture2D(u_texture, v_texCoord0AndLatLng.xy).a;

  // Start with map gridlines.
  // Accessing alpha channel ONLY, because the source texture is a 1-channel map.
  float gridStrength = texture2D(u_borderGradient, v_texCoord0AndLatLng.zw).a;
  vec3 mapColor = gridColor * gridStrength;

  // Adding the border and a border glow on-top of the gridlines.
  // We never want to have a hard transition (it will always add aliasing to the image).
  // To determine the color of the border + glow, we lerp between the two colors, and then
  // use the outer glow range as the alpha of the final color.
  float colorMix = clamp((i - u_borderRange.x) * u_borderRange.z, 0.0, 1.0);
  vec3 color = mix(glowColor, borderColor, colorMix);
  mapColor = mix(mapColor, color, clamp((i - u_glowRange.x) * u_glowRange.z, 0.0, 1.0));

  gl_FragColor = vec4(mapColor * v_intensity, 1.0);
}
#endif

