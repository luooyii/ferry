package cn.luooyii.ferry.server.service;

import cn.luooyii.ferry.server.model.UserEntity;

import java.util.List;

public interface UserService {
	public void insert(UserEntity userEntity);

	public void del(UserEntity userEntity);

	/**
	 * 通过登录名得到用户信息
	 * @param loginName
	 * @return
	 */
	public UserEntity getUserEntityByLoginName(String loginName);

	/**
	 * 获取user列表
	 * @param name
	 * @param pageSize
	 * @param start
	 * @return
	 */
	public List<UserEntity> usersList(String name, int pageSize, int start);

	/**
	 * 获取user列表的总量
	 * @param name
	 * @param pageSize
	 * @param start
	 * @return
	 */
	public Integer usersSize(String name, int pageSize, int start);

	/**
	 * 新建用户信息
	 * @param userEntity
	 */
	public void insertUser(UserEntity userEntity);

	/**
	 * 更新用户信息
	 * @param userEntity
	 */
	public void updateUser(UserEntity userEntity);

	/**
	 * 删除用户信息
	 * @param groupId
	 */
	public void deleteUsers(List<String> groupId);

    UserEntity getEntityById(int userid);
}
