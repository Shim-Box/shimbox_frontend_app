package com.shimbox.app

import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import android.webkit.WebView

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WebView.setWebContentsDebuggingEnabled(true)
    }
}
