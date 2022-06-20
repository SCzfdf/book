read -p "输入项目名称: " project_name
echo $project_name

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64
BUILD_PATH=/home/project

# 创建项目目录
cd $BUILD_PATH # 优化
mkdir $project_name

# 创建项目配置文件
cd $project_name
touch $project_name".conf"

# 写入项目配置文件,一些启动参数也可以写里面
echo -e "JAVA_HOME="$JAVA_HOME" 
PID_FOLDER="$BUILD_PATH/$project_name/$project_name".pid
LOG_FOLDER="$BUILD_PATH/$project_name/$project_name".log" > $project_name".conf"

# 创建pid log 和临时jar
touch $project_name".log"
touch $project_name".pid"
touch $project_name".jar"

# 创建软连接
ln -s $BUILD_PATH/$project_name/$project_name".jar" /etc/init.d/$project_name
# 更改为可执行文件
chmod +x $project_name".jar"

# 更改为jenkins
chown jenkins:jenkins /var/lib/jenkins/workspace/build/ -R # 优化

exit 0
