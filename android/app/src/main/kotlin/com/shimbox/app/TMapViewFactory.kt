package com.shimbox.app

import android.content.Context
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class TMapViewFactory : PlatformViewFactory(null) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return TMapNativeView(context)

    }


}
