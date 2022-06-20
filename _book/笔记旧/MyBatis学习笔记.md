

## 一. MyBatis访问数据库方式

### 1.1 MyBatis环境搭建

#### 	1.1.1 创建JAVA工程导入相应的JAR包

![1533706692901](C:\Users\love月堂\AppData\Local\Temp\1533706692901.png)



#### 		1.1.2 编写mybatis的conf的xml文件

![1533706810600](C:\Users\love月堂\AppData\Local\Temp\1533706810600.png)



#### 		1.1.3 创建对应的实体类和实体类对应的mapper.xml文件	

![1533706945871](C:\Users\love月堂\AppData\Local\Temp\1533706945871.png)



![1533707018086](C:\Users\love月堂\AppData\Local\Temp\1533707018086.png)







### 1.2 直接通过Mapper配置文件访问

#### 	1.2.1 直接创建测试类

![1533707083422](C:\Users\love月堂\AppData\Local\Temp\1533707083422.png)

直接不通过接口调用mapper.xml使用

```java
@Test
    public void testEmployee() throws IOException {
        //根据全局配置文件得到SqlSessionFactory；
        String resource = "spring-mybatis.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //使用sqlSession工厂，获取到sqlSession对象使用他来执行增删改查
        //一个sqlSession就是代表和数据库的一次会话，用完关闭
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //使用sql的唯一标志(com.crl.entities.Employee.selectByEmployeeId,一般写mapper.xml文件的namespace名字+对应的sql语句对应的id)来告诉MyBatis执行哪个sql。sql都是保存在sql映射文件中的。
        Employee emp = sqlSession.selectOne("com.crl.entities.Employee.selectByEmployeeId", 1);
        System.out.println(emp);
        //一个sqlSession就是代表和数据库的一次会话，用完关闭
        sqlSession.close();
    }
```

![1533707367902](C:\Users\love月堂\AppData\Local\Temp\1533707367902.png)



#### 	1.2.2 总结

		1、根据xml配置文件（全局配置文件）创建一个SqlSessionFactory对象 有数据源一些运行环境信息
	 	2、sql映射文件；配置了每一个sql，以及sql的封装规则等。 
		3、将sql映射文件注册在全局配置文件中
	  	4、写代码：
	 		1）、根据全局配置文件得到SqlSessionFactory；
	 		2）、使用sqlSession工厂，获取到sqlSession对象使用他来执行增删改查
	 			一个sqlSession就是代表和数据库的一次会话，用完关闭
	 		3）、使用sql的唯一标志来告诉MyBatis执行哪个sql。sql都是保存在sql映射文件中的。


			

### 1.3 通过接口访问（重点，常用，接口式编程）

#### 	1.3.1 创建接口类

![1533708072351](C:\Users\love月堂\AppData\Local\Temp\1533708072351.png)



#### 	1.3.2 把接口和mapper.xml进行动态绑定

1.把mapper.xml的namespace的属性值改为对应实体类的接口的全类名

2.将对应的sql语句的id属性改为实体类接口的方法名的名字

完成上述两步就可以进行动态绑定

![1533708677230](C:\Users\love月堂\AppData\Local\Temp\1533708677230.png)



#### 	1.3.3 创建测试类

![1533709577170](C:\Users\love月堂\AppData\Local\Temp\1533709577170.png)

	

#### 	1.3.4 总结

```java
@Test
    public void testEmployeeDao() throws IOException {
        //1.根据全局配置文件获取SqlSessionFactory对象
        String resource = "spring-mybatis.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.通过SqlSessionFactory获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.通过SqlSession的getMapper()方法对对应的接口进行操作(相当于获取接口的实现类对象)
        //employeeMapper这是一个代理对象(接口实现类的代理对象)
        //打印employeeMapper结果是org.apache.ibatis.binding.MapperProxy@6c3708b3
        EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);
        //调用接口实现类代理对象employeeMapper的方法进行操作
        Employee employee = employeeMapper.selectByEmployeeId(1);
        System.out.println(employee);
        //关闭SqlSession对象
        sqlSession.close();
    }
```

![1533709884818](C:\Users\love月堂\AppData\Local\Temp\1533709884818.png)



#### 	1.3.5 对于接口式编程的好处

限制了传入参数的类型和返回的接口，可有有不同类型的实现类，接口实现类可是使用mybatis或者hibernate来实现等等

将接口和实现分发 方便与扩展和维护

解耦，更安全的类型检查



### 2.总结

	

1、接口式编程

原生：		Dao		====>  DaoImpl
mybatis：	Mapper	====>  xxMapper.xml

2、SqlSession代表和数据库的一次会话；用完必须关闭；

3、SqlSession和connection一样都是非线程安全。每次使用都应该去获取新的对象。

意味这不能把SqlSession写成全局变量，原因：在多线程环境中，A线程把SqlSession使用了然后关闭了，B线程再拿来使用就使用不了了。

![1533711183520](C:\Users\love月堂\AppData\Local\Temp\1533711183520.png)

4、mapper接口没有实现类，但是mybatis会为这个接口生成一个代理对象。

（将接口和xml进行绑定）
EmployeeMapper empMapper =	sqlSession.getMapper(EmployeeMapper.class);

5、两个重要的配置文件：

mybatis的全局配置文件：包含数据库连接池信息，事务管理器信息等...系统运行环境信息

![1533711284675](C:\Users\love月堂\AppData\Local\Temp\1533711284675.png)



sql映射文件：保存了每一个sql语句的映射信息：将sql抽取出来。（这个文件必须要有）

![1533711330883](C:\Users\love月堂\AppData\Local\Temp\1533711330883.png)





## 二. Mybatis配置文件

### 2.1 引入dtd约束文件(为了代码有提示)

