#version 410

layout (location=0) in vec3 vertex_pos; /* 0番目の入力: 頂点の座標 */
layout (location=1) in vec4 vertex_color;   /* 1番目の入力: 頂点の色情報 */
out vec4 color; /* フラグメント・シェーダに渡す色情報 */

void main()
{
    gl_Position = vec4(vertex_pos, 1.0);    /* 受け取った座標をそのままの位置に表示する */
    color = vertex_color;
}

/* End Of File */
