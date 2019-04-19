package cn.luooyii.ferry.server.controller.sys;

import cn.luooyii.ferry.server.model.UserEntity;
import cn.luooyii.ferry.server.model.utils.ResponseWrapper;
import cn.luooyii.ferry.server.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
public class UserController {

    private Logger log = LoggerFactory.getLogger(UserController.class);

    @Resource(name = "userServiceImpl")
    private UserService userService;

    /**
     * 获取user表数据
     */
    @GetMapping("/users")
    public ResponseWrapper usersList(@RequestParam(value = "username", required = false) String username,
                                     @RequestParam(value = "password", required = false) String password) {
        log.debug("The method is ending");
        UserEntity userEntity = userService.getUserEntityByLoginName(username);
        if (userEntity == null) {
            return new ResponseWrapper("200", "没有该用户");
        } else {
            if (userEntity.getPassword() != null && userEntity.getPassword().equals(password)) {
                return new ResponseWrapper("200", "success", userEntity);
            } else {
                return new ResponseWrapper("200", "密码错误");
            }
        }
    }
}
