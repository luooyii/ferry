package cn.luooyii.ferry.server.utils

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date

object DateUtil {

    /**
     * 当前系统时间戳
     * @return
     */
    fun currentTimestamp(): String {
        return Date().time.toString()
    }

    /**
     * 当前系统时间（yyyyMMdd）
     * @return
     */
    fun currentTimes(): String {

        val format = SimpleDateFormat("yyyyMMdd")

        return format.format(Date())
    }

    /**
     * 月初时间戳
     * @param time
     * @return
     */
    fun monthFirstday(time: String): String {
        val cale = Calendar.getInstance()
        cale.time = Date(java.lang.Long.valueOf(time))
        cale.add(Calendar.MONTH, 0)
        cale.set(Calendar.DAY_OF_MONTH, 1)
        cale.set(Calendar.HOUR_OF_DAY, 0)
        cale.set(Calendar.MINUTE, 0)
        cale.set(Calendar.SECOND, 0)
        return cale.timeInMillis.toString()
    }

    /**
     * 月末时间戳
     * @param time
     * @return
     */
    fun monthLastday(time: String): String {
        val cale = Calendar.getInstance()
        cale.time = Date(java.lang.Long.valueOf(time))
        cale.add(Calendar.MONTH, 1)
        cale.set(Calendar.DAY_OF_MONTH, 0)
        cale.set(Calendar.HOUR_OF_DAY, 23)
        cale.set(Calendar.MINUTE, 59)
        cale.set(Calendar.SECOND, 59)
        return cale.timeInMillis.toString()
    }

    /**
     * 这天的开始
     * @param time
     * @return
     */
    fun daystart(time: String): String {
        val cale = Calendar.getInstance()
        cale.time = Date(java.lang.Long.valueOf(time))
        cale.set(Calendar.HOUR_OF_DAY, 0)
        cale.set(Calendar.MINUTE, 0)
        cale.set(Calendar.SECOND, 0)
        return cale.timeInMillis.toString()
    }

    /**
     * 这天的结束
     * @param time
     * @return
     */
    fun dayend(time: String): String {
        val cale = Calendar.getInstance()
        cale.time = Date(java.lang.Long.valueOf(time))
        cale.set(Calendar.HOUR_OF_DAY, 23)
        cale.set(Calendar.MINUTE, 59)
        cale.set(Calendar.SECOND, 59)
        return cale.timeInMillis.toString()
    }

}
