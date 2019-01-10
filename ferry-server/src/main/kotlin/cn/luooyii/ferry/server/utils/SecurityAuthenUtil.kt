package cn.luooyii.ferry.server.utils

import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.User

object SecurityAuthenUtil {

    /**
     * 直接获取当前用户的登录账号
     * @return
     */
    val id: Int
        get() {
            val authenObj = SecurityContextHolder.getContext().authentication
            val authenUser = authenObj.principal as User
            return Integer.valueOf(authenUser.username)
        }

    val idWithoutException: Int
        get() {
            try {
                val authenObj = SecurityContextHolder.getContext().authentication
                val authenUser = authenObj.principal as User
                return Integer.valueOf(authenUser.username)
            } catch (ex: Exception) {
                return 0
            }

        }

    /**
     * 直接获取当前用户的登录账号
     * @return
     */
    val loginName: String
        get() {
            val authenObj = SecurityContextHolder.getContext().authentication
            val authenUser = authenObj.principal as User
            return authenUser.username
        }

    /**
     * 直接获取当前用户的认证用户信息
     * @return
     */
    val authenticationUser: User
        get() {
            val authenObj = SecurityContextHolder.getContext().authentication
            val authenUser = authenObj.principal as User
            return authenUser
        }


}
