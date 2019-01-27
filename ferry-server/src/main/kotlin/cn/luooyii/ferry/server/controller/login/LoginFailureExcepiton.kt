package cn.luooyii.ferry.server.controller.login

class LoginFailureExcepiton(message: String) : RuntimeException(message) {
    companion object {
        private val serialVersionUID = 1381277361046202535L
    }
}