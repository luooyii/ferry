package cn.luooyii.ferry.server.controller.sys

import cn.luooyii.ferry.server.model.UserEntity
import cn.luooyii.ferry.server.model.utils.ResponseWrapper
import cn.luooyii.ferry.server.service.UserService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.*

import javax.annotation.Resource

@RestController
class UserController {

    private val log = LoggerFactory.getLogger(UserController::class.java)

    @Resource(name = "userServiceImpl")
    private val userService: UserService? = null

    /**
     * 获取user表数据
     */
    @GetMapping("/users")
    fun usersList(@RequestParam(value = "username", required = false) username: String,
                  @RequestParam(value = "password", required = false) password: String): ResponseWrapper<*> {
        log.debug("The method is ending")
        val userEntity = userService!!.getUserEntityByLoginName(username)
        return if (userEntity == null) {
            ResponseWrapper("204", "没有该用户", null)
        } else {
            if (userEntity.password != null && userEntity.password == password) {
                ResponseWrapper("200", "success", userEntity)
            } else {
                ResponseWrapper("200", "密码错误")
            }
        }
    }
}