#### 	2.1.1 在Eclipse中引入dtd约束文件

先下载dtd约束文件，有网的情况下直接点击链接下载![1533711684111](C:\Users\love月堂\AppData\Local\Temp\1533711684111.png)

然后把本地dtd文件引入到项目中

![1533711737567](C:\Users\love月堂\AppData\Local\Temp\1533711737567.png)

![1533711757022](C:\Users\love月堂\AppData\Local\Temp\1533711782300.png)

![1533711828723](C:\Users\love月堂\AppData\Local\Temp\1533711828723.png)



key 就是链接名字

key type 选择URI

location 就是本地dtd路径



#### 2.1.2 在idea中引入dtd约束文件







### 2.2 配置文件中的properties属性

mybatis 可以使用properties来引入外部properties配置文件的内容

其中resource ：表示引入类路径下的资源

	url : 表示引入网络路径或者磁盘路径下的资源

![1533712225669](C:\Users\love月堂\AppData\Local\Temp\1533712225669.png)

当mybatis与spring整合的时候这一模块会教给spring管理

${对应的属性名}

在spring中可以取出properties配置文件中的值

在mybatis中可以取出properties配置文件中的值



### 2.3 配置文件中的settings属性

settings包含很多重要的设置项

	setting : 表示每一个具体的设置项
	
		name : 设置参数
	
		value : 设置参数的值

![1533712707303](C:\Users\love月堂\AppData\Local\Temp\1533712707303.png)



![1533712522659](C:\Users\love月堂\AppData\Local\Temp\1533712522659.png)

mapUnderscoreToCamelCase 驼峰命名法



### 2.4 配置文件中的typeAliases属性（别名不区分大小写）

#### 2.4.1 配置版单个起别名

typeAliases也叫做别名处理器：作用就是把类型别名是为 Java 类型设置一个短的名字，可以方便我们 引用某个类

mybatis中如果每次配置类名都要写全称也不太友好，我们可以通过再主配置文件中配置别名，就不再需要指定完整的包名了。

![1533722429651](C:\Users\love月堂\AppData\Local\Temp\1533722429651.png)

![1533722455180](C:\Users\love月堂\AppData\Local\Temp\1533722489280.png)



#### 2.4.2 配置版批量别名

![1533722612982](C:\Users\love月堂\AppData\Local\Temp\1533722612982.png)

![1533722726607](C:\Users\love月堂\AppData\Local\Temp\1533722726607.png)



#### 2.4.3 注解版起别名

![1533722806166](C:\Users\love月堂\AppData\Local\Temp\1533722806166.png)

别名执行顺序

配置版单个起别名==注解版起别名  >   批量起别名

配置版单个起别名和注解版起别名一起使用都起作用

![1533723131599](C:\Users\love月堂\AppData\Local\Temp\1533723131599.png)

![1533723161215](C:\Users\love月堂\AppData\Local\Temp\1533723161215.png)

![1533723168125](C:\Users\love月堂\AppData\Local\Temp\1533723168125.png)



#### 2.4.4 namespace的属性值不能起别名

在mybatis中，Mapper.xml中的namespace是用于绑定Dao接口的，即面向接口编程。

它的好处在于使用了namespace之后可以不用写接口实现类，业务逻辑会直接通过这个绑定寻找相对应的SQL语句进行对应的数据处理。

```java
//namespace中的属性值com.crl.dao.EmployeeMapper不能使用别名，不然会报错。
<mapper namespace="com.crl.dao.EmployeeMapper">
    <select id="selectByEmployeeId" resultType="emp">
        SELECT * FROM  employee WHERE employee_id = #{id}
    </select>
</mapper>
```

### 2.5 配置文件中的typeHandlers属性（类处理器）

typeHandlers 类处理器是架起java数据类型和数据库数据类型一一映射的桥梁

如java类中的String类型 转化为 数据库的varchar类型

![1533777787625](C:\Users\love月堂\AppData\Local\Temp\1533777787625.png)

![1533777802006](C:\Users\love月堂\AppData\Local\Temp\1533777802006.png)

### 2.6 配置文件中的plugins属性（插件）





### 2.7 配置文件中的enviroments属性（运行环境）

![1533778277725](C:\Users\love月堂\AppData\Local\Temp\1533778277725.png)

environments：环境们，mybatis可以配置多种环境 ,default指定使用某种环境。可以达到快速切换环境。
    environment：配置一个具体的环境信息**；必须有两个标签**；id代表当前环境的唯一标识
	transactionManager：事务管理器；
		type：事务管理器的型;JDBC(JdbcTransactionFactory)|MANAGED(ManagedTransactionFactory)

自定义事务管理器：实现TransactionFactory接口.type指定为全类名
	dataSource：数据源;
		type:数据源类型;UNPOOLED(UnpooledDataSourceFactory)
			|POOLED(PooledDataSourceFactory)
			|JNDI(JndiDataSourceFactory)

自定义数据源：实现DataSourceFactory接口，type是全类名



### 2.8 配置文件中的databaseldProvider属性

databaseIdProvider：支持多数据库厂商的；
	 type="DB_VENDOR"：VendorDatabaseIdProvider
	作用就是得到数据库厂商的标识(驱动getDatabaseProductName())，mybatis就能根据数据库厂商标识来执行不同的sql;
	厂商的标识：MySQL，Oracle，SQL Server,xxxx

```java
<databaseIdProvider type="DB_VENDOR">
		<!-- 为不同的数据库厂商起别名 -->
		<property name="MySQL" value="mysql"/>
		<property name="Oracle" value="oracle"/>
		<property name="SQL Server" value="sqlserver"/>
	</databaseIdProvider>
```



使用databaseldProvider进行多数据库支持

#### 2.8.1 编写主配置文件中的databaseIdProvider属性

