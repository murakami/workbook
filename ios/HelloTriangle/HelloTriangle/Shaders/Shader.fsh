//
//  Shader.fsh
//  HelloTriangle
//
//  Created by 村上幸雄 on 2014/08/11.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

/* precision宣言 16bit(half) */
precision mediump float;

void main()
{
    /* 赤色を設定 */
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}