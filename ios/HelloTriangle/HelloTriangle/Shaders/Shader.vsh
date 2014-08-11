//
//  Shader.vsh
//  HelloTriangle
//
//  Created by 村上幸雄 on 2014/08/11.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

/* 頂点バッファvPositionを入力バッファに配置  */
attribute vec4 vPosition;

void main()
{
    /* vPositionを頂点座標に設定*/
    gl_Position = vPosition;
}
