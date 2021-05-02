package app.mojidraw

import android.content.Context
import android.os.Bundle
import android.view.View
import io.flutter.embedding.android.SplashScreen

/**
 * Decorator for [SplashScreen] that absorbs user input
 *
 * When using the Flutter default splash screen, any user input during the splash screen phase is
 * buffered and handled later when Flutter takes over control. This splash screen decorator avoids
 * this behavior by setting the view of the provided inner splash screen to be clickable.
 */
class InputAbsorbingSplashScreenDecorator(inner: SplashScreen?) : SplashScreen {
    private val inner: SplashScreen? = inner

    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View? {
        val view: View? = inner?.createSplashView(context, savedInstanceState)
        view?.isClickable = true
        return view
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        inner?.transitionToFlutter(onTransitionComplete)
    }
}