//
//  MyOpenGLView.m
//  GoldenTriangle
//
//  Created by 村上幸雄 on 2020/11/26.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>

static void drawAnObject ()
{
    glColor3f(1.0f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f(  0.0,  0.6, 0.0);
        glVertex3f( -0.2, -0.3, 0.0);
        glVertex3f(  0.2, -0.3 ,0.0);
    }
    glEnd();
}

@implementation MyOpenGLView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

@end
