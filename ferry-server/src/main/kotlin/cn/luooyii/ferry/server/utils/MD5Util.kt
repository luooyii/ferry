package cn.luooyii.ferry.server.utils

import java.math.BigInteger
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

object MD5Util {
    @Throws(NoSuchAlgorithmException::class)
    fun encrypt(str: String): String {
        // 确定计算方法
        val md5: MessageDigest
        md5 = MessageDigest.getInstance("MD5")
        md5.update(str.toByteArray())
        return BigInteger(1, md5.digest()).toString(16)
    }
}
