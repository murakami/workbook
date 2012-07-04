//
//  PrimitiveViewController.m
//  IRIS
//
//  Created by 村上 幸雄 on 12/07/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "PrimitiveViewController.h"

@interface PrimitiveViewController ()

@property (strong, nonatomic) EAGLContext   *context;
@property (assign, nonatomic) GLuint        defaultFramebuffer;
@property (assign, nonatomic) GLuint        colorRenderbuffer;
@property (assign, nonatomic) GLuint        depthRenderbuffer;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation PrimitiveViewController

@synthesize context = _context;
@synthesize defaultFramebuffer = _defaultFramebuffer;
@synthesize colorRenderbuffer = _colorRenderbuffer;
@synthesize depthRenderbuffer = _depthRenderbuffer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.defaultFramebuffer = 0;
        self.colorRenderbuffer = 0;
        self.depthRenderbuffer = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)viewDidUnload
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glGenFramebuffersOES(1, &_defaultFramebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.defaultFramebuffer);
    
    glGenRenderbuffersOES(1, &_colorRenderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.colorRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES,
                             GL_RGBA8_OES,
                             self.view.bounds.size.width,
                             self.view.bounds.size.height);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_COLOR_ATTACHMENT0_OES,
                                 GL_RENDERBUFFER_OES,
                                 self.colorRenderbuffer);

    glGenRenderbuffersOES(1, &_depthRenderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.depthRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES,
                             GL_DEPTH_COMPONENT16_OES,
                             self.view.bounds.size.width,
                             self.view.bounds.size.height);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_DEPTH_ATTACHMENT_OES,
                                 GL_RENDERBUFFER_OES,
                                 self.depthRenderbuffer);
    
    GLenum status = glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) ;
    if (status != GL_FRAMEBUFFER_COMPLETE_OES) {
        DBGMSG(@"failed to make complete framebuffer object %x", status);
    }
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];

    if (self.defaultFramebuffer) {
		glDeleteFramebuffersOES(1, &_defaultFramebuffer);
		self.defaultFramebuffer = 0;
	}
    
	if (self.colorRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
		self.colorRenderbuffer = 0;
	}
    
    if (self.depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
		self.depthRenderbuffer = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

/*
- (void)update
{
}
*/

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    /* 頂点の定義 */
    GLfloat vertices[] = {
        -0.5f, -0.5f,
        0.5f, -0.5f,
        0.0f, 0.5f,
	};
    
    /* カラー（RGBA）の定義 */
	GLubyte colors[] = {
		255, 0, 0, 255,
		255, 0, 0, 255,
		255, 0, 0, 255,
	};
	
    /* 頂点配列とカラー配列を有効 */
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
    /* 頂点配列とカラー配列を設定 */
	glVertexPointer(2 , GL_FLOAT , 0 , vertices);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    
    /* 描画 */
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
}

@end