![1533779089638](C:\Users\love月堂\AppData\Local\Temp\1533779089638.png)



#### 2.8.2 在mapper.xml配置文件中使用databaseId

使用databaseId来指定在什么环境下执行

![1533779240569](C:\Users\love月堂\AppData\Local\Temp\1533779240569.png)

这表示这条sql语句是在mysql数据库下才能执行

![1533779376587](C:\Users\love月堂\AppData\Local\Temp\1533779376587.png)

这样就可以匹配多个环境



#### 2.8.3 在主配置文件中的enviroments中使用default来指定开发环境

![1533779701038](C:\Users\love月堂\AppData\Local\Temp\1533779701038.png)





### 2.9 配置文件中的mappers属性

![1533784142865](C:\Users\love月堂\AppData\Local\Temp\1533784142865.png)



#### 2.9.1 mappers的属性介绍

mappers：将sql映射注册到全局配置中

	mapper:注册一个sql映射 
	
	注册配置文件			
	
		resource：引用类路径下的sql映射文件	mybatis/mapper/EmployeeMapper.xml			
	
		url：引用网路路径或者磁盘路径下的sql映射文件	file:///var/mappers/AuthorMapper.xml									 	
	
	注册接口			
	
		class：引用（注册）接口，				
	
			1、有sql映射文件，映射文件名必须和接口同名，并且放在与接口同一目录下；				
	
			2、没有sql映射文件，所有的sql都是利用注解写在接口上;	
	
			推荐：					
	
				比较重要的，复杂的Dao接口我们来写sql映射文件					
	
				不重要，简单的Dao接口为了开发快速可以使用注解；

#### 2.9.2 resource注册配置文件

使用resource注册的时候，对应的mapper.xml不一定要放在和接口类的同一目录下

只要在resource的属性值里面写好对应的路径即可

![1533784996684](C:\Users\love月堂\AppData\Local\Temp\1533784996684.png)

路径用/分隔不要用.

![1533785038479](C:\Users\love月堂\AppData\Local\Temp\1533785038479.png)



其次接口名字必须和配置文件的名字不需要一样

![1533785179127](C:\Users\love月堂\AppData\Local\Temp\1533785179127.png)





#### 2.9.3mappers中的mapper中的class属性（引用接口）的使用

##### 2.9.3.1 第一种注册方式（class属性值是接口全路径）

![1533784529299](C:\Users\love月堂\AppData\Local\Temp\1533784623872.png)

	直接运行会报错

想要成功运行，则对应的mapper.xml要放在和接口类的同一目录下，并且接口名字必须和配置文件的名字一样

![1533784674731](C:\Users\love月堂\AppData\Local\Temp\1533784674731.png)



##### 2.9.3.2 第二种注册方式（使用注解注册）

使用class属性引入接口全类名，然后直接在方法里面使用注解写sql语句，这样就不要写mapper.xml配置文件了，不过这样不方便维护，所以对于不重要的可以使用注解注册

![1533791789219](C:\Users\love月堂\AppData\Local\Temp\1533791789219.png)



#### 2.9.4 package批量注册

![1533792127088](C:\Users\love月堂\AppData\Local\Temp\1533792127088.png)

使用批量注册存在的问题，对于使用注解版的接口可以正常运行，而对于使用mapper.xml配置文件的则会报错

配置文件必须和接口同包名同名字

![1533792385004](C:\Users\love月堂\AppData\Local\Temp\1533792385004.png)



## 三. mybatis的sql映射文件(mapper.xml)的增删查改

![1533802676078](C:\Users\love月堂\AppData\Local\Temp\1533802676078.png)

### 3.1 查询

![1533804226326](C:\Users\love月堂\AppData\Local\Temp\1533804226326.png)



### 3.2 添加

![1533804797504](C:\Users\love月堂\AppData\Local\Temp\1533804797504.png)



### 3.3 修改（更新）

![1533804902046](C:\Users\love月堂\AppData\Local\Temp\1533804902046.png)

```java
 @Test
    public void testAdd() throws IOException {
        //获取SqlSessionFactory工厂对象
        String resource = "spring-mybatis.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //获取代理的接口实现类
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        Employee employee = new Employee();
        employee.setEmployeeName("BB");
        employee.setEmployeeSex('男');
        //进行添加操作
        Integer flag = mapper.addEmoloyee(employee);
        System.out.println(flag);
        //提交事务
        sqlSession.commit();
        //关闭SqlSession
        sqlSession.close();
    }
```



### 3.4 删除

![1533804957169](C:\Users\love月堂\AppData\Local\Temp\1533804957169.png)

### 3.5 扩展1 （增删查改sql语句的参数类型）

paramterType 参数类型 ： 可省略

![1533805114737](C:\Users\love月堂\AppData\Local\Temp\1533805114737.png)



### 3.6 扩展2（增删改操作的返回值）

mybatis 允许增删改定义以下类型的返回值（mybatis会帮我们自动封装成功）

 int、long 、boolean 这三种类型以及它们的包装类

增删改sql语句返回的时影响行数，如果影响行数大于1，则boolean返回值为true， int、long对应返回值是影响行数

![1533805934324](C:\Users\love月堂\AppData\Local\Temp\1533805934324.png)

![1533806047163](C:\Users\love月堂\AppData\Local\Temp\1533806047163.png)

![1533806083247](C:\Users\love月堂\AppData\Local\Temp\1533806083247.png)

![1533806494593](C:\Users\love月堂\AppData\Local\Temp\1533806494593.png)



### 3.7 扩展2（执行操作后返回主键ID）

