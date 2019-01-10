package cn.luooyii.ferry.server.utils

import java.util.regex.Pattern

object MyStringUtil {

    /**
     * 判断String是否位数字
     * @param str
     * @return
     */
    fun isInteger(str: String): Boolean {
        val pattern = Pattern.compile("^[-\\+]?[\\d]*$")
        return pattern.matcher(str).matches()
    }

}
