package com.example.performancemonitor;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Debug;
import android.util.Log;
import android.view.Choreographer;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;

public class PerformanceMonitor implements Choreographer.FrameCallback {
    private final static String TAG = "PerformanceMonitor";
    //DebugPerformanceMonitor mDebugPerformanceMonitor;

    /**
     * ActivityのContext.
     */
    private Context mContext = null;

    /**
     *  FPS測定.
     */
    private Choreographer mChoreographer;

    /**
     * コンストラクタ.
     */
    PerformanceMonitor(Context context) {
        mContext = context;
        mChoreographer = Choreographer.getInstance();
        startMeasuringFPS();
        //mDebugPerformanceMonitor = new DebugPerformanceMonitor(context);
    }

    private ActivityManager.MemoryInfo getMemoryInfoOfActivityManager() {
        ActivityManager activityManager = (ActivityManager)mContext.getSystemService(Context.ACTIVITY_SERVICE);
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        activityManager.getMemoryInfo(memoryInfo);
        return memoryInfo;
    }

    private android.os.Debug.MemoryInfo[] getMemoryInfosOfMyPid() {
        ActivityManager activityManager = (ActivityManager)mContext.getSystemService(Context.ACTIVITY_SERVICE);
        int[] pids = new int[1];
        pids[0] = android.os.Process.myPid();
        return  activityManager.getProcessMemoryInfo(pids);
    }

    /**
     * Java仮想機械内の空きメモリ容量の合計を返す。
     * @return 空きメモリ容量[byte]
     */
    public long getFreeMemory() {
        return Runtime.getRuntime().freeMemory();
    }

    /**
     * Java仮想機械が使用を試みる最大メモリ容量を返す。
     * @discussion -Xmxで割り当てるヒープサイズ.
     * @return 最大メモリ容量[byte]
     */
    public long getMaxMemory() {
        return Runtime.getRuntime().maxMemory();
    }

    /**
     * Java仮想機械のメモリの総容量を返す。
     * @discussion -Xmsで割り当てるヒープサイズ.
     * @return メモリの総容量[byte]
     */
    public long getTotalMemory() {
        return Runtime.getRuntime().totalMemory();
    }

    /**
     * システムの使用可能メモリを返す。
     * @return メモリ量[byte]
     */
    public long getAvailMem() {
        ActivityManager.MemoryInfo memoryInfo = getMemoryInfoOfActivityManager();
        return memoryInfo.availMem;
    }

    /**
     * メモリ不足フラグ。
     */
    public boolean isLowMemory() {
        ActivityManager.MemoryInfo memoryInfo = getMemoryInfoOfActivityManager();
        return memoryInfo.lowMemory;
    }

    /**
     * メモリ閾値を返す。
     * @return メモリ量[byte]
     */
    public long getThreshold() {
        ActivityManager.MemoryInfo memoryInfo = getMemoryInfoOfActivityManager();
        return memoryInfo.threshold;
    }

    /**
     * カーネルが利用可能なメモリを返す。
     * @return メモリ量[byte]
     */
    public long getTotalMem() {
        ActivityManager.MemoryInfo memoryInfo = getMemoryInfoOfActivityManager();
        return memoryInfo.totalMem;
    }

    /**
     * nativeヒープに割り当てられたヒープサイズ
     * @return メモリ量[byte]
     */
    public long getNativeHeapAllocatedSize() {
        return Debug.getNativeHeapAllocatedSize();
    }

    /**
     * nativeヒープの空き容量
     * @return メモリ量[byte]
     */
    public long getNativeHeapFreeSize() {
        return Debug.getNativeHeapFreeSize();
    }

    /**
     * nativeヒープの総サイズ
     * @return メモリ量[byte]
     */
    public long getNativeHeapSize() {
        return Debug.getNativeHeapSize();
    }

    /**
     * smapsで割り当てられるプロセスが使用するPSSメモリのサイズ
     * @return メモリ量[byte]
     */
    public long getPss() {
        return Debug.getPss();
    }

