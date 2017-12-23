//
//  main.m
//  IRIS
//
//  Created by 村上 幸雄 on 2012/11/07.
//  Copyright (c) 2012年 村上 幸雄. All rights reserved.
//

#import <iostream>
#import <sstream>
#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/glut.h>

int gWidth = 600;
int gHeight = 500;
const int QUIT_VALUE(99);
GLuint  gListID; /* ディスプレイリストID */
//GLuint  bufferID;

inline GLvoid *bufferObjectPtr(unsigned int idx)
{
    return (GLvoid *)(((char *)NULL) + idx);
}

void display(void)
{
    /* カラーバッファの初期化 */
    glClear(GL_COLOR_BUFFER_BIT);
    
    /* モデリング変換、z軸の負の方向に幾何形状を4単位移動する。 */
    glLoadIdentity();   /* 単位行列 */
    glTranslatef(0.0f, 0.0f, -4.0f);
    
    /* 幾何形状を描画する。 */
    glCallList(gListID);
    
    /* バッファの入れ替え */
    glutSwapBuffers();
    
    assert(glGetError() == GL_NO_ERROR);
}

void resize(int w, int h)
{
    /* ウィンドウ・サイズとOpenGLの座標を対応づける */
    glViewport(0, 0, w, h);
    
    /* 投影行列とアスペクト比を更新する */
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(50.0, (GLdouble)w / (GLdouble)h, 1.0, 10.0);
    
    /* 表示ルーチン用にモデルビューモードに設定する */
    glMatrixMode(GL_MODELVIEW);
    
    assert(glGetError() == GL_NO_ERROR);
    
    gWidth = w;
    gHeight = h;
}

void keyboard(unsigned char key, int x, int y)
{
    DBGMSG(@"%s", __func__);
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

void main_menu_callback(int value)
{
    if (value == QUIT_VALUE)
        exit(EXIT_SUCCESS);
}

void init(void)
{
    DBGMSG(@"%s", __func__);
    assert(glGetError() == GL_NO_ERROR);

    /* ディザ処理を無効にする */
    glDisable(GL_DITHER);
    assert(glGetError() == GL_NO_ERROR);
    
    std::string ver((const char*)glGetString(GL_VERSION));
    assert(! ver.empty());
    std::istringstream verStream(ver);
    
    int major, minor;
    char dummySep;
    verStream >> major >> dummySep >> minor;
    const bool useVertexArrays = ((major >= 1) && (minor >= 1));
    NSLog(@"OpenGL Ver. %d.%d", major, minor);
    
    /* 三角形の頂点を定義する */
    const GLfloat data[] = {
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        0.0f, 1.0f, 0.0f
    };
    
    if (useVertexArrays) {
        /* バッファIDを取得する */
        //glGenBuffers(1, &bufferID);
        
        /* バッファオブジェクトをバインドする */
        //glBindBuffer(GL_ARRAY_BUFFER, bufferID);
        
        /* 配列の値をバッファオブジェクトにコピーする */
        //glBufferData(GL_ARRAY_BUFFER, 3 * 3 * sizeof(GLfloat), data, GL_STATIC_DRAW);
        
        glEnableClientState(GL_VERTEX_ARRAY);
        assert(glGetError() == GL_NO_ERROR);
        
        glVertexPointer(3, GL_FLAT, 0, data);
        //glVertexPointer(3, GL_FLAT, 0, bufferObjectPtr(0));
        
        GLenum glErrorCode = glGetError();
        NSLog(@"%s (error code:0x%x)", __func__, glErrorCode);
        assert(glErrorCode == GL_NO_ERROR);
    }
    assert(glGetError() == GL_NO_ERROR);
    
    /* ディスプレイリストを作成する。 */
    gListID = glGenLists(1);
    glNewList(gListID, GL_COMPILE);
    assert(glGetError() == GL_NO_ERROR);

    if (useVertexArrays) {
        glDrawArrays(GL_TRIANGLES, 0, 3);
        //glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_INT, &gListID);
        //glDisableClientState(GL_VERTEX_ARRAY);
    }
    else {
        glBegin(GL_TRIANGLES);
        glVertex3fv(&data[0]);
        glVertex3fv(&data[3]);
        glVertex3fv(&data[6]);
        glEnd();
    }
    assert(glGetError() == GL_NO_ERROR);
    
    glEndList();
    
    //NSLog(@"%s (error code:0x%x)", __func__, glGetError());
    assert(glGetError() == GL_NO_ERROR);
    
    /* 描画 */
    glutDisplayFunc(display);

    /* リサイズ処理 */
    glutReshapeFunc(resize);
    
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
    
    /* コンテキスト・メニュー */
    glutCreateMenu(main_menu_callback);
    glutAddMenuEntry("Quit", QUIT_VALUE);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        glutInit(&argc, (char **)argv);
        
        /* RGBカラーモード ダブルバッファ */
        glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
        
        /* 初期ウィンドウ・サイズ */
        glutInitWindowSize(gWidth, gHeight);
        
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

