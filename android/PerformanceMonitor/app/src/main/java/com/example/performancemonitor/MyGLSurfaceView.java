package com.example.performancemonitor;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.util.Log;

public class MyGLSurfaceView extends GLSurfaceView {

    private final MyGLRenderer renderer;
    private PerformanceMonitor mPerformanceMonitor;

    public MyGLSurfaceView(Context context, PerformanceMonitor performanceMonitor){
        super(context);
        mPerformanceMonitor = performanceMonitor;

        // Create an OpenGL ES 2.0 context
        setEGLContextClientVersion(2);

        renderer = new MyGLRenderer(mPerformanceMonitor);

        // Set the Renderer for drawing on the GLSurfaceView
        setRenderer(renderer);

        // Render the view only when there is a change in the drawing data
        //setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);

        Log.d("MyGLSurfaceView", "MyGLSurfaceView() tid:" + android.os.Process.myTid());
    }
}
