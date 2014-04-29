package com.example.wibree;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.content.Context;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGattService;
import android.content.pm.PackageManager;
import android.widget.Toast;
import android.util.Log;

public class MainActivity extends Activity {
	
	private final String TAG = "Wibree-Main";
	private BluetoothAdapter mBluetoothAdapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		/* BLE対応の確認 */
		if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, "not support", Toast.LENGTH_SHORT).show();
            finish();
        }
		
		/* Bluetooth Adapter */
		final BluetoothManager bluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
		mBluetoothAdapter = bluetoothManager.getAdapter();
		
		/* Bluetooth LEデバイスの検索 */
		mBluetoothAdapter.startLeScan(mLeScanCallback);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	private BluetoothAdapter.LeScanCallback mLeScanCallback =
		new BluetoothAdapter.LeScanCallback() {
			@Override
			public void onLeScan(final BluetoothDevice device,
								 int rssi,
								 byte[] scanRecord) {
				if (scanRecord.length > 30) {
				    if ((scanRecord[5] == (byte)0x4c)
				    		&& (scanRecord[6] == (byte)0x00)
				    		&& (scanRecord[7] == (byte)0x02)
				    		&& (scanRecord[8] == (byte)0x15)) {
				            String uuid = IntToHex2(scanRecord[9] & 0xff) 
				            + IntToHex2(scanRecord[10] & 0xff)
				            + IntToHex2(scanRecord[11] & 0xff)
				            + IntToHex2(scanRecord[12] & 0xff)
				            + "-"
				            + IntToHex2(scanRecord[13] & 0xff)
				            + IntToHex2(scanRecord[14] & 0xff)
				            + "-"
				            + IntToHex2(scanRecord[15] & 0xff)
				            + IntToHex2(scanRecord[16] & 0xff)
				            + "-"
				            + IntToHex2(scanRecord[17] & 0xff)
				            + IntToHex2(scanRecord[18] & 0xff)
				            + "-"
				            + IntToHex2(scanRecord[19] & 0xff)
				            + IntToHex2(scanRecord[20] & 0xff)
				            + IntToHex2(scanRecord[21] & 0xff)
				            + IntToHex2(scanRecord[22] & 0xff)
				            + IntToHex2(scanRecord[23] & 0xff)
				            + IntToHex2(scanRecord[24] & 0xff);

				            String major = IntToHex2(scanRecord[25] & 0xff) + IntToHex2(scanRecord[26] & 0xff);
				            String minor = IntToHex2(scanRecord[27] & 0xff) + IntToHex2(scanRecord[28] & 0xff);
				            
				            Log.d(TAG, "uuid:" + uuid);
				            Log.d(TAG, "major:" + major);
				            Log.d(TAG, "minor:" + minor);
				        }
				}
			}
		};

	private String IntToHex2(int i) {
	    char hex_2[] = {Character.forDigit((i>>4) & 0x0f,16),Character.forDigit(i&0x0f, 16)};
	    String hex_2_str = new String(hex_2);
	    return hex_2_str.toUpperCase();
	}
}
