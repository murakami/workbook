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
GLuint  listID; /* ディスプレイリストID */

void resize(int w, int h)
{
    /* ウィンドウ全部を描画するようにビューポートを更新する */
    glViewport(0, 0, w, h);
    
    /* 投影行列とアスペクト比を更新する */
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    //gluPerspective(40.0, (double)w / (double)h, 1.0, 200.0);
    
    /* 表示ルーチン用にモデルビューモードに設定する */
    glMatrixMode(GL_MODELVIEW);
    
    glLoadIdentity();
    assert(glGetError() == GL_NO_ERROR);
    
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
    assert(glGetError() == GL_NO_ERROR);
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

void init(void)
{
    /* ディザ処理を無効にする */
    glDisable(GL_DITHER);
    
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    //GLfloat paleYellow[4] = {1.0, 1.0, 0.75, 1.0};
    //glLightfv(GL_LIGHT0, GL_DIFFUSE, paleYellow);
    //GLfloat white[4] = {1.0, 1.0, 1.0, 1.0};
    //glLightfv(GL_LIGHT0, GL_SPECULAR, white);
    GLfloat position[4] = {0.5, 0.0, -1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_POSITION, position);
    
    assert(glGetError() == GL_NO_ERROR);
    
    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutSpecialFunc(special);
    glutMouseFunc(mouse);
    glutMotionFunc(motion);
    glutIdleFunc(idle);
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        glutInit(&argc, (char **)argv);
        
        /* ダブルバッファ処理で作成する */
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
        glutInitWindowSize(width, height);
        glutInitWindowPosition(500, 100);
        glutCreateWindow("IRIS GL");
        init();
        
        glutMainLoop();
        
    }
    return 0;
}

