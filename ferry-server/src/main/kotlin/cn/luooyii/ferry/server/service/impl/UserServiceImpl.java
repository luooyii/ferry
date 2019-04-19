package cn.luooyii.ferry.server.service.impl;

import cn.luooyii.ferry.server.dao.UserDao;
import cn.luooyii.ferry.server.model.UserEntity;
import cn.luooyii.ferry.server.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service(value = "userServiceImpl")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public void insert(UserEntity userEntity) {
        userDao.insert(userEntity);
    }

    @Override
    public void del(UserEntity userEntity) {
        userDao.del(userEntity);
    }

    @Override
    public UserEntity getUserEntityByLoginName(String loginName) {
        return userDao.getUserEntityByLoginName(loginName);
    }

    @Override
    public List<UserEntity> usersList(String name, int pageSize, int start) {
        return userDao.usersList(name, pageSize, start);
    }

    @Override
    public Integer usersSize(String name, int pageSize, int start) {
        return userDao.usersSize(name, pageSize, start);
    }

    @Override
    public void insertUser(UserEntity userEntity) {
        //userEntity.setPassword("{bcrypt}" + new BCryptPasswordEncoder().encode(userEntity.getPassword()));
        userDao.insertUser(userEntity);
    }

    @Override
    public void updateUser(UserEntity userEntity) {
        //userEntity.setPassword(new Md5PasswordEncoder().encodePassword(userEntity.getPassword(), null));
        if (userEntity.getId() != 8888) {
            //userEntity.setPassword("{bcrypt}" + new BCryptPasswordEncoder().encode(userEntity.getPassword()));
        }
        userDao.updateUser(userEntity);
    }

    @Override
    public void deleteUsers(List<String> groupId) {
        userDao.deleteUsers(groupId);
    }

    @Override
    public UserEntity getEntityById(int userid) {
        return userDao.getUserEntityById(userid);
    }

}
