package com.follow.clash

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class NotificationRouteTest {
    @Test
    fun parsesSupportedRouteExtras() {
        listOf("lines", "residential", "residentialRetry", "outboundMode", "subscription")
            .forEach { assertEquals(it, NotificationRoute.parse(it)) }
        assertNull(NotificationRoute.parse(null))
        assertNull(NotificationRoute.parse("start"))
    }
}
