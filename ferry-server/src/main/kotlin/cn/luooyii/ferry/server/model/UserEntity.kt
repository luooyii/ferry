package cn.luooyii.ferry.server.model

/**
 * @author wanghuan
 */
class UserEntity {
    /**
     * id
     */
    var id: Int = 0
    /**
     * 姓名
     */
    var loginName: String? = null
    /**
     * 登录名
     */
    var name: String? = null
    /**
     * 密码
     */
    var password: String? = null
    /**
     * 用户类型（0:普通用户，1:管理员）
     */
    var usertype: Int? = null
    /**
     *
     */
    var email: String? = null
    /**
     * 头像url
     */
    var headimg: String? = null
    /**
     * GitHub主页
     */
    var url: String? = null
    /**
     * 注册时间
     */
    var createTime: String? = null

    var githubid: String? = null

    var qqid: String? = null
}
