read -p "输入项目名称: " project_name
echo $project_name

read -p "输入环境(sit,uat): " active_name
echo $active_name


JAVA_HOME=/usr/local/jdk1.8.0_201/
BUILD_PATH=/home/jenkins #不加斜杠

# 创建项目目录
cd $BUILD_PATH 
mkdir $project_name

# 创建项目配置文件
cd $project_name
touch $project_name".conf"

# 写入项目配置文件,一些启动参数也可以写里面
            # 优化
echo -e "JAVA_HOME="$JAVA_HOME"
PID_FOLDER="$BUILD_PATH/$project_name/$project_name".pid
LOG_FOLDER="$BUILD_PATH/$project_name/$project_name".log
JAVA_OPTS=\"-Xms128m -Xmx256m\"" > $project_name".conf"
# 如果要修改jvm参数 -> 使用JAVA_OPTS=xxx

# 选用的环境
echo -e "spring.profiles.active=$active_name" > application.properties

# 创建pid log 和临时jar
touch $project_name".log"
touch $project_name".pid"
touch $project_name".jar"

# 创建软连接
ln -s $BUILD_PATH/$project_name/$project_name".jar" /etc/init.d/$project_name
# 更改为可执行文件
chmod +x $project_name".jar"

# 更改为jenkins
chown jenkins:jenkins $BUILD_PATH -R 

exit 0
