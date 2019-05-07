package cn.luooyii.ferry.server.dao

import cn.luooyii.ferry.server.model.UserEntity
import org.apache.ibatis.annotations.Mapper
import org.apache.ibatis.annotations.Param

import java.util.ArrayList

@Mapper
interface UserDao {

    val aLl: List<UserEntity>

    fun select(@Param("userEntity") userEntity: UserEntity): ArrayList<UserEntity>

    fun del(@Param("userEntity") userEntity: UserEntity)

    fun update(@Param("userEntity") userEntity: UserEntity)

    fun insert(@Param("userEntity") userEntity: UserEntity)

    /**
     * 通过登录名拿到用户信息
     * @return
     */
    fun getUserEntityByLoginName(@Param("loginName") loginName: String): UserEntity

    /**
     * 获取user列表
     * @param name
     * @param pageSize
     * @param start
     * @return
     */
    fun usersList(@Param("name") name: String, @Param("pageSize") pageSize: Int, @Param("start") start: Int): ArrayList<UserEntity>

    /**
     * 获取user列表的总量
     * @param name
     * @param pageSize
     * @param start
     * @return
     */
    fun usersSize(@Param("name") name: String, @Param("pageSize") pageSize: Int, @Param("start") start: Int): Int?

    /**
     * 新建用户信息
     * @param userEntity
     */
    fun insertUser(userEntity: UserEntity)

    /**
     * 更新用户信息
     * @param userEntity
     */
    fun updateUser(userEntity: UserEntity)

    /**
     * 删除用户信息
     * @param groupId
     */
    fun deleteUsers(@Param("groupId") groupId: List<String>)

    fun updateUsertype(@Param("loginName") loginName: String, @Param("usertype") usertype: Int?)

    fun getUserEntityById(@Param("id") id: Int?): UserEntity

    fun getEntityByGithubid(@Param("githubid") login: String): UserEntity

    fun getEntityByQqid(@Param("qqid") openid: String): UserEntity

    fun insertUserByQq(userEntity: UserEntity)

    fun updateUsertypeById(@Param("id") id: Int, @Param("usertype") usertype: Int?)
}
