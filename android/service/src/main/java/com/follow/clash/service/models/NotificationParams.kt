package com.follow.clash.service.models

data class NotificationParams(
    val title: String = "FlClash",
    val stopText: String = "STOP",
    val onlyStatisticsProxy: Boolean = false,
    val showStopAction: Boolean = true,
    val currentLineName: String = "",
    val switchModeText: String = "Switch mode",
    val changeLineText: String = "Change line",
)
