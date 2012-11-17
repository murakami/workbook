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
    /* 視体積を設定 */
    //gluPerspective(40.0, (GLdouble)w / (GLdouble)h, 1.0, 200.0);
    
    /* ウィンドウ・サイズとOpenGLの座標を対応づける */
    glViewport(0, 0, w, h);
    //glViewport(0, 0, (w < h ? w : h), (w < h ? w : h));
    
    /* 投影行列とアスペクト比を更新する */
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    //gluPerspective(40.0, (GLdouble)w / (GLdouble)h, 1.0, 200.0);
    
    /* 透視投影 left right bottm top near far */
    glFrustum(-1.0, 1.0, -1.0, 1.0, 1.5, 20.0);
    
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
    
    /* 白 */
    glColor3f(1.0, 1.0, 1.0);
    
    /* 単位行列 */
    glLoadIdentity();
    
    /* 視野変換 eyex eyey eyez centerx centery centerz upx upy upz */
    gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    /* モデリング変換 */
    glScalef(2.0, 2.0, 2.0);    /* 拡大縮小 x y z */
    
    /* ティーポット描画 */
    if (! isWireframe)
        glutSolidTeapot(0.5);
    else
        glutWireTeapot(0.5);
    
    /* バッファの入れ替え */
    glutSwapBuffers();
    assert(glGetError() == GL_NO_ERROR);
}

void keyboard(unsigned char key, int x, int y)
{
    DBGMSG(@"%s", __func__);
    switch((unsigned char)key) {
        case 'w':
            isWireframe = !isWireframe;
            break;
    }
}

void special(int key, int x, int y)
{
    DBGMSG(@"%s", __func__);
}

void mouse(int button, int state, int x, int y)
{
    DBGMSG(@"%s", __func__);
}

void motion(int x, int y)
{
    DBGMSG(@"%s", __func__);
}

void idle(void)
{
    glutPostRedisplay();
}

void init(void)
{
    DBGMSG(@"%s", __func__);

    /* ディザ処理を無効にする */
    glDisable(GL_DITHER);
    
    /*
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    GLfloat ambient[4] = {0.5, 0.5, 0.5, 1.0};
    glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
    GLfloat blue[4] = {0.3, 0.3, 1.0, 1.0};
    glMaterialfv(GL_FRONT, GL_DIFFUSE, blue);
    GLfloat white[4] = {0.1, 0.1, 0.1, 1.0};
    glMaterialfv(GL_FRONT, GL_SPECULAR, white);
    GLfloat position[4] = {0.5, 0.5, -1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_POSITION, position);
    */
    
    assert(glGetError() == GL_NO_ERROR);
    
    /* リサイズ処理 */
    glutReshapeFunc(resize);
    
    /* 描画 */
    glutDisplayFunc(display);
    
    /* キーボード */
    glutKeyboardFunc(keyboard);
    
    /* 特殊キー */
    glutSpecialFunc(special);
    
    /* マウス */
    glutMouseFunc(mouse);
    
    /* ドラッグ */
    glutMotionFunc(motion);
    
    /* バックグランド処理 */
    glutIdleFunc(idle);
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        glutInit(&argc, (char **)argv);
        
        /* RGBAカラーモード ダブルバッファ デプスバッファ */
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
        
        /* 初期ウィンドウ・サイズ */
        glutInitWindowSize(width, height);
        
        /* 初期ウィンドウ位置 */
        glutInitWindowPosition(500, 100);
        
        /* タイトルバー */
        glutCreateWindow("IRIS GL");
        
        /* 初期化 */
        init();
        
        /* 主ループ（イベント駆動） */
        glutMainLoop();
        
    }
    return 0;
}