#### 3.7.1 获取自动增长主键（mysql数据库自动增长主键）

	mysql支持主键自增，自增主键值得获取，mybatis也是利用statement.getGenreatedKeys();
	
	useGeneratedKeys="true" 表示使用自增主键获取主键值策略
	
	keyProperty="" 表示指定对于得主键属性，也就是获取到主键值后，将这个值封装给javaBean的哪个属性![1533807718198](C:\Users\love月堂\AppData\Local\Temp\1533807718198.png)


	

```java
 <!--void addEmoloyee(Employee employee);-->
     //useGeneratedKeys="true" 表示使用自增主键获取主键值策略
     //keyProperty="" 表示指定对于得主键属性，也就是获取到主键值后，将这个值封装给javaBean的哪个属性
    <insert id="addEmoloyee" parameterType="com.crl.entities.Employee"
            useGeneratedKeys="true" keyProperty="employeeId">
        INSERT  INTO employee(employee_name,employee_sex)
        VALUES(#{employeeName},#{employeeSex})
    </insert>
```



#### 3.7.2 获取非自动增长主键（获取oracle数据库通过序列实现的自动增长主键）

Oracle不支持自增，Oracle使用序列来模拟自增；

每次插入的数据的主键是从序列中拿到的值；

如何获取到这个值呢？

```xml
<!-- 
	获取非自增主键的值：
		Oracle不支持自增；Oracle使用序列来模拟自增；
		每次插入的数据的主键是从序列中拿到的值；如何获取到这个值；
	 -->
	<insert id="addEmp" databaseId="oracle">
		<!-- 
		keyProperty:查出的主键值封装给javaBean的哪个属性
		order="BEFORE":当前sql在插入sql之前运行
			   AFTER：当前sql在插入sql之后运行
		resultType:查出的数据的返回值类型
		
		BEFORE运行顺序：
			先运行selectKey查询id的sql；查出id值封装给javaBean的id属性
			在运行插入的sql；就可以取出id属性对应的值
		AFTER运行顺序：
			先运行插入的sql（从序列中取出新值作为id）；
			再运行selectKey查询id的sql；
		 -->
		<selectKey keyProperty="id" order="BEFORE" resultType="Integer">
			<!-- 编写查询主键的sql语句 -->
			<!-- BEFORE-->
			select EMPLOYEES_SEQ.nextval from dual 
			<!-- AFTER：
			 select EMPLOYEES_SEQ.currval from dual -->
		</selectKey>
		
		<!-- 插入时的主键是从序列中拿到的 -->
		<!-- BEFORE:-->
		insert into employees(EMPLOYEE_ID,LAST_NAME,EMAIL) 
		values(#{id},#{lastName},#{email<!-- ,jdbcType=NULL -->}) 
		<!-- AFTER：
		insert into employees(EMPLOYEE_ID,LAST_NAME,EMAIL) 
		values(employees_seq.nextval,#{lastName},#{email}) -->
	</insert>
```

### 3.8 映射文件的参数处理

#### 3.8.1 mybatis参数处理原理

#### 3.8.2 单个参数处理（单个参数mybatis不做特殊处理）

使用#{参数名} 就可以取出参数 ：在单个参数的情况下参数名可以随便写

![1533863897606](C:\Users\love月堂\AppData\Local\Temp\1533863897606.png)

#### 3.8.3 多个参数处理(mybatis会将参数封装成map集合)

对于多个参数，Mybati会做特殊处理

多个参数会被封装成一个map

	对应默认的key和value分别是：
	
		key : param1 ........  paramN （或者参数的索引 0  ......  N）
	
		value : 传入的参数值

在多个参数的时候使用#{}	 就是从map中获取指定的key的值

![1533866879415](C:\Users\love月堂\AppData\Local\Temp\1533866879415.png)

##### 3.8.3.1 使用索引来指定参数的值

![1533867081462](C:\Users\love月堂\AppData\Local\Temp\1533867081462.png)

##### 3.8.3.2 使用默认key值(param1...paramN)来指定参数的值

![1533867168438](C:\Users\love月堂\AppData\Local\Temp\1533867168438.png)

	

##### 3.8.3.3 使用命名参数(@Param注解)来指定封装参数时map的key的名字进而来指定参数的值

命名参数：明确指定封装参数时map的key：@Param("属性名")

	多个参数会被封装成一个map
	
		key : 使用@Param注解指定的值
	
		value : 参数值

![1533867423310](C:\Users\love月堂\AppData\Local\Temp\1533867423310.png)

##### 3.8.3.4 使用pojo(实体类)来指定参数的值（多个参数正好时我们业务逻辑的数据类型，我们可以直接传入实体类pojo）

如果多个参数正好时我们业务逻辑的数据类型，我们可以直接传入实体类pojo

则 #{参数值} ：参数值就是传入的实体类pojo对应的成员变量的值(属性值) 即 参数值=pojo.属性名



##### 3.8.3.5 使用map来指定参数的值（多个参数不是业务逻辑的数据，没有对应的pojo时可以传入map）

如果多个参数不是业务模型中的数据，没有对应的pojo ，为了方便 ，可以传入map

则 #{参数值} ： 参数值对应就是传入map对象的key值即 参数值=map.key

![1533869102824](C:\Users\love月堂\AppData\Local\Temp\1533869102824.png)![1533869194751](C:\Users\love月堂\AppData\Local\Temp\1533869194751.png)



##### 3.8.3.6 使用TO(数据传输对象)来指定参数的值（如果多个参数不是业务模型中的数据，但要经常使用，使用TO）

如果多个参数不是业务模型中的数据，但是要经常使用，推荐来编写TO(Transfer Object) 数据传输对象





##### 3.8.3.7 扩展



![1534304151805](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534304151805.png)





##### 3.8.3.8 mybatis 参数封装源码分析



#### 3.8.4 参数的处理 ${} 和 #{} 的区别

##### 3.8.4.1 区别

1.#{}：可以获取map中的值或者pojo对象属性的值

