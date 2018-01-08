#version 410

in vec4 color;  /* 頂点シェーダから渡された色情報 */
layout (location=0) out vec4 frag_color;    /* ピクセルの色 */

void main()
{
    frag_color = color; /* 渡された色情報をそのまま出力 */
}

/* End Of File */
