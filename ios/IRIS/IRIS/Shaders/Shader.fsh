//
//  Shader.fsh
//  IRIS
//
//  Created by 村上 幸雄 on 12/07/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
