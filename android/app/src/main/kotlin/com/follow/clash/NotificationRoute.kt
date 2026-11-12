package com.follow.clash

object NotificationRoute {
    const val EXTRA = "com.follow.clash.extra.ROUTE"
    private val values = setOf("lines", "residential", "residentialRetry", "outboundMode", "subscription")

    fun parse(value: String?): String? = value?.takeIf(values::contains)
}
