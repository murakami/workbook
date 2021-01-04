package com.example.performancemonitor;

import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.util.Log;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

public class MyGLRenderer implements GLSurfaceView.Renderer {

    private PerformanceMonitor mPerformanceMonitor;

    public MyGLRenderer(PerformanceMonitor performanceMonitor) {
        mPerformanceMonitor = performanceMonitor;
    }

    public void onSurfaceCreated(GL10 unused, EGLConfig config) {
        // Set the background frame color
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        Log.d("MyGLRenderer", "onSurfaceCreated() tid:" + android.os.Process.myTid());
    }

    public void onDrawFrame(GL10 unused) {
        mPerformanceMonitor.updateFpsOnGLThread();
        // Redraw background color
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
        //Log.d("MyGLRenderer", "onDrawFrame() tid:" + android.os.Process.myTid());
    }

    public void onSurfaceChanged(GL10 unused, int width, int height) {
        GLES20.glViewport(0, 0, width, height);
        Log.d("MyGLRenderer", "onSurfaceChanged() tid:" + android.os.Process.myTid());
    }
}
