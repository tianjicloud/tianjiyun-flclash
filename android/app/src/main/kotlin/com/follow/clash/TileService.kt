package com.follow.clash

import android.annotation.SuppressLint
import android.os.Build
import android.os.Build.VERSION_CODES.Q
import android.service.quicksettings.Tile
import com.follow.clash.common.QuickAction
import com.follow.clash.common.quickIntent
import com.follow.clash.common.toPendingIntent
import com.follow.clash.models.SharedState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.launch

class TileService : android.service.quicksettings.TileService() {
    private var scope: CoroutineScope? = null

    override fun onStartListening() {
        super.onStartListening()
        scope?.cancel()
        scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate).also { scope ->
            scope.launch {
                combine(ServiceState.runState, ServiceState.sharedState) { runState, state ->
                    runState to state
                }.collect { (runState, state) -> updateTile(runState, state) }
            }
        }
    }

    // Always route through QuickActionActivity: startActivityAndCollapse is
    // what closes the shade, so toggling the service in place would leave
    // the panel open after a tap.
    override fun onClick() {
        super.onClick()
        openQuickAction()
    }

    override fun onStopListening() {
        scope?.cancel()
        scope = null
        super.onStopListening()
    }

    private fun updateTile(runState: RunState, sharedState: SharedState) {
        qsTile?.apply {
            state = when (runState) {
                RunState.STARTED -> Tile.STATE_ACTIVE
                RunState.STARTING, RunState.STOPPING -> Tile.STATE_UNAVAILABLE
                RunState.STOPPED -> Tile.STATE_INACTIVE
            }
            if (Build.VERSION.SDK_INT >= Q) {
                subtitle = if (runState == RunState.STARTED) {
                    sharedState.currentLineName.ifEmpty { sharedState.connectedText }
                } else {
                    sharedState.notConnectedText
                }
            }
            updateTile()
        }
    }

    @SuppressLint("StartActivityAndCollapseDeprecated")
    private fun openQuickAction() {
        val intent = QuickAction.TOGGLE.quickIntent
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startActivityAndCollapse(intent.toPendingIntent)
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }
}
