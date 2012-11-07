//
//  main.m
//  IRIS
//
//  Created by 村上 幸雄 on 2012/11/07.
//  Copyright (c) 2012年 村上 幸雄. All rights reserved.
//

#import <iostream>
#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/glut.h>

int width = 600;
int height = 500;
BOOL    isWireframe = NO;

void init(void)
{
}

void resize(int w, int h)
{
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    width = w;
    height = h;
}

void display(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (! isWireframe)
        glutSolidTeapot(0.5);
    else
        glutWireTeapot(0.5);
    
    glutSwapBuffers();
}

void keyboard(unsigned char key, int x, int y)
{
    switch((unsigned char)key) {
        case 'w':
            isWireframe = !isWireframe;
            break;
    }
}

void special(int key, int x, int y)
{
}

void mouse(int button, int state, int x, int y)
{
}

void motion(int x, int y)
{
}

void idle(void)
{
    glutPostRedisplay();
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        glutInit(&argc, (char **)argv);
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
        glutInitWindowSize(width, height);
        glutInitWindowPosition(500, 100);
        glutCreateWindow("IRIS GL");
        glutReshapeFunc(resize);
        glutDisplayFunc(display);
        glutKeyboardFunc(keyboard);
        glutSpecialFunc(special);
        glutMouseFunc(mouse);
        glutMotionFunc(motion);
        glutIdleFunc(idle);
        init();
        
        glutMainLoop();
        
    }
    return 0;
}

