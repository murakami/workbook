//
//  ViewController.m
//  HelloTriangle
//
//  Created by 村上幸雄 on 2014/08/11.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

GLfloat gVVertexData[] = {
    0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f
};

@interface ViewController () {
    GLuint _program;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* OpenGL ES 2.0コンテキストを生成 */
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        DBGMSG(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [self setupGL];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    /* コンテキストを設定 */
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    /* 頂点配列を生成し結合する */
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    /* バッファオブジェクトを生成し、結合後、頂点データを設定 */
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gVVertexData), gVVertexData, GL_STATIC_DRAW);
    
    /* 頂点属性配列を有効化し、バッファと関連づける */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    /* 頂点配列の結合を解除 */
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

/* 今回は動かないので空。 */
- (void)update
{
}

/* 描画。GLKViewデリゲートのメソッド。 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    /* カラーバッファをクリア */
    glClear(GL_COLOR_BUFFER_BIT);
    
    /* シャーダが含まれるプログラムオブジェクトを設定 */
    glUseProgram(_program);
    
    /* 頂点配列を結合する */
    glBindVertexArrayOES(_vertexArray);
    
    /* GL_TRIANGLESプリミティブで描画 */
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    /* プログラム・オブジェクトの生成 */
    _program = glCreateProgram();
    
    /* 頂点シェーダとフラグメント・シェーダのファイルを読み込み、コンパイルする */
    // Load the vertex/fragment shaders
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        DBGMSG(@"Failed to compile vertex shader");
        return NO;
    }
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        DBGMSG(@"Failed to compile fragment shader");
        return NO;
    }
    
    /* シェーダ・オブジェクトを登録 */
    glAttachShader(_program, vertShader);
    glAttachShader(_program, fragShader);
    
    /* 頂点シェーダ属性をGLKVertexAttribPosition(0)に結合する */
    glBindAttribLocation(_program, GLKVertexAttribPosition, "vPosition");
    
    /* プログラム・オブジェクトに関連づける */
    if (![self linkProgram:_program]) {
        DBGMSG(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        DBGMSG(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        DBGMSG(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    // Link the program
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        DBGMSG(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    // Check the link status
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        GLint infoLen = 0;
        glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &infoLen);
        if (1 < infoLen) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(_program, infoLen, NULL, infoLog);
            DBGMSG(@"%s Error linking program:\n%s\n", __func__, infoLog);
            free(infoLog);
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        DBGMSG(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end

/* End Of File */