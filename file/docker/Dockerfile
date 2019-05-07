# 拉取基础镜像
FROM adoptopenjdk/openjdk8-openj9
# 维者信息
MAINTAINER luooyii 609375086@qq.com

# 添加springboot项目到镜像中的home目录，并重命名为app.jar
ADD app.jar ~/app.jar

# 告诉Docker服务端暴露的端口，在容器启动时需要通过 -p 做端口映射
EXPOSE 8080

# 容器启动后执行的命令
ENTRYPOINT ["java","-jar","~/app.jar"]