//
//  Destroyer.metal
//  Destroyer
//
//  Created by 村上幸雄 on 2017/12/10.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float4 color;
};

/* バーテックスシェーダ */
vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]],
                          uint vid [[vertex_id]]) {
    return vertices[vid];
}

/* フラグメントシェーダ */
fragment float4 fragment_func(Vertex vert [[stage_in]]) {
    float3 inColor = float3(vert.color.x, vert.color.y, vert.color.z);
    float4 outColor = float4(inColor.x, inColor.y, inColor.z, 1);
    return outColor;
}
