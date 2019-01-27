package cn.luooyii.ferry.server.controller.login

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestControllerAdvice

import java.util.HashMap

@RestControllerAdvice
class LoginFailureHandler {

    @ExceptionHandler(LoginFailureExcepiton::class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    fun handleLoginFailureExcepiton(ex: LoginFailureExcepiton): Map<String, Any> {
        val result = HashMap<String, Any>()
        result["message"] = ex.message!!
        result["error type"] = "登陆失败"
        return result
    }

}
