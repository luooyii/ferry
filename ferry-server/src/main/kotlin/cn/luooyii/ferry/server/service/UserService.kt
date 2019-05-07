package cn.luooyii.ferry.server.service

import cn.luooyii.ferry.server.model.UserEntity

interface UserService {
    fun insert(userEntity: UserEntity)

    fun del(userEntity: UserEntity)

    /**
     * 通过登录名得到用户信息
     * @param loginName
     * @return
     */
    fun getUserEntityByLoginName(loginName: String): UserEntity

    /**
     * 获取user列表
     * @param name
     * @param pageSize
     * @param start
     * @return
     */
    fun usersList(name: String, pageSize: Int, start: Int): List<UserEntity>

    /**
     * 获取user列表的总量
     * @param name
     * @param pageSize
     * @param start
     * @return
     */
    fun usersSize(name: String, pageSize: Int, start: Int): Int?

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
    fun deleteUsers(groupId: List<String>)

    fun getEntityById(userid: Int): UserEntity
}
