//
//  DestroyerView.swift
//  Destroyer
//
//  Created by 村上幸雄 on 2017/12/10.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation
import MetalKit

/* 頂点と色の情報 */
struct Vertex {
    var position: vector_float4
    var color: vector_float4
}

class DestroyerView: MTKView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        /* デバイスを作成して設定する。 */
        self.device = MTLCreateSystemDefaultDevice()
        
        /* 三角形の頂点と色情報を用意 */
        let vertexData = [Vertex(position: [-0.8, -0.8, 0.0, 1.0], color: [1.0, 0.0, 0.0, 1.0]),
                          Vertex(position: [ 0.8, -0.8, 0.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]),
                          Vertex(position: [ 0.0,  0.8, 0.0, 1.0], color: [0.0, 0.0, 1.0, 1.0]),]
        let vertexBuffer = device?.makeBuffer(bytes: vertexData,
                                              length: MemoryLayout.size(ofValue: vertexData[0]) * vertexData.count,
                                              options: [])
        
        /* シェーダ・ライブラリを取得する。 */
        guard let library = device?.makeDefaultLibrary() else {
            return
        }
        
        /* シェーダーを設定する。 */
        let vertexFunction = library.makeFunction(name: "vertex_func")
        let fragmentFunction = library.makeFunction(name: "fragment_func")
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        /* RGBA 各8bit形式のピクセルを設定する。 */
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            /* パイプラインステートメントを作成する。 */
            let renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            
            /* レンダーパス記述子 */
            guard let renderPassDescriptor = self.currentRenderPassDescriptor, let drawable = self.currentDrawable else {
                return
            }
            
            /* クリアする色を設定 */
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.8, 0.7, 0.1, 1.0)
            
            /* コマンドキューを生成し、コマンドキューからコマンドバッファを生成する */
            let commandBuffer = device?.makeCommandQueue()?.makeCommandBuffer()
            
            /* シェーダへデータを送る */
            let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderCommandEncoder?.setRenderPipelineState(renderPipelineState!)
            renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            renderCommandEncoder?.endEncoding()
            
            /* コマンドバッファのコミット */
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
        catch let error {
            NSLog("\(error)")
        }
        
    }
}
