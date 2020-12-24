package com.example.performancemonitor;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.Button;
import android.widget.TextView;

import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends AppCompatActivity {
    private final static String TAG = "MainActivity";
    private PerformanceMonitor mPerformanceMonitor = null;
    Handler mHandler;
    Timer mTimer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mPerformanceMonitor = new PerformanceMonitor(this);
        mHandler = new Handler(Looper.getMainLooper());

        Button button = findViewById(R.id.button);
        button.setOnClickListener(v -> {
            measurement();
        });

        mTimer = new Timer();
        mTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        measurement();
                    }
                });
            }
            }, 5000, 5000);
    }

    void measurement() {
        mPerformanceMonitor.updateCpuInfo();
        mPerformanceMonitor.updateBatteryInfo();

        TextView textMultiLine = findViewById(R.id.editTextMultiLine);
        StringBuilder str = new StringBuilder();
        str.append("Java仮想機械\n");
        str.append(String.format("  空きメモリ容量[byte]:%d\n", mPerformanceMonitor.getFreeMemory()));
        str.append(String.format("  使用を試みる最大メモリ容量[byte]:%d\n", mPerformanceMonitor.getMaxMemory()));
        str.append(String.format("  メモリ総容量[byte]:%d\n", mPerformanceMonitor.getTotalMemory()));
        str.append(String.format("システムの使用可能メモリ量[byte]:%d\n", mPerformanceMonitor.getAvailMem()));
        str.append(String.format("メモリ不足フラグ:%b", mPerformanceMonitor.isLowMemory()));
        str.append(String.format("メモリ閾値[byte]:%d\n", mPerformanceMonitor.getThreshold()));
        str.append(String.format("カーネルが利用可能なメモリ量[byte]:%d\n", mPerformanceMonitor.getTotalMem()));
        str.append("nativeヒープ\n");
        str.append(String.format("  割り当てられたヒープサイズ[byte]:%d\n", mPerformanceMonitor.getNativeHeapAllocatedSize()));
        str.append(String.format("  空き容量[byte]:%d\n", mPerformanceMonitor.getNativeHeapFreeSize()));
        str.append(String.format("  総サイズ[byte]:%d\n", mPerformanceMonitor.getNativeHeapSize()));
        str.append(String.format("smapsで割り当てられるプロセスが使用するPSSメモリのサイズ[byte]:%d\n", mPerformanceMonitor.getPss()));
        str.append("Dalvikヒープ\n");
        str.append(String.format("  Dirtyメモリ量[byte]:%d\n", mPerformanceMonitor.getDalvikPrivateDirty()));
        str.append(String.format("  メモリ量[byte]:%d\n", mPerformanceMonitor.getDalvikPss()));
        str.append(String.format("  共有メモリ量[byte]:%d\n", mPerformanceMonitor.getDalvikSharedDirty()));
        str.append(String.format("  Dirtyメモリ[byte]:%d\n", mPerformanceMonitor.getNativePrivateDirty()));
        str.append(String.format("  メモリ量[byte]:%d\n", mPerformanceMonitor.getNativePss()));
        str.append(String.format("  共有メモリ量[byte]:%d\n", mPerformanceMonitor.getNativeSharedDirty()));
        str.append("その他ヒープ\n");
        str.append(String.format("  Dirtyメモリ[byte]:%d\n", mPerformanceMonitor.getOtherPrivateDirty()));
        str.append(String.format("  メモリ量[byte]:%d\n", mPerformanceMonitor.getOtherPss()));
        str.append(String.format("  共有メモリ量[byte]:%d\n", mPerformanceMonitor.getOtherSharedDirty()));
        str.append(String.format("shared clean memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalPrivateClean()));
        str.append(String.format("private dirty memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalPrivateDirty()));
        str.append(String.format("PSS memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalPss()));
        str.append(String.format("shared clean memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalSharedClean()));
        str.append(String.format("shared dirty memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalSharedDirty()));
        str.append(String.format("ファイルに割り付けられたPSS memoryの合計[byte]:%d\n", mPerformanceMonitor.getTotalSwappablePss()));
        str.append(String.format("CPU usage: %.1f%%%% user, %.1f%%%% nice, %.1f%%%% sys, %.1f%%%% idle\n",
                mPerformanceMonitor.getCpuUsr(),
                mPerformanceMonitor.getCpuNice(),
                mPerformanceMonitor.getCpuSys(),
                mPerformanceMonitor.getCpuIdle()));
        str.append(String.format("バッテリー値(0〜バッテリー最大値):%d\n", mPerformanceMonitor.getBatteryLevel()));
        str.append(String.format("バッテリー最大値:%d\n", mPerformanceMonitor.getBatteryScale()));
        str.append(String.format("バッテリー状態:%s\n", mPerformanceMonitor.getBatteryStatusString()));
        str.append("ディスプレイ\n");
        str.append(String.format("  利用可能領域の横幅[px]:%.0f\n", mPerformanceMonitor.getWidthPixels()));
        str.append(String.format("  利用可能領域の高さ[px]:%.0f\n", mPerformanceMonitor.getHeightPixels()));
        str.append(String.format("  論理密度(1dpに相当するピクセル数)[スケール]:%.0f", mPerformanceMonitor.getDensity()));
        textMultiLine.setText(new String(str));

        TextView textFPS = findViewById(R.id.editTextFPS);
        textFPS.setText(String.format("%2.2f[fps]", mPerformanceMonitor.getFps()));
    }
}