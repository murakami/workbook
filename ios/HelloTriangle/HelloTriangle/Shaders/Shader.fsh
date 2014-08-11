//
//  Shader.fsh
//  HelloTriangle
//
//  Created by 村上幸雄 on 2014/08/11.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
