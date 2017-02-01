// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_normal;
attribute vec3 a_position;
varying vec3 v_perturbCoordAndAngle;
uniform vec3 u_holeTangentY;
uniform vec3 u_holeTangentX;
uniform vec3 u_holeNormal;
varying vec2 v_texCoord0;
uniform mat4 u_modelViewProject;
void main ()
{
  v_texCoord0 = a_texCoord0;
  vec4 tmpvar_1;
  tmpvar_1.w = 0.85;
  tmpvar_1.xyz = a_position;
  gl_Position = (u_modelViewProject * tmpvar_1);
  vec3 tmpvar_2;
  tmpvar_2 = (dot (a_normal, u_holeTangentX) * u_holeTangentX);
  vec3 tmpvar_3;
  tmpvar_3 = (dot (a_normal, u_holeTangentY) * u_holeTangentY);
  vec2 tmpvar_4;
  tmpvar_4.x = dot (tmpvar_2, u_holeTangentX);
  tmpvar_4.y = dot (tmpvar_3, u_holeTangentY);
  vec2 tmpvar_5;
  tmpvar_5.x = sqrt(dot (tmpvar_2, tmpvar_2));
  tmpvar_5.y = sqrt(dot (tmpvar_3, tmpvar_3));
  vec2 tmpvar_6;
  tmpvar_6 = (sign(tmpvar_4) * tmpvar_5);
  float r_7;
  if ((abs(tmpvar_6.x) > (1e-08 * abs(tmpvar_6.y)))) {
    float y_over_x_8;
    y_over_x_8 = (tmpvar_6.y / tmpvar_6.x);
    float s_9;
    float x_10;
    x_10 = (y_over_x_8 * inversesqrt(((y_over_x_8 * y_over_x_8) + 1.0)));
    s_9 = (sign(x_10) * (1.5708 - (sqrt((1.0 - abs(x_10))) * (1.5708 + (abs(x_10) * (-0.214602 + (abs(x_10) * (0.0865667 + (abs(x_10) * -0.0310296)))))))));
    r_7 = s_9;
    if ((tmpvar_6.x < 0.0)) {
      if ((tmpvar_6.y >= 0.0)) {
        r_7 = (s_9 + 3.14159);
      } else {
        r_7 = (r_7 - 3.14159);
      };
    };
  } else {
    r_7 = (sign(tmpvar_6.y) * 1.5708);
  };
  float tmpvar_11;
  float x_12;
  x_12 = dot (a_normal, u_holeNormal);
  tmpvar_11 = (1.5708 - (sign(x_12) * (1.5708 - (sqrt((1.0 - abs(x_12))) * (1.5708 + (abs(x_12) * (-0.214602 + (abs(x_12) * (0.0865667 + (abs(x_12) * -0.0310296))))))))));
  vec3 tmpvar_13;
  tmpvar_13.x = (r_7 * 0.159155);
  tmpvar_13.y = (tmpvar_11 * 0.31831);
  tmpvar_13.z = tmpvar_11;
  v_perturbCoordAndAngle = tmpvar_13;
}

