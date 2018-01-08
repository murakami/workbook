//
//  MyGLView.m
//  Crimson
//
//  Created by 村上幸雄 on 2018/01/03.
//  Copyright © 2018年 Bitz Co., Ltd. All rights reserved.
//

@import GLKit;
@import OpenGL;
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <OpenGL/glu.h>
#import "MyGLView.h"

@interface MyGLView ()
@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) GLuint vertexShader;
@property (nonatomic, assign) GLuint fragmentShader;
@property (nonatomic, assign) GLuint vbo;   /* vertex buffer object */
@property (nonatomic, assign) GLuint vao;   /* vertex array object */
- (GLchar *)readResource:(NSString *)name ofType:(NSString *)ext;
@end

@implementation MyGLView

- (instancetype)initWithFrame:(NSRect)frame
{
    NSOpenGLPixelFormatAttribute attrs[] = {
        NSOpenGLPFAAllowOfflineRenderers,
            /* If present, this attribute indicates that offline renderers may be used. */
        NSOpenGLPFAAccelerated,     /* require hardware-accelerated pixelformat */
        NSOpenGLPFADoubleBuffer,    /* require double-buffered pixelformat */
        NSOpenGLPFAColorSize, 32,   /* require 32 bits for color-channels */
        NSOpenGLPFADepthSize, 32,   /* require a 32-bit depth buffer */
        NSOpenGLPFAMultisample,
        NSOpenGLPFASampleBuffers, 1,
            /* Value is a nonnegative number indicating the number of multisample buffers. */
        NSOpenGLPFASamples, 4,
            /* Value is a nonnegative indicating the number of samples per multisample buffer. */
        NSOpenGLPFANoRecovery,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,    /* OpenGO最新版を指定 */
            /* The requested profile must implement the OpenGL 3.2 core functionality. */
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    self = [super initWithFrame:frame pixelFormat:pixelFormat];
    if (self) {
        [self setWantsBestResolutionOpenGLSurface:YES]; /* Retina Display対応 */
    }
    return self;
}

/*
 Used by subclasses to initialize OpenGL state.
 This method is called only once after the OpenGL context is made the current context.
 Subclasses that implement this method can use it to configure the Open GL state in preparation for drawing.
 */
- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    NSOpenGLContext *glContext = [self openGLContext];
    
    self.vertexShader = glCreateShader(GL_VERTEX_SHADER);   /* 頂点シェーダ・ハンドル */
    const GLchar *vertexSource = [self readResource:@"MyShader" ofType:@"vsh"]; /* シェーダのソースコードの読み込み */
    glShaderSource(self.vertexShader, 1, &vertexSource, NULL);  /* シェーダのソースコードを設定 */
    glCompileShader(self.vertexShader); /* コンパイル */
    free((void *)vertexSource);
 
    self.fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);   /* フラグメント・シェーダ・ハンドル */
    const GLchar *fragmentSource = [self readResource:@"MyShader" ofType:@"fsh"];    /* シェーダのソースコードの読み込み */
    glShaderSource(self.fragmentShader, 1, &fragmentSource, NULL);  /* シェーダのソースコードを設定 */
    glCompileShader(self.fragmentShader);   /* コンパイル */
    free((void *)fragmentSource);
    
    self.program = glCreateProgram();   /* プログラム・ハンドル */
    
    glAttachShader(self.program, self.vertexShader);    /* プログラムに頂点シェーダを割り当てる */
    glAttachShader(self.program, self.fragmentShader);  /* プログラムにフラグメント・シェーダを割り当てる */
    glLinkProgram(self.program);    /* リンク */
    
    glGenBuffers(1, &_vbo); /* VBOを作成 */
    glBindBuffer(GL_ARRAY_BUFFER, self.vbo);    /* 頂点シェーダに渡すデータ配列 */
    GLfloat data[] = {
        -0.8f, -0.8f, 0.0f,     /* 頂点の座標 */
        1.0f, 0.0f, 0.0f, 1.0f, /* 頂点の色情報 */
        
        0.8f, -0.8f, 0.0f,      /* 頂点の座標 */
        0.0f, 1.0f, 0.0f, 1.0f, /* 頂点の色情報 */
        
        0.0f,  0.8f, 0.0f,      /* 頂点の座標 */
        0.0f, 0.0f, 1.0f, 1.0f, /* 頂点の色情報 */
    };
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 7 * 3, data, GL_STATIC_DRAW);   /* GPUに転送 */
    
    glGenVertexArrays(1, &_vao);    /* VAOを作成 */
    glBindVertexArray(self.vao);    /* OpenGLコンテキストに結びつける */
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 7, (GLfloat *)0); /* インデックス0: 頂点の色情報 */
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 7, ((GLfloat *)0) + 3);   /* インデックス1: 頂点の色情報 */
    
    glClearColor(0.2f, 0.4f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    [glContext flushBuffer];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    /* ビューポートのサイズ */
    NSSize size = dirtyRect.size;
    size = [self convertSizeToBacking:size];
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSRect viewportRect;
    viewportRect.origin.x = 0.0;
    viewportRect.origin.y = 0.0;
    viewportRect.size.width = width;
    viewportRect.size.height = height;
    
    glViewport(viewportRect.origin.x, viewportRect.origin.y, viewportRect.size.width, viewportRect.size.height);    /* ビューポートの指定 */
    
    glUseProgram(self.program); /* レンダリングで使用するシェーダを設定 */
    
    glClearColor(0.2f, 0.4f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArray(self.vao);    /* VAOを結びつける */
    glEnableVertexAttribArray(0);   /* 頂点属性を指定 */
    glEnableVertexAttribArray(1);   /* 頂点属性を指定 */
    glDrawArrays(GL_TRIANGLES, 0, 3);   /* レンダリング */
    
    [[self openGLContext] flushBuffer];
}

- (GLchar *)readResource:(NSString *)name ofType:(NSString *)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSError *error = nil;
    NSString *res = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    char *src = malloc(strlen(res.UTF8String) + 1);
    strcpy(src, res.UTF8String);
    return (GLchar *)src;
}

@end
