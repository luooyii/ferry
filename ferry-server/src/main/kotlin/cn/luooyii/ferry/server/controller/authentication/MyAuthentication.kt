package cn.luooyii.ferry.server.controller.authentication

interface MyAuthentication {
    fun getUserId(code: String): String
}