2.${}：可以获取map中的值或者pojo对象属性的值

![1533880555750](C:\Users\love月堂\AppData\Local\Temp\1533880555750.png)



	区别：
	
		在#{}中：是以预编译的形式，将参数设置到sql语句中；相当于JDBC中的PerparedStatement; 这种形式可以防止SQL注入的问题
	
		在${}中：取出的值直接拼接在sql语句中，会有安全问题
	
	总结：对于sql语句中不能预编译的字段使用${}来取值，即原生JDBC不支持占位符的地方我们可以使用

${}进行取值

![1533880857677](C:\Users\love月堂\AppData\Local\Temp\1533880857677.png)



##### 3.8.4.2 使用#{}规定参数的一些规则

规定参数的一些规则：
	javaType、 jdbcType、 mode（存储过程）、 numericScale、
	resultMap、 typeHandler、 jdbcTypeName、 expression（未来准备支持的功能）；



jdbcType通常需要在某种特定的条件下被设置：

在我们数据为null的时候，有些数据库可能不能识别mybatis对null的默认处理。比如Oracle（报错）；

JdbcType OTHER：无效的类型；因为mybatis对所有的null都映射的是原生Jdbc的OTHER类型，oracle不能正确处理;

由于全局配置中：jdbcTypeForNull=OTHER；oracle不支持；两种办法

1、#{email,jdbcType=OTHER};

![1533885354094](C:\Users\love月堂\AppData\Local\Temp\1533885354094.png)



2、jdbcTypeForNull=NULL
   <setting name="jdbcTypeForNull" value="NULL"/>

![1533885411312](C:\Users\love月堂\AppData\Local\Temp\1533885411312.png)



### 3.9 映射文件的返回值是resultType问题

![1533895506400](C:\Users\love月堂\AppData\Local\Temp\1533895506400.png)



![1533885498903](C:\Users\love月堂\AppData\Local\Temp\1533885498903.png)

##### 3.9.1 对于接口返回值是单个对象的时候

###### 3.9.1.1 对于select标签(对应sql映射的返回值类型resultType的返回值是对应实体类的全路径)

![1533886445182](C:\Users\love月堂\AppData\Local\Temp\1533886520335.png)

###### 3.9.1.2  对于增删改标签（由于mybatis自动帮我们封装，所以不用写resultType）

![1533886650066](C:\Users\love月堂\AppData\Local\Temp\1533886650066.png)



##### 3.9.2 对于接口返回值是List集合的时候 

对于接口返回值是list集合，则对于的sql映射文件的返回值是List集合中的元素类型

![1533887001402](C:\Users\love月堂\AppData\Local\Temp\1533887001402.png)



##### 3.9.3 对于接口返回值是Map集合的时候

###### 	3.9.3.1 返回一条记录的map (此时key就是列名，值就是数据库列名对应的值)

![1533888607238](C:\Users\love月堂\AppData\Local\Temp\1533888607238.png)



###### 	3.9.3.2 多条记录的map封装（Map<String,Employee>此时key需要指定，值就是指定Employee的对象值）

	如果是多条记录的map封装，则sql映射文件的resultType返回值是接口类返回值的value属性
	
	其次还要使用@MapKey指定sql映射文件返回的map集合的key值，不然会报错。

![1533894971212](C:\Users\love月堂\AppData\Local\Temp\1533894971212.png)



	不使用@MapKey指定sql映射文件返回的map集合的key值，报错

![1533895114205](C:\Users\love月堂\AppData\Local\Temp\1533895114205.png)



### 3.10 映射文件返回值类型是resultMap(resultMap和resultType不能一起使用)



![1533895512612](C:\Users\love月堂\AppData\Local\Temp\1533895512612.png)

	

resultMap : 自定义结果集映射规则

![1533956612302](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533956612302.png)



```xml
其他不指定的列会自动封装，我们只需要写resultMap就可以把全部映射的规则都写上
即只要写resultMap标签和id标签即可
注意：如果省略不写其他普通封装规则并且数据库字段名和JAVABean属性名不一样，属于驼峰命名法的话
	 则要开启驼峰命名法
	 如果不省略其他普通封装规则，则可以关闭驼峰命名法
```

省略其他字段但开启驼峰命名法

![1533956848422](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533956848422.png)



省略其他字段且不开启驼峰命名法

![1533957068223](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533957101711.png)



#### 3.10.1 resultMap应用场景1(关联查询)

##### 	3.10.1.1 级联属性查询

使用级联属性封装成结果集

![1533969996141](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533969996141.png)

 对于resultMap的返回值类型 type属性对应的JavaBean，JavaBean中除了主键列和对象之外，其他成员变量可忽略不写

![1533970131761](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533970131761.png)



##### 3.10.1.2 association定义关联对象封装规则

![1533970752182](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533970752182.png)



property 是 对象属性名

column 是 数据库字段名

使用association之后 不能省略写其他属性的封装规则

![1533971017895](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533971017895.png)



![1533971040863](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533971040863.png)

注意：resultMap中的id标签和association的id标签的colunm不能相同，如果相同则association中的id就是resulltMap中的id

#### 3.10.2  分步查询（使用association分步查询）

	association定义关联对象的封装规则
	
		select : 表明当前属性是调用select指定的方法查出结果（namespace+id名字）
	
		column : 指定哪一列的值传给这个方法（指对于select指定的方法有参数传递的要给对应的实体类对应的数据库的字段赋值，如：Employee的外键数据库字段名是department_id，则column的值就是department_id）
	
		流程：使用select指定的方法(传入column指定的这一列参数的值)查出对象，并封装给property

![1533974919693](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533974919693.png)



#### 3.10.3 延迟加载（association分步查询的延迟加载）

	使用association进行分步查询的时候，没有使用关联的对象的时候，关联对象也会一起被查询出来

