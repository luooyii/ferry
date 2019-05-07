package cn.luooyii.ferry.server.service.impl

import cn.luooyii.ferry.server.dao.UserDao
import cn.luooyii.ferry.server.model.UserEntity
import cn.luooyii.ferry.server.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import java.util.ArrayList

@Service(value = "userServiceImpl")
class UserServiceImpl : UserService {

    @Autowired
    private val userDao: UserDao? = null

    override fun insert(userEntity: UserEntity) {
        userDao!!.insert(userEntity)
    }

    override fun del(userEntity: UserEntity) {
        userDao!!.del(userEntity)
    }

    override fun getUserEntityByLoginName(loginName: String): UserEntity {
        return userDao!!.getUserEntityByLoginName(loginName)
    }

    override fun usersList(name: String, pageSize: Int, start: Int): List<UserEntity> {
        return userDao!!.usersList(name, pageSize, start)
    }

    override fun usersSize(name: String, pageSize: Int, start: Int): Int? {
        return userDao!!.usersSize(name, pageSize, start)
    }

    override fun insertUser(userEntity: UserEntity) {
        //userEntity.setPassword("{bcrypt}" + new BCryptPasswordEncoder().encode(userEntity.getPassword()));
        userDao!!.insertUser(userEntity)
    }

    override fun updateUser(userEntity: UserEntity) {
        //userEntity.setPassword(new Md5PasswordEncoder().encodePassword(userEntity.getPassword(), null));
        if (userEntity.id != 8888) {
            //userEntity.setPassword("{bcrypt}" + new BCryptPasswordEncoder().encode(userEntity.getPassword()));
        }
        userDao!!.updateUser(userEntity)
    }

    override fun deleteUsers(groupId: List<String>) {
        userDao!!.deleteUsers(groupId)
    }

    override fun getEntityById(userid: Int): UserEntity {
        return userDao!!.getUserEntityById(userid)
    }

}
