package com.example.flutter_app;

import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.lwocryptocore.lcryptcore.CryptoCase;
import com.example.lwocryptocore.lcryptcore.LCryptCore;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    static
    {
        System.loadLibrary("cryptowrap");
    }

    private final String CHANNEL = "mark.flutter.dev/vhash";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("libcrypto")) {
                String hash = getHash(call.argument("data"));
                result.success(hash);
            } else {
                result.notImplemented();
            }
        });
    }
    public String getHash(String data) {
        String selectedAlgoritm = "sha256";
        byte[] arrBytesForDigest;
        arrBytesForDigest = data.getBytes();
        CryptoCase cryptoCaseDigest = (new LCryptCore()).CreateDigest(selectedAlgoritm, data.getBytes(), arrBytesForDigest.length);
        return bytesToHex(cryptoCaseDigest.digest);
    }
    private final static char[] hexArray = "0123456789ABCDEF".toCharArray();
    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars).toLowerCase();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }
}