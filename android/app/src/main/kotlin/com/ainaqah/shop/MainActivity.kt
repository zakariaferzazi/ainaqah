package com.ainaqah.shop

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {

    private val channel = "getIdChannel"
    private val id = "p"
    private var productId = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val appLinkAction = intent.action
        val appLinkData: Uri? = intent.data
        if (Intent.ACTION_VIEW == appLinkAction) {
            Log.d("productId", appLinkData?.path!!)
            if (appLinkData?.getQueryParameter(id) != null) {
                print(appLinkData.getQueryParameter(id)!!)
                productId = appLinkData.getQueryParameter(id)!!
                Log.d("productId", productId)
                //Toast.makeText(this, appLinkData.getQueryParameter("referral"), Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, channel).setMethodCallHandler { call, result ->
            if (call.method == id && productId.isNotEmpty()) {
                Log.d("productId", productId)
                result.success(productId)
                productId = ""
            } else {
                result.success("")
            }
        }
    }
}

        