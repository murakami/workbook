#version 410

layout (location=0) in vec3 vertex_pos;
layout (location=1) in vec4 vertex_color;
out vec4 color;

void main()
{
    gl_Position = vec4(vertex_pos, 1.0);
    color = vertex_color;
}

/* End Of File */
