uniform mat4    uViewProjectionMatrix;
uniform mat4    uModelMatrix;

attribute vec3  in_position3D;

void main()
{
   gl_Position = uViewProjectionMatrix * uModelMatrix * vec4(in_position3D, 1.0);
}
