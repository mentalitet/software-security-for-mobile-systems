package by.bstu.mark.libcryptoapp;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

import com.example.lwocryptocore.lcryptcore.CryptoCase;
import com.example.lwocryptocore.lcryptcore.LCryptCore;

public class MainActivity extends AppCompatActivity {

    // == Подключаем библиотеку криптографии
    static
    {
        System.loadLibrary("cryptowrap");
    }
// ================================================

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // == Определяем переменные для криптоопераций
        String selectedAlgoritm = "belt-hash";  // тип алгоритма хэширования
        String testMsg = "test";                // входное сообщение для хэширования
        //byte[] testMsg = "test";                // входное сообщение для хэширования
        byte[] arrBytesForDigest = new byte[(int) testMsg.length()];
        arrBytesForDigest = testMsg.getBytes();
        // CryptoCase cryptoCaseDigest = new CryptoCase();

        // Функция вычисления хэш значения. результат в cryptoCaseDigest.digest
        // cryptoCaseDigest = (new LCryptCore()).CreateDigest(selectedAlgoritm, arrBytesForDigest, arrBytesForDigest.length);
        CryptoCase cryptoCaseDigest = (new LCryptCore()).CreateDigest(selectedAlgoritm, testMsg.getBytes(), arrBytesForDigest.length);

    }
}