![1533975549448](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533975549448.png)



	分步查询要实现延迟加载需要进行两部
	
	1.在全局配置文件中的settings属性中设置<setting name="lazyLoadingEnabled“ value="true" />这表示开始懒加载模式
	
	2.在全局配置文件中的settings属性中设置<setting name="aggressiveLazyLoading“ value="false" />表示侵入延迟加载功能，true表示这些属性会被完整的加载，任何情况下都会加载全部加载

false则表示在需要的时候才加载，即按需加载



![1533975782311](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533975782311.png)



![1533976153314](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1533976153314.png)

#### 3.10.4 小结（单个对象可以使用association或者级联属性查询，返回是集合的时候使用collection定义关联集合）





#### 3.10.5 关联查询返回集合对象（使用collection定义关联集合封装规则）



![1534036946562](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534036946562.png)



#### 3.10.6 关联查询返回集合对象的分步查询

目标：查询部门表的部门id对应的员工表的所有员工

分步：1.编写员工表的根据部门id获取员工集合对象的sql映射文件

![1534037932009](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534038986607.png)



	2.编写部门表按部门id 查询部门

![1534039197540](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534039197540.png)



#### 3.10.7 关联查询返回集合对象的延迟加载

1.在全局配置中配置

2.在collection标签中使用fetchType来指定：

![1534039551410](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534039551410.png)

#### 3.10.8 关联查询返回集合对象分步查询的传递多列值

![1534039664773](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534039664773.png)



#### 3.10.9 discriminator 鉴别器

discriminator 鉴别器：mybatis可以使用discriminator判断某列的值,然后根据某列的值改变封装行为

column：指定判定的列名

javaType：列值对应的java类型

case : 返回结果

	value : 写column指定列名的值
	
	resultType : 

```java
<discriminator javaType="" column="">
            <case value="" resultType=""></case>
</discriminator>
```

![1534041721899](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534041721899.png)







### 3.11 当查出的数据的列名和跟JavaBean的属性名不一样的解决办法

1.在编写sql语句时起别名

2.开启驼峰命名法

3.使用resultMap



## 四. 动态sql

动态sql标签

![1534041873590](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534041873590.png)

动态sql的判断表达式是使用OGNL表达式进行判断

![1534042808030](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534042808030.png)





### 4.1 动态sql的if标签

http://www.w3school.com.cn/tags/html_ref_entities.html

![1534063160351](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534063160351.png)

![1534141031976](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534141031976.png)

test：判断表达式（使用OGNL进行判断）

OGNL参照官方文档

http://commons.apache.org/proper/commons-ognl/language-guide.html

![1534142610202](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534142610202.png)

```java
test：判断表达式 从参数中取值进行判断
<if test="employeeId!=null" >
    AND employee_id = #{employeeId}
</if>
```

![1534141198212](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534141198212.png)



遇到特殊字符应该写转义字符

![1534146401612](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534146401612.png)

![1534063160351](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534063160351.png)

![1534212911181](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534212911181.png)



![1534148236743](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534148236743.png)

![1534148789614](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534148789614.png)

![1534148840838](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534148840838.png)







### 4.2 动态sql带where查询条件的处理

![1534148936683](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534148936683.png)



#### 4.2.1 方式一（使用where 1 = 1）

在where后面添加 1= 1 

然后在if标签里面的语句 添加and 

![1534148639922](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534148639922.png)



#### 4.2.2 方式二（使用where标签，mybatis推荐使用）

使用where标签对于AND在前面的拼接条件 mybatis会自动帮我们去除and

![1534149265906](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534149265906.png)



对于AND在后面的拼接条件，mybatis不会自动帮我们自动去除

![1534149388700](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534149388700.png)



### 4.3 动态sql的trim标签（自定义字符串的截取规则）



对于后面多出的and或者or where标签不能解决，可以只用trim标签

trim 的属性

	prefix = "" ：前缀 trim标签体中是整个字符串拼串后的结果
	
				prefix 给拼串后的整个字符串加一个前缀
	
	prefixOverrides="" ：
	
				前缀覆盖：去掉整个字符串前面多余的字符
	
	suffix = "" ：后缀
	
				suffix给拼串后的整个字符加一个后缀
	
	suffixOverrides = "" ：
	
				后缀覆盖：去掉整个字符串后面多余的字符

![1534212973496](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534212973496.png)

### 4.4 动态sql的choose...when标签（分支选择相当于java中的带了breakd的 switch-case）

如果是id就用id查，如果带了name的就用name查，带了哪个字段就进哪个条件，只会进入其中一个

![1534215346405](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534215346405.png)



### 4.5 动态sql的set与if结合（相对于update语句）

#### 4.5.1 方式一(set语句单独写出来)

![1534218480689](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534218480689.png)



#### 4.5.2 方式二（使用set标签）

对于拼接条件可能会有多余的逗号所以可以使用set标签，会自动帮我们去掉后缀的逗号

![1534218707440](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534218707440.png)



#### 4.5.3 方式三（使用trim标签）

![1534218820136](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534218820136.png)



![1534218892080](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534218892080.png)



### 4.6  动态sql的foreach标签

#### 4.6.1 foreach标签遍历集合

collection：指定要遍历的集合

	list 类型的参数会特殊处理封装在map中，map的key值就是list（可以在接口方法定义上使用@Param注解指定key的值）
	
	item：将当前遍历出来的元素赋值给指定的变量
	
	这里#{item的属性值} 就能取出当前遍历出的元素
	
	separator：指定每个元素之间的分隔符

```
对于 SELECT  * FROM  employee where employee_id IN (1,2,3); 集合元素(1,2,3) 之间分隔符就是,
Arrays.asList(1,2,3) 变成一个list集合对象
```

	open：遍历出的所有结果拼接一个开始的字符
	
	close：遍历出的所有结果拼接一个结束的字符
	
	index：索引。遍历list的时候是ndex是索引，item是值
	
			遍历map集合的时候，index表示的是map的key item就是map的值

![1534228702702](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534228702702.png)



在接口方法定义上使用@Param注解指定key的值（没有指定mybatis就会将list集合的key设为list）

![1534228962713](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534228962713.png)



使用open 和 close属性

![1534229441217](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534229441217.png)



#### 4.6.2 foreach标签批量插入

##### 4.6.2.1 mysql下的foreach批量插入

在mysql下,支持使用values批量保存

```sql
insert into 表名（属性1，属性2，....属性n）values（属性1，属性2，....属性n），values(属性1，属性2，....属性n)，......values(属性1，属性2，....属性n)
```

默认不支持发多天插入的sql语句批量保存

```sql
insert into 表名（属性1，属性2，....属性n）values（属性1，属性2，....属性n）；
insert into 表名（属性1，属性2，....属性n）values（属性1，属性2，....属性n）；
.....
insert into 表名（属性1，属性2，....属性n）values（属性1，属性2，....属性n）
```



###### 4.6.2.1.1  方式一：使用多个values批量插入

![1534230774782](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534230774782.png)



###### 4.6.2.1.2 方式二：连续发多个insert语句

发送语句正常，但是mysql默认不支持多条插入语句同时执行

![1534231851665](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534231851665.png)

解决方法：在数据库url上的添加连接属性allowMultiQueries=true

![1534232212726](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534232212726.png)



###### 4.6.2.1.3 总结

对于方式二这种分号分隔多个sql可以用于其他的批量操作(删除，修改)

##### 4.6.2.2 orcal下的foreach批量插入

对于oracle数据库不支持values(),(),()这种方式

oracle支持的批量插入格式有三种

第一种方式是(多个insert放在begin - end里面)：

```sql
begin
	insert into 表名（employee_id，属性2，....属性n）values（employee_seq.nextval，属性2，....属性n）；
	insert into 表名（employee_id，属性2，....属性n）values（employee_seq.nextval，属性2，....属性n）；
	......
	insert into 表名（employee_id，属性2，....属性n）values（employee_seq.nextval，属性2，....属性n）；(最后一个insert语句也要有；)
end;
```



第二种方式是(利用中间表)：

![1534233243116](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534233243116.png)

```mysql


```



### 4.7 动态sql的两个内置参数

不只是方法传递过来的参数可以被用来判断,取值....

mybatis默认还有两个内置参数：

	_paramter : 代表整个参数
	
		单个参数：_paramter就是这个参数
	
		多个参数：参数会被封装成一个map; _paramter就是代表这个map
	
	_databaseId：如果配置了databaseIdProvider标签。
	
		_databaseId就是代表当前数据库的别名

#### ![1534311502044](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534311502044.png)



### 4.8 动态sql的bind属性



![1534312716052](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534312716052.png)

### 4.9 动态sql的sql标签（抽取可重用的sql片段）



![1534313694398](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534313694398.png)



![1534313732716](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534313732716.png)



![1534313784628](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534313784628.png)



![1534313817083](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534313817083.png)



## 五.mybatis缓存

两级缓存：

	一级缓存：（本地缓存）
	
		与数据库同一次会话期间查询到的数据会放在本地缓存中
	
		以后如果需要获取相同的数据，直接从缓存中拿，没必要再去查数据库；
	
	二级缓存：（全局缓存）



### 5.1  mybatis 一级缓存(sqlSession级别缓存，一级缓存一直开启的，不能被关闭)

mybatis默认会自动使用一级缓存

执行了两次相同的操作，只会了一次sql语句，第二次获取的数据是直接从本地缓存中获取的

所以emp01==emp02 是true

![1534321257417](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534321257417.png)

#### 5.1.1 一级缓存失效（四种情况）

没有使用到一级缓冲的情况，效果就是，还需要再向数据库发送sql语句

![1534386609536](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534386609536.png)

### 5.1.2  mybatis二级缓存

#### 5.1.2.1 二级缓存介绍

![1534386870907](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534386870907.png)

#### 5.1.2.2 开启二级缓存配置

![1534388396895](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534388396895.png)



1.在全局配置文件中配置cacheEnabled 

![1534387081139](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534387081139.png)

2.在mapper映射文件中使用cashe开启二级缓存

![1534387185220](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534387185220.png)



eviction : 缓存的回收策略

		LRU：最近最少使用的：移除最长时间不被使用的对象
	
		FIFO：先进先出：按对象进入缓存的顺序来移除他们
	
		SOFT：软引用：移除基于垃圾回收器状态和软引用规则的对象
	
		WEAK：弱引用：更积极地移除基于垃圾收集器状态和弱引用规则的对象、
	
		mybatis默认使用LRU策略

flushInterval ：缓存刷新间隔，单位毫秒

		缓存多长时间清空一次
	
		mybatis默认不清空缓存

readOnly：是否只读

		true：只读，mybatis认为所有从缓存中获取的数据	都是只读操作，不会修改数据
	
					mybatis为了加快获取速度，直接就会将数据在缓存中的引用交给用户。不安全，速度快
	
		false：非只读，mybatis觉得获取的数据可能会被修改
	
					mybatis会利用序列&反序列级技术克隆一份新的数据。安全，速度慢（存在序列反序列化）
	
		默认是false

size ：缓存存放多少元素

type ：指定自定义缓存全类名

	     实现Cache接口即可







3.实体类要实现序列号接口

![1534388317426](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534388317426.png)



  使用了二级缓存运行结果图

![1534398161690](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534398161690.png)





注意：只有会话SqlSession关闭后才能使用二级缓存

原因：查出的数据都会默认先放在一级缓存中

	    只有会话提交或者关闭后，一级缓存中的数据才会转移到二级缓存中

![1534398737777](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534398737777.png)



### 5.3 和缓存相关的设置/属性

1、全局配置文件中的cacheEnabled=true  false：表示关闭缓存（二级缓存关闭，一直缓存一直可用）



2、每个select标签都有useCache="true"  false：表示不使用缓存（一级缓存依然使用，二级缓存不使用）



3、每个增删改标签的flushCache="true" 

		增删改执行完成后就会清除缓存
	
		测试：flushCache="true" ：一级缓存就清空了，二级缓存也会c清空



4、SqlSession.clearCache：只是清除当前的一级缓存，对于二级缓存不清除



5、	localCacheScope(mybatis3.3之后才有这个属性)：SESSION|STATEMENT

		本地缓存作用域：（影响一级缓存），当前会话的所有数据b保存在会话缓存中
	
		STATEMENT：禁用一级缓存



### 5.4 mybatis缓存原理

![1534403124459](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534403124459.png)



### 5.5 mybatis缓存第三方缓存整合

	mybatis整合ehcache



## 六. Spring、SpringMVC与Mybatis整合

### 6.1 先整合SpringMVC

#### 6.1.1 编写springmvc的配置文件	

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.0.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <!--SpringMVC只是控制网站跳转逻辑  -->
    <!-- 只扫描控制器 -->
    <context:component-scan base-package="com.crl.controllers" use-default-filters="false">
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>

    <!-- 视图解析器 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/pages/"></property>
        <property name="suffix" value=".jsp"></property>
    </bean>
	 <!-- 处理动态资源 -->
    <mvc:annotation-driven></mvc:annotation-driven>
     <!-- 处理静态资源 -->
    <mvc:default-servlet-handler/>
</beans>
```



#### 6.1.2 编写springmvc的web.xml









## 七. Mybatis的逆向工程

### 7.1 逆向工程环境搭建

#### 7.1.1 下载对应的jar包或者在pom文件中写入对应的依赖

##### 7.1.1.1 在github上面搜索mybatis

![1534820708976](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820708976.png)



##### 7.1.1.2 搜索完后进去mybatis工程目录

![1534820782169](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820782169.png)



![1534820794486](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820794486.png)



##### 7.1.1.3 在mybatis目录下找generator工程并点击进入

![1534820884703](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820884703.png)



![1534820903277](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820903277.png)

![1534820917525](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820917525.png)

##### 7.1.1.4 点击releases

![1534820977856](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534820977856.png)

![1534821030549](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534821030549.png)

#### 7.1.2 编写generationConfig.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <!--<classPathEntry location="/Program Files/IBM/SQLLIB/java/db2java.zip"/>-->
	//数据库连接，targetRuntime指的是生成的版本 
    <context id="DB2Tables" targetRuntime="MyBatis3">
        <jdbcConnection driverClass="com.mysql.jdbc.Driver"
                        connectionURL="jdbc:mysql://rm-wz9ltcfn80g8fk3439o.mysql.rds.aliyuncs.com:3306/platform?zeroDateTimeBehavior=convertToNull"
                        userId="root"
                        password="MeiBangLai2018128">
        </jdbcConnection>
		//java类型解析器
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>
		//实体类生成解析器
        <javaModelGenerator targetPackage="com.mbl.entities" targetProject=".\src">
            <property name="enableSubPackages" value="true"/>
            <property name="trimStrings" value="true"/>
        </javaModelGenerator>
		//mapper.xml生成解析器
        <sqlMapGenerator targetPackage="com.mbl.dao" targetProject=".\resource">
            <property name="enableSubPackages" value="true"/>
        </sqlMapGenerator>
		//dao中的mapper接口生成解析器
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.mbl.dao" targetProject=".\src">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>
		//要生成的数据库表
        <table schema="DB2ADMIN" tableName="orders" domainObjectName="Order">
            <property name="useActualColumnNames" value="true"/>
            <generatedKey column="order_id" sqlStatement="DB2" identity="true"/>
            <columnOverride column="DATE_FIELD" property="startDate"/>
            <ignoreColumn column="FRED"/>
            <columnOverride column="LONG_VARCHAR_FIELD" jdbcType="VARCHAR"/>
        </table>

    </context>
</generatorConfiguration>
```



### 7.2 逆向工程测试运行

```java
public static void main(String[] args) throws  Exception {
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        File configFile = new File("generatorConfig.xml");
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = cp.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        myBatisGenerator.generate(null);
    }
```



## 八. Mybatis运行原理

![1534834257326](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534834257326.png)



![1534900243576](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534900243576.png)



![1534900477880](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534900477880.png)



![1534901110310](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534901110310.png)

 Executor 执行器

ParameterHandler 参数处理器

ResultSetHandler	    结果处理器

StatementHandler   sql语句处理器



### 8.1 创建SqlSessionFactory的原理

```java
	//1.根据全局配置文件获取SqlSessionFactory对象
	String resource = "spring-mybatis.xml";
	InputStream inputStream = Resources.getResourceAsStream(resource);
	SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
```

#### 8.1.1 获取全局配置文件的流

```java
String resource = "spring-mybatis.xml";
InputStream inputStream = Resources.getResourceAsStream(resource);
```



#### 8.1.2 使用SqlSessionFactoryBuilder().build(inputStream);读取流文件

```java
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
```

##### 8.1.2.1 进入sqlsessionFactoryBuilder()的构造方法

![1534901899676](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534905946035.png)



##### 8.1.2.2 进入sqlSessionFactoryBuilder()的build()方法

![1534906040251](E:\1.JAVA学习笔记\MyBatis学习笔记.assets\1534906040251.png)