    /**
     * DalvikヒープのDirtyメモリ量
     * @return メモリ量[byte]
     */
    public long getDalvikPrivateDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.dalvikPrivateDirty * 1024;
        }

        return memSiz;
    }

    /**
     * Dalvikヒープのメモリ量
     * @return メモリ量[byte]
     */
    public long getDalvikPss() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.dalvikPss * 1024;
        }

        return memSiz;
    }

    /**
     * Dalvikヒープの共有メモリ量
     * @return メモリ量[byte]
     */
    public long getDalvikSharedDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.dalvikSharedDirty * 1024;
        }

        return memSiz;
    }

    /**
     * nativeヒープのDirtyメモリ
     * @return メモリ量[byte]
     */
    public long getNativePrivateDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.nativePrivateDirty * 1024;
        }

        return memSiz;
    }

    /**
     * nativeヒープのメモリ量
     * @return メモリ量[byte]
     */
    public long getNativePss() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.nativePss * 1024;
        }

        return memSiz;
    }

    /**
     * nativeヒープの共有メモリ量
     * @return メモリ量[byte]
     */
    public long getNativeSharedDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.nativeSharedDirty * 1024;
        }

        return memSiz;
    }

    /**
     * その他ヒープのDirtyメモリ
     * @return メモリ量[byte]
     */
    public long getOtherPrivateDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.otherPrivateDirty * 1024;
        }

        return memSiz;
    }

    /**
     * その他ヒープのメモリ量
     * @return メモリ量[byte]
     */
    public long getOtherPss() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.otherPss * 1024;
        }

        return memSiz;
    }

    /**
     * その他ヒープの共有メモリ量
     * @return メモリ量[byte]
     */
    public long getOtherSharedDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.otherSharedDirty * 1024;
        }

        return memSiz;
    }

    /**
     * shared clean memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalPrivateClean() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalPrivateClean() * 1024;
        }

        return memSiz;
    }

    /**
     * private dirty memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalPrivateDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalPrivateDirty() * 1024;
        }

        return memSiz;
    }

    /**
     * PSS memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalPss() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalPss() * 1024;
        }

        return memSiz;
    }

    /**
     * shared clean memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalSharedClean() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalSharedClean() * 1024;
        }

        return memSiz;
    }

    /**
     * shared dirty memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalSharedDirty() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalSharedDirty() * 1024;
        }

        return memSiz;
    }

    /**
     * ファイルに割り付けられたPSS memoryの合計を返す。
     * @return メモリ量[byte]
     */
    public long getTotalSwappablePss() {
        long memSiz = 0;
        android.os.Debug.MemoryInfo[] memInfos = getMemoryInfosOfMyPid();

        for (android.os.Debug.MemoryInfo info : memInfos) {
            memSiz += info.getTotalSwappablePss() * 1024;
        }

        return memSiz;
    }

    private long mUserTicks = 0;    //!< CPU usr時間
    private long mNiceTicks = 0;    //!< CPU nice時間
    private long mSysTicks  = 0;    //!< CPU sys時間
    private long mIdleTicks = 0;    //!< CPU idle時間
    private double mCpuUser = 0.0;  //!< CPU使用率 %usr
    private double mCpuNice = 0.0;  //!< CPU使用率 %nice
    private double mCpuSys  = 0.0;  //!< CPU使用率 %sys
    private double mCpuIdle = 0.0;  //!< CPU使用率 %idle

    /**
     * CPU使用率の情報を更新する。
     * @discussion 前回更新した情報との差分からCPU使用率を求める。
     */
    public void updateCpuInfo() {
        try {
            /* user nice system idle */
            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream("/proc/stat")));
            String line = reader.readLine();
            reader.close();

            if (line != null) {
                String[] vals = line.split(" +");

                if (5 <= vals.length) {
                    long userTicks = Long.parseLong(vals[1]);
                    long niceTicks = Long.parseLong(vals[2]);
                    long sysTicks = Long.parseLong(vals[3]);
                    long idleTicks = Long.parseLong(vals[4]);

                    long userTicksDiff = userTicks - mUserTicks;
                    long niceTicksDiff = niceTicks - mNiceTicks;
                    long sysTicksDiff = sysTicks - mSysTicks;
                    long idleTicksDiff = idleTicks - mIdleTicks;
                    long totalTicksDiff = userTicksDiff + niceTicksDiff + sysTicksDiff + idleTicksDiff;

                    mUserTicks = userTicks;
                    mNiceTicks = niceTicks;
                    mSysTicks = sysTicks;
                    mIdleTicks = idleTicks;

                    if (totalTicksDiff != 0) {
                        mCpuUser = (100.0 * (double)userTicksDiff) / (double)totalTicksDiff;
                        mCpuNice = (100.0 * (double)niceTicksDiff) / (double)totalTicksDiff;
                        mCpuSys = (100.0 * (double)sysTicksDiff) / (double)totalTicksDiff;
                        mCpuIdle = (100.0 * (double)idleTicksDiff) / (double)totalTicksDiff;
                    }
                }
            }
        }
        catch (Exception e) {
            Log.e(TAG, "Exception:" + e);
        }

    }

    /**
     * 更新したCPU使用率の情報から%usrを返す。
     * @discussion CPU使用率の情報を更新したのちに呼び出す。
     * @result [%]
     */
    public double getCpuUsr() {
        return mCpuUser;
    }

    /**
     * 更新したCPU使用率の情報から%niceを返す。
     * @discussion CPU使用率の情報を更新したのちに呼び出す。
     * @result [%]
     */
    public double getCpuNice() {
        return mCpuNice;
    }

    /**
     * 更新したCPU使用率の情報から%sysを返す。
     * @discussion CPU使用率の情報を更新したのちに呼び出す。
     * @result [%]
     */
    public double getCpuSys() {
        return mCpuSys;
    }

    /**
     * 更新したCPU使用率の情報から%idleを返す。
     * @discussion CPU使用率の情報を更新したのちに呼び出す。
     * @result [%]
     */
    public double getCpuIdle() {
        return mCpuIdle;
    }

    private int mBatteryLevel;  /*!< バッテリー値.0〜最大値. */
    private int mBatteryScale;  /*!< バッテリー最大値. */
    private int mBatteryStatus; /*!< バッテーリ状態 */
    private static final String BATTERY_STATUS_CHARGING = "CHARGING";           /*!< BatteryManager.BATTERY_STATUS_CHARGING */
    private static final String BATTERY_STATUS_DISCHARGING = "DISCHARGING";     /*!< BatteryManager.BATTERY_STATUS_DISCHARGING */
    private static final String BATTERY_STATUS_FULL = "FULL";                   /*!< BatteryManager.BATTERY_STATUS_FULL */
    private static final String BATTERY_STATUS_NOT_CHARGING = "NOT_CHARGING";   /*!< BatteryManager.BATTERY_STATUS_NOT_CHARGING */
    private static final String BATTERY_STATUS_UNKNOWN = "UNKNOWN";             /*!< BatteryManager.BATTERY_STATUS_UNKNOWN */

    /**
     * 電池残量と充電状態を更新する。
     * @discussion 電池への影響を避けるため、充電状態の変化の監視は行わない。
     */
    public void updateBatteryInfo() {
        try {
            IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            Intent batteryStatus = mContext.registerReceiver(null, ifilter);

            mBatteryLevel = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
            mBatteryScale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, 0);
            mBatteryStatus = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, 0);
        }
        catch (IllegalArgumentException e) {
            Log.w(TAG, "Can not get the battery info: " + e);
        }
    }

    /**
     * バッテリー値を返す。
     * @discussion 電池残量と充電状態を更新したのちに呼び出す。
     * @result 0〜バッテリー最大値
     */
    public int getBatteryLevel() {
        return mBatteryLevel;
    }

    /**
     * バッテリー最大値を返す。
     * @discussion 電池残量と充電状態を更新したのちに呼び出す。
     * @result バッテリー最大値
     */
    public int getBatteryScale() {
        return mBatteryScale;
    }

    /**
     * バッテリー状態を返す。
     * @discussion 電池残量と充電状態を更新したのちに呼び出す。
     * @result バッテリー状態
     */
    public String getBatteryStatusString() {
        String batteryState = BATTERY_STATUS_UNKNOWN;

        switch (mBatteryStatus) {
            case BatteryManager.BATTERY_STATUS_CHARGING:
                batteryState = BATTERY_STATUS_CHARGING;
                break;

            case BatteryManager.BATTERY_STATUS_DISCHARGING:
                batteryState = BATTERY_STATUS_DISCHARGING;
                break;

            case BatteryManager.BATTERY_STATUS_FULL:
                batteryState = BATTERY_STATUS_FULL;
                break;

            case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
                batteryState = BATTERY_STATUS_NOT_CHARGING;
                break;

            case BatteryManager.BATTERY_STATUS_UNKNOWN:
                batteryState = BATTERY_STATUS_UNKNOWN;
                break;
        }

        return batteryState;
    }

    /**
     * ディスプレイの利用可能領域の横幅を返す.
     * @return 横幅[px].
     */
    public double getWidthPixels() {
        return mContext.getResources().getDisplayMetrics().widthPixels;
    }

    /**
     * ディスプレイの利用可能領域の高さを返す.
     * @discussion ナビゲーションバーの有無も考慮される.
     * @return 高さ[px].
     */
    public double getHeightPixels() {
        return mContext.getResources().getDisplayMetrics().heightPixels;
    }

    /**
     * ディスプレイの論理密度を返す.
     * @discussion 1dpに相当するピクセル数を表す.
     * @return 論理密度(スケール).
     */
    public double getDensity() {
        return mContext.getResources().getDisplayMetrics().density;
    }

    /**
     * FPS.
     */
    private double mFps;

    /**
     * 前のframeTimeNanos.
     */
    private long mPrevFrameTimeNanos = 0;

    /**
     * FPSの計測を開始する.
     */
    private void startMeasuringFPS() {
        mChoreographer.postFrameCallback(this);
        mPrevFrameTimeNanos = 0;
    }

    /**
     * FPSの計測を停止する.
     */
    private void stopMeasuringFPS() {
        mChoreographer.removeFrameCallback(this);
    }

    @Override
    public void doFrame(long frameTimeNanos) {
        long diff = frameTimeNanos - mPrevFrameTimeNanos;
        mFps = (double)TimeUnit.SECONDS.toNanos(1) / (double)diff;
        mPrevFrameTimeNanos = frameTimeNanos;
        mChoreographer.postFrameCallback(this);
        Log.d(TAG, "doFrame() tid:" + android.os.Process.myTid());
    }

    /**
     * FPSを返す.
     * @return FPS.
     */
    public double getFps() {
        return mFps;
    }
}

class DebugPerformanceMonitor implements Choreographer.FrameCallback {
    /**
     * ActivityのContext.
     */
    private Context mContext = null;

    /**
     *  FPS測定.
     */
    private Choreographer mChoreographer;

    /**
     * コンストラクタ.
     */
    DebugPerformanceMonitor(Context context) {
        mContext = context;
        mChoreographer = Choreographer.getInstance();
        startMeasuringFPS();
    }

    /**
     * FPSの計測を開始する.
     */
    private void startMeasuringFPS() {
        mChoreographer.postFrameCallback(this);
    }

    /**
     * FPSの計測を停止する.
     */
    private void stopMeasuringFPS() {
        mChoreographer.removeFrameCallback(this);
    }

    @Override
    public void doFrame(long frameTimeNanos) {
        for (int i = 0; i < 10; i++) {
            try {
                Thread.sleep(1);
            }
            catch (InterruptedException e) {
                Log.e("DebugPerformanceMonitor", "InterruptedException:" + e);
            }
        }
        mChoreographer.postFrameCallback(this);
    }
}