attribute vec3  in_position3D;

void main()
{
   gl_Position = vec4(in_position3D, 1.0);
}
