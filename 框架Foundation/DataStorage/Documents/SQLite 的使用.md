# 1. 术语

在学习 SQLite 之前，先了解几个与此相关的术语。

## 1.1 数据库

数据库（database）是有组织的数据集合，通常在计算机系统中以电子的形式存储、查询。

## 1.2 数据库管理系统

数据库管理系统（database management system，简称 DBMS）是与数据库交互的软件。数据库、DBMS 和关联的应用程序总和称为数据库系统。通常，数据库还用于宽泛的指代任何 DBMS、数据库系统，或与数据库关联的应用程序。

## 1.3 关系数据库管理系统

每个 DBMS 都有一个基础模型，该模型决定数据库的结构和恢复数据的方式。关系数据库管理系统是创建在关系模型基础上的数据库，借助集合代数等数学概念和方法来处理数据库中的数据。

关系模型由**关系数据结构**、关系操作集合、**关系完整性约束**三部分组成。

> RDBMS 以**表**的形式存储数据，DBMS 以**文件**的形式存储数据。
>
> DBMS 也可能使用表，但表之间没有关系。其数据通常以分层形式或导航形式存储。这意味着单个数据单元将具有一个父节点，零个、一个或多个子节点。
>
> 在 RDBMS 中，表具有称为**主键**（primary key）的标识符，数据以 **table** 的形式存储，这些数值之间的关系也将以 table 的形式存储。数值可以由系统更新，数据在物理和逻辑上是相互独立的。

常见 RDBMS 有 MySQL、PostgreSQL、SQL Server Express、SQLite 等。

## 1.4 SQL

SQL 全称是 structured query language，指**结构化查询语言**。也就是 SQL 是用于访问和处理数据库的标准化的计算机语言。

虽然 SQL 是一门 ANSI 标准的计算机语言，但仍然存在着多种不同版本的 SQL 语言。为了与 ANSI 标准相兼容，它们必须以相似的方式共同支持一些主要的命令。例如，`SELECT`、`UPDATE`、`DELETE`、`INSERT`、`WHERE` 等。

# 2. SQLite 简介

SQLite 是一个基于 C 语言的库，它实现了一个小型、快速、自足、高可靠性、全功能的 SQL 数据库引擎。SQLite 是世界上使用最多的数据库引擎。SQLite 内置于所有手机和大多数计算机中，并与人们日常使用的无数其他应用程序捆绑在一起。

SQLite 文件格式是稳定的、跨平台的、向后兼容的，开发者承诺在 2050 年之前保持这种状态。SQLite 数据库文件通常被用作系统之间传输丰富内容的容器[1] [2] [3]，并作为数据的长期存档格式[4]。目前有超过1万亿（1e12）个 SQLite 数据库在积极使用[5]。

SQLite 源代码属于公有领域，每个人都可以免费使用，并用于任何目的。

---

SQLite 是遵守 ACID 的关系型数据库管理系统（Relational database management system，简称 RDBMS），包含在 C 库中。**与其他数据库相比，SQLite 不是客户端、服务端数据库引擎，而是将其嵌入到客户端中**。

另外，SQLite 具有以下特点：

* 无需单独的服务器进程，或操作的系统（无服务器的）。
* 无需配置，也就是无需安装、管理。
* 一个完整的 SQLite 数据库是存储在一个单一的跨平台的磁盘文件。
* 文件小。完全配置时小于 400kb，省略可选功能时小于 250kb。
* 自给自足，无需任何外部依赖。
* 完全兼容 ACID，允许从多个进程、线程安全访问。
* 支持 SQL92 标准的大多数查询语言。
* 可在 UNIX（Linux、macOS、iOS、Android）和 Windows 中运行。
* 许可协议为公有领域（public domain）。

与其它 RDBMS 相比，SQLite 具有以下缺点：

* 没有用户管理和安全功能。
* 无法轻松扩展。
* 当数据量变大时，占用内存随之增多，且不易优化。
* 无法自定义。

SQLite 是嵌入式数据库软件的首选，是部署最广泛的数据库引擎之一，被主流浏览器、操作系统、移动设备所使用。

> ACID 是指 DBMS 在写入、更新资料过程中，为保证事务（transaction）是正确可靠的，所必须具备的四个特性：
>
> * **原子性** Atomicity：一个事务中的所有操作，或者全部完成，或者全部不完成，不会结束在中间某个环节。事务在执行过程中发生错误，会被回滚（rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。即，事务不可分割、不可约简。
> * **一致性** Consistency：在事务开始之前和结束之后，数据库的完整性没有被破坏。即写入的资料完全符合预设约束、触发器、级联回滚等。
> * **隔离性** Isolation：数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时，由于交叉执行而导致数据的不一致。
> * **持久性** Durability：事务处理结束后，对数据的修改就是持久的，即便系统故障也不会丢失。
>
> 在数据库系统中，一个事务指：由一系列数据库操作组成的一个完整的逻辑过程。如银行转账，从原账户扣除金额、向目标账户添加金额，这两个数据库操作的总和构成一个完整的逻辑过程，不可拆分。这个过程被称为一个事务，具有 ACID 特性。

# 3. 安装 SQLite

在命令行输入 `sqlite3` 即可查看是否安装了 `SQLite`：

```sqlite
$ sqlite3
SQLite version 3.32.3 2020-06-18 14:16:19
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite>
```

Linux 和 macOS 预装了 SQLite。如果你的操作系统没有预装 SQLite，访问 [SQLite 下载页面](https://www.sqlite.org/download.html) 根据提示安装即可。

# 4. 点命令

这一部分介绍 SQLite 的点命令，其不以分号结束。

输入`.help` 可获取点命令清单。如下所示：

```sqlite
sqlite> .help
.auth ON|OFF             Show authorizer callbacks
.backup ?DB? FILE        Backup DB (default "main") to FILE
.bail on|off             Stop after hitting an error.  Default OFF
.binary on|off           Turn binary output on or off.  Default OFF
...
```

可以使用下面点命令自定义输出格式：

```sqlite
sqlite> .header on    # 打开页眉显示
sqlite> .mode column  # 设置输出模式
sqlite> .timer on     # 打开 SQL 计时器
```

上面设置将产生如下格式的输出：

```sqlite
ID          NAME        AGE         ADDRESS     SALARY    
----------  ----------  ----------  ----------  ----------
1           Paul        32          California  20000.0   
2           Allen       25          Texas       15000.0   
3           Teddy       23          Norway      20000.0   
4           Mark        25          Rich-Mond   65000.0   
5           David       27          Texas       85000.0   
6           Kim         22          South-Hall  45000.0   
7           James       24          Houston     10000.0   
Run Time: real 0.001 user 0.000113 sys 0.000087
```

# 5. 数据类型

SQLite 使用一个更普遍的动态类型系统，值的数据类型与值本身是相关的，与其容器无关。

## 5.1 存储类

每个存储在 SQLite 数据库中的值都具有以下存储类之一：

| 存储类  | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| NULL    | 值是一个 NULL 值。                                           |
| INTEGER | 值是一个带符号的整数。根据值大小存储在 1、2、3、4、6 或 8 个字节中。 |
| REAL    | 值是一个浮点值。存储为 8 个字节的 IEEE 浮点数字。            |
| TEXT    | 值是一个文本字符串，使用数据库编码（UTF-8、UTF-16BE 或 UTF-16LE）存储。 |
| BLOB    | 完全根据输入存储。                                           |

存储类比数据类稍微普遍些。例如，INTEGER 存储类包含六种不同长度的整数数据类型。

## 5.2 亲和类型 Affinity

SQLite 支持亲和类型概念，列内**可以存储任何类型的数据**。当数据插入时，该字段的数据将会优先采用亲和类型作为该值的存储方式。目前支持以下五种亲和类型：

| 亲和类型 | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| TEXT     | 数值型数据在被插入之前，需要先被转换为文本格式再插入到目标字段中。 |
| NUMERIC  | 当文本数据被插入到亲缘性为 NUMERIC 的字段中时，如果转换操作不会导致信息丢失以及完全可逆，会将文本数据转换为 INTEGER 或 REAL 类型数据，如果转换失败，仍会以 TEXT 方式存储该数据； NULL 和 BLOB 类型数据，不做任何转换，直接存储； 浮点格式的常量文本，如 `3000.0`。如果该值可以转换为 INTEGER，同时又不丢失数值信息，则会转为 INTEGER 存储。 |
| INTEGER  | 规则与 NUMERIC 相同，唯一差别在执行 CAST 表达式。            |
| REAL     | 规则基本等同于 NUMERIC。唯一差别是不会将 `3000.0` 这样的文本数据转换为 INTEGER 存储。 |
| NONE     | 不做任何转换，直接以该数据所属的数据类型进行存储。           |

## 5.3 数据类型与亲和类型对照

下面列出了数据类型和亲和类型的对应关系：

| 亲和类型 | 数据类型                                                     |
| -------- | ------------------------------------------------------------ |
| INTEGER  | INT、INTEGER、TINYINT、SMALLINT、MEDIUMINT、BEGINT、UNSIGNED BIG INT、INT2、INT8 |
| TEXT     | CHARACTER(20)、VARCHAR(255)、VARYING CHARACTER(255)、NCHAR(55)、NATIVE CHARACTER(70)、NVARCHAR(100)、TEXT、CLOB |
| NONE     | BLOB、no datatype specified                                  |
| REAL     | REAL、DOUBLE、DOUBLE PRECISION、FLOAT                        |
| NUMERIC  | NUMERIC、DECIMAL(10.5)、BOOLEAN、DATEDATETIME                |

> SQLite 没有单独 Boolean 存储类。布尔值被存储为整数 0 和 1。也没有日期、时间存储类，将日期、时间存储为 TEXT、REAL 或 INTEGER 值。

# 6. 创建数据库

## 6.1 语法

使用 `sqlite3` 命令创建数据库，语法如下：

```bash
$ sqlite3 DatabaseName.db
```

## 6.2 示例

如果想创建名称为 `LearnDB.db` 的数据库，命令如下：

```bash
$ sqlite3 LearnDB.db
SQLite version 3.32.3 2020-06-18 14:16:19
Enter ".help" for usage hints.
```

> 数据库名称应唯一。

与其他数据库管理系统不同，SQLite 不支持 `DROP DATABASE` 语句。如果想要删除数据库，直接删除文件即可。

# 7. 表

## 7.1 创建表

`CREATE TABLE` 语句用于创建表。创建时指定表名称，定义列以及每列数据类型。

### 7.1.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll0a0yl32g30k707rjrk.gif)

`CREATE TABLE` 语法如下：

```sqlite
CREATE TABLE table_name(
				column1 datatype PRIMARY KEY,
				column2 datatype,
				column3 datatype,
				...
				columnN datatype,
);
```

### 7.1.2 示例

下面创建了一个 COMPANY 表，ID 作为主键，`NOT NULL` 约束标记字段不能为 NULL：

```sqlite
sqlite> CREATE TABLE COMPANY(
   ...> ID INT PRIMARY KEY NOT NULL,
   ...> NAME TEXT NOT NULL,
   ...> AGE INT NOT NULL,
   ...> ADDRESS CHAR(50),
   ...> SALARY REAL
   ...> );
```

再创建一个 CLASS 表，以便后续部分使用：

```sqlite
sqlite> CREATE TABLE CLASS(
   ...> ID INT PRIMARY KEY NOT NULL,
   ...> NAME TEXT NOT NULL,
   ...> CLASS_ID INT NOT NULL
   ...> );
```

`.tables` 命令可以列出数据库中的所有表：

```sqlite
sqlite> .table
CLASS    COMPANY
```

`.schema` 命令可以查看表的完整信息：

```sqlite
sqlite> .schema
CREATE TABLE COMPANY(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
AGE INT NOT NULL,
ADDRESS CHAR(50),
SALARY REAL
);
CREATE TABLE CLASS(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
CLASS_ID INT NOT NULL
);
```



## 7.2 删除表

`DROP TABLE` 语句删除使用 `CREATE TABLE` 语句创建的表，删除的表会彻底从数据库、文件中移除，不可恢复。表关联的索引、触发器、约束会被同步删除。

### 7.2.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll0kplyefg30j4018mx4.gif)

`DROP TABLE` 语句语法如下：

```
DROP TABLE IF EXISTS table-name
```

可选的 `IF EXISTS` 子句可抑制表不存在导致的错误。

### 7.2.2 示例

先确认 CLASS 表存在，再将其删除：

```sqlite
sqlite> .table
CLASS    COMPANY

sqlite> DROP TABLE IF EXISTS CLASS;

sqlite> .table
COMPANY
```

# 8. 插入 INSERT

`INSERT INTO` 语句用于向表中添加新的行。

## 8.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll0n3t16eg30n00e0q3d.gif)

`INSERT INTO` 语句有两种语法，如下所示：

```sqlite
// 第一种
INSERT INTO TABLE_NAME [(column1, column2, column3, ... columnN)]
VALUES (value1, value2, value3, ... valueN);

// 第二种
INSERT INTO TABLE_NAME VALUES (value1, value2, value3, ... valueN);
```

`column1`、`column2` 是要插入数据列的名称。如果要为所有列添加值，可以使用第二种方式，但值顺序必须与列在表中的顺序一致。

## 8.2 示例

LearnDB.sql 数据库中已经有了 COMPANY 表，如下所示：

```sqlite
sqlite> .schema
CREATE TABLE COMPANY(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
AGE INT NOT NULL,
ADDRESS CHAR(50),
SALARY REAL
);
```

使用以下语句在表中创建七条记录：

```sqlite
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(1, 'Paul', 32, 'Californai', 20000.00);
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(2, 'Allen', 25, 'Texas', 15000.00);
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(3, 'Teddy', 32, 'Norway', 20000.00);
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(4, 'Mark', 25, 'Rich-mond', 65000.00);
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(5, 'David', 27, 'Texas', 85000.00);
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES(6, 'Kim', 22, 'South-hall', 45000.00);
sqlite> INSEART INTO COMPANY VALUES (7, 'James', 24, 'Houston', 10000.00);
```

目前表记录如下：

```sqlite
sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          South-hall  45000.0
Run Time: real 0.000 user 0.000101 sys 0.000064
```

## 8.3 使用一个表来填充另一个表

还可以通过在有一组字段的表上使用 `select` 语句，填充数据到另一个表中。如下所示：

```sqlite
sqlite> INSERT INTO target_table_name [(column1, column2, ... columnN)]
   ...> SELECT column1, column2, ... columnN
   ...> FROM source_table_name
   ...> [WHERE condition];
```

# 9. 查询 SELECT

`SELECT` 语句用于从数据库中获取数据，以表的形式返回数据。

## 9.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll13rfqn6g30hb0ohjrz.gif)

`SELECT` 语句基本语法如下：

```sqlite
SELECT column1, column2, columnN FROM table_name;
```

`column1`、`column2`... 是表的字段，即想要获取的值。如果想要获取所有字段，使用下面语句：

```sqlite
SELECT * FROM table_name;
```

## 9.2 示例

使用 `SELECT` 语句获取 COMPANY 表所有记录：

```sqlite
sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          South-hall  45000.0
Run Time: real 0.000 user 0.000101 sys 0.000064
```

如果只想获取指定字段，使用以下语句：

```sqlite
sqlite> SELECT ID, NAME, ADDRESS FROM COMPANY;
ID          NAME        ADDRESS
----------  ----------  ----------
1           Paul        Californai
2           Allen       Texas
3           Teddy       Norway
4           Mark        Rich-mond
5           David       Texas
6           Kim         South-hall
Run Time: real 0.000 user 0.000092 sys 0.000074
```

## 9.3 Schema 信息

点命令只能在 SQLite 提示符中使用，编程时如需列出数据库中所有的表，使用以下语句：

```sqlite
sqlite> SELECT tbl_name FROM sqlite_master WHERE type = 'table';
tbl_name  
----------
COMPANY   
Run Time: real 0.001 user 0.000101 sys 0.000142
```

如需获取 COMPANY 完整信息，使用以下语句：

```sqlite
sqlite> SELECT sql FROM sqlite_master WHERE type = 'table' AND tbl_name = 'COMPANY';
sql
------------------------------------------------------------------------------------
CREATE TABLE COMPANY(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
AGE INT NOT NULL,
ADDRESS CHAR(50),
SALARY REAL
)
Run Time: real 0.000 user 0.000087 sys 0.000082
```

# 10. 运算符

运算符是一个保留字、字符，主要用于 `WHERE` 子句中执行操作。

## 10.1 算数运算符

支持的算数运算符有 +、-、*、/、% 五种。

## 10.2 比较运算符

比较运算符支持以下类型：

* `==` 检查操作数值是否相等。如果相等则条件为真。
* `=` 与 `==` 一样。
* `!=` 检查操作数值是否相等。如果不相等则条件为真。
* <> 与 `!=` 一样。
* 此外，还支持 `>`、`<`、`>=`、`<=`、`!<`、`!>`。

## 10.3 逻辑运算符

逻辑运算符支持以下类型：

* AND：允许 WHERE 子句存在多个条件，均成立时，子句为真。
* BETWEEN：指定值范围。
* EXISTS：用于在满足一定条件的指定表中搜索行是否存在。
* IN：用于把指定值与一系列值进行比较。
* NOT IN：IN 的对立面。
* LIKE：将指定值与使用通配符的值进行比较。
* GLOB：与 LIKE 类似，但 GLOB 区分大小写。
* NOT：否定运算符，
* OR：允许 WHERE 子句存在多个条件，有一个成立即为真。
* IS NULL：与 NULL 比较。
* IS：与 = 相似。
* IS NOT：与！= 相似。
* || ：连接两个不同的字符串，得到一个新的字符串。
* UNIQUE：搜索表中的每一行，确保无重复。

# 11. WHERE

`WHERE` 指定获取数据的条件。表中每一行均会与 `WHERE` 表达式匹配，只有表达式为真时，才返回指定值。

## 11.1 语法

带有 `WHERE` 子句的 `SELECT` 语句的基本语法如下：

```sqlite
SELECT column1, column2, columnN
FROM table_name
WHERE [condition]
```

## 11.2 示例

下面的 SELECT 语句列出了 COMPANY 表 AGE 大于等于 25 且工资大于等于 65000.00 的所有记录：

```sqlite
sqlite> SELECT * FROM COMPANY WHERE AGE >= 25 AND SALARY >= 65000.00;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
Run Time: real 0.000 user 0.000101 sys 0.000062
```

下面 SELECT 语句列出了 COMPANY 表 NAME 以 'Ki' 开始的所有记录，‘Ki’之后字符不做限制：

```sqlite
sqlite> SELECT * FROM COMPANY WHERE NAME LIKE 'KI%';
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
6           Kim         22          South-hall  45000.0
Run Time: real 0.000 user 0.000104 sys 0.000064
```

下面的 SELECT 语句，子查询查找 SALARY > 65000 的带有 AGE 字段的所有记录，后边的 WHERE 子句与 EXISTS 运算符一起使用，列出了外查询中的 AGE 存在于子查询返回的结果中的所有记录：

```sqlite
sqlite> SELECT AGE FROM COMPANY
   ...> WHERE EXISTS (SELECT AGE FROM COMPANY WHERE SALARY > 65000.00);
AGE
----------
32
25
32
25
27
22
Run Time: real 0.000 user 0.000099 sys 0.000069
```

> WHERE 子句不仅可以用在 SELECT 语句中，还可以用在 UPDATE、DELETE 语句中。

# 12. 更新 UPDATE

`UPDATE` 语句用于修改表中的零行、多行的值。

## 12.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll1lccy9eg30j408dmxc.gif)

`UPDATE` 语句基本语法如下：

```sqlite
UPDATE table_name
SET column1 = value1, column2 = value2 ..., columnN = valueN
WHERE [condition];
```

`WHERE` 子句可以组合使用运算符。如果没有 `WHERE` 子句，则修改所有行的值；反之，只修改 `WHERE` 子句为真的行。

`SET` 关键字后赋值语句决定修改哪些字段。每个赋值语句左侧指定要修改的字段，右侧指定值。如果单个字段名称出现多次，则只采取最后一次设置的值，并忽略前面所有赋值。未出现字段名称的行，值保持不变。`WHERE` 表达式可能引用要更新的行，此时会先评估所有表达式，再进行赋值。

## 12.2 示例

下面语句会更新 ID 为 6 的客户地址：

```sqlite
sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          South-hall  45000.0
Run Time: real 0.000 user 0.000104 sys 0.000080

sqlite> UPDATE COMPANY SET ADDRESS = 'Texas' WHERE ID = 6;
Run Time: real 0.002 user 0.000127 sys 0.001223

sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.000 user 0.000104 sys 0.000095
```

可以看到地址信息更新前为”South-hall“，更新后为 “Texas”。

# 13. 删除 DELETE

DELETE 语句用于删除表中已有记录。

## 13.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll1pcrr1tg30f203l749.gif)

```sqlite
DELETE FROM table_name
WHERE [condition];
```

如果没有 WHERE 子句，则删除所有记录；如果提供了 WHERE 子句，则仅删除子句表达式为 true 的行，表达式为 false 或 NULL 的行会被保留。

### 13.2 示例

下面语句会删除 ID 为 7 的客户：

```sqlite
sqlite> DELETE FROM COMPANY WHERE ID = 7;
Run Time: real 0.000 user 0.000062 sys 0.000060

sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.001 user 0.000101 sys 0.000073
```

# 14. LIKE

LIKE 运算符用来匹配包含通配符的文本。如果搜索表达式与模式表达式匹配，返回 true；反之，返回 false。

有以下两个通配符与 LIKE 运算符一起使用：

* 百分号 %：代表零个、一个或多个字符。
* 下划线 _ ：代表一个单一的字符。

通配符可以组合使用。

## 14.1 语法

% 和 _ 的基本语法如下：

```sqlite
SELECT column_list
FROM table_name
WHERE column LIKE '_XXX%'
```

## 14.2 示例

下面的语句查找表中 AGE 以 2 开头的所有记录：

```sqlite
sqlite> SELECT * FROM COMPANY WHERE AGE LIKE '2%';
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
2           Allen       25          Texas       15000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.000 user 0.000115 sys 0.000091
```

下面语句查找第二位是 a，且以 l 结尾的记录：

```sqlite
sqlite> SELECT * FROM COMPANY WHERE NAME LIKE '_a%l';
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
Run Time: real 0.000 user 0.000075 sys 0.000061
```

> GLOB 子句与 LIKE 十分相似，但其大小写敏感。
>
> GLOB 通配符如下：
>
> * 星号 *：代表零个、一个或多个字符。
> * 问号？：代表一个单一的字符。

# 15. LIMIT

LIMIT 子句用于限制 SELECT 语句返回行数的上限。

## 15.1 语法

LIMIT 子句基本语法如下：

```sqlite
SELECT column1, column2, columnN
FROM table_name
LIMIT [number of rows]
```

LIMIT 子句可选设置 OFFSET，语法如下：

```sqlite
SELECT column1, column2, columnN
FROM table_name
LIMIT [n] OFFSET [m]
```

m 为整值，或可以计算出整值的表达式。如果使用了 OFFSET 子句，则查找结果的前 m 个会被忽略，m 个之后的 n 个结果被返回。如果 SELECT 子句查找到的结果少于 m + n，前 m 个会被忽略，返回剩余部分。如果 OFFSET 值为负，则与设置为 0 没有区别。

## 15.2 示例

下面 SELECT 语句从第三位开始，提取四个记录：

```sqlite
sqlite> SELECT * FROM COMPANY
   ...> ;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.001 user 0.000101 sys 0.000074

sqlite> SELECT * FROM COMPANY LIMIT 4 OFFSET 2;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.000 user 0.000104 sys 0.000077
```



# 16. ORDER BY

Order By 子句用来基于一个或多个列按升序或降序排列数据。

## 16.1 语法

ORDER BY 子句基本语法如下：

```sqlite
SELECT column-list
FROM  table_name
[WHERE condition]
[ORDER BY column1, column2, ... columnN] [ASC | DESC];
```

如果 SELECT 语句未使用 ORDER BY 子句，返回结果包含多条记录时，记录顺序将无法确定。如果未指定升序（ASC）、降序（DESC），则默认使用 ASC。

## 16.2 示例

下面语句将 SALARY 按照升序排列：

```sqlite
sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
Run Time: real 0.000 user 0.000105 sys 0.000076

sqlite> SELECT * FROM COMPANY ORDER BY SALARY ASC;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
2           Allen       25          Texas       15000.0
1           Paul        32          Californai  20000.0
3           Teddy       32          Norway      20000.0
6           Kim         22          Texas       45000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
Run Time: real 0.000 user 0.000122 sys 0.000075
```

> 如果记录的 ORDER BY 表达式相等，则其返回顺序是未知的。

# 17. GROUP BY

GROUP BY 子句与 SELECT 语句一起使用，来对相同的数据进行分组。

## 17.1 语法

GROUP BY 基本语法如下：

```sqlite
SELECT column-list
FROM table_name
WHERE [ conditions ]
GROUP BY column1, column2 ... columnN
ORDER BY column1, column2 ... columnN
```

GROUP BY 子句必须放在 WHERE 之后，ORDER BY 之前。

## 17.2 示例

如果想要获取每位员工工资总额，则可以使用 GROUP BY 查询：

```objc
sqlite> SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME;
NAME        SUM(SALARY)
----------  -----------
Allen       15000.0
David       85000.0
Kim         45000.0
Mark        65000.0
Paul        20000.0
Teddy       20000.0
```



# 18. HAVING

HAVING 子句指定条件来过滤分组结果。

WHERE 子句在所选列上设置条件，HAVING 子句在由 GROUP BY 子句创建的分组上设置条件。

## 18.1 语法

下面是 HAVING 子句在 SELECT 查询中的位置：

```sqlite
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
```

在 SELECT 语句中，HAVING 子句必须在 GROUP BY 子句之后，在 ORDER BY 子句之前。

## 18.2 示例

下面语句查询 address 计数小于 2 的所有记录：

```sqlite
sqlite> SELECT * FROM COMPANY GROUP BY address HAVING count(name) < 2;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
Run Time: real 0.000 user 0.000117 sys 0.000075
```

下面语句查询 address 计数大于 2 的所有记录：

```sqlite
sqlite> SELECT * FROM COMPANY GROUP BY address HAVING count(name) > 2;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
2           Allen       25          Texas       15000.0
Run Time: real 0.001 user 0.000123 sys 0.000077
```



# 19. DISTINCT

DISTINCT 关键字与 SELECT 语句一起使用，消除所有重复记录。

## 19.1 语法

用于消除重复记录的 DISTINCT 关键字基本语法如下：

```sqlite
SELECT DISTINCT column1, column2, ... columnN
FROM table_name
WHERE [condition]
```

没有使用 DISTINCT 时，默认使用 ALL 关键字。使用 DISTINCT 后，重复记录会被过滤。两个 NULL 值会被认为相等。如果有多个 column1、column2，则所有对应字段值都相等时，才会被过滤。

## 19.2 示例

COMPANY 表如下所示：

```sqlite
sqlite> SELECT * FROM COMPANY;
ID          NAME        AGE         ADDRESS     SALARY
----------  ----------  ----------  ----------  ----------
1           Paul        32          Californai  20000.0
2           Allen       25          Texas       15000.0
3           Teddy       32          Norway      20000.0
4           Mark        25          Rich-mond   65000.0
5           David       27          Texas       85000.0
6           Kim         22          Texas       45000.0
7           James       24          Houston     10000.0
8           James       24          Houston     10000.0
Run Time: real 0.000 user 0.000100 sys 0.000095
```

下面语句将查询所有地址：

```sqlite
sqlite> SELECT address FROM COMPANY;
ADDRESS
----------
Californai
Texas
Norway
Rich-mond
Texas
Texas
Houston
Houston
Run Time: real 0.000 user 0.000085 sys 0.000091
```

使用 DISTINCT 关键字查询：

```sqlite
sqlite> SELECT DISTINCT address FROM COMPANY;
ADDRESS
----------
Californai
Texas
Norway
Rich-mond
Houston
Run Time: real 0.001 user 0.000089 sys 0.000077
```

同时对比 NAME、AGE、ADDRESS，语句如下：

```sqlite
sqlite> SELECT DISTINCT name, age, address FROM COMPANY;
NAME        AGE         ADDRESS
----------  ----------  ----------
Paul        32          Californai
Allen       25          Texas
Teddy       32          Norway
Mark        25          Rich-mond
David       27          Texas
Kim         22          Texas
James       24          Houston
Run Time: real 0.001 user 0.000106 sys 0.000082
```

这次只过滤了第 8 条数据。

# 20. 触发器 TRIGGER

## 20.1 创建触发器 CREATE TRIGGER

CREATE TRIGGER 语句用于为数据库创建触发器。触发器是数据库级别的事件，在数据库触发相应操作时，会自动执行。

### 20.1.1 语法

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll3ou3gg5g30in0h63yx.gif)

TRIGGER 基本语法如下：

```sqlite
CREATE TRIGGER [IF NOT EXISTS] trigger_name
	[BEFORE | AFTER | INSTEAD OF] [INSERT | UPDATE | DELETE]
	ON table_name
	[WHEN condition]
BEGIN
	statements;
END;
```

BEFORE 和 AFTER 关键字决定在 INSERT、UPDATE、DELETE 执行前或后触发。BEFORE 和 AFTER 用于 table；INSTEAD OF 用于 view。

每个 trigger 均需指定触发的操作类型：DELETE、INSERT、UPDATE。SQLite 只支持 FOR EACH ROW 触发器，没有 FOR EACH STATEMENT 触发器。因此，可选指定 FOR EACH ROW。

WHEN 子句和 trigger 响应都可以使用 `NEW.column-name` 和 `OLD.column-name` 获取 INSERTE、DELETE、UPDATE 的元素，其中 column-name 是触发 trigger 的关联名称。OLD 和 NEW 只能在特定事件中使用：

* INSERT：可以使用 NEW。
* UPDATE：NEW 和 OLD 都可以使用。
* DELETE：可以使用 OLD。

如果提供了 WHEN 子句，则只在 WHEN 子句为 true 时触发；如果没有提供 WHEN 子句，则所有语句执行时均触发。

触发操作的业务逻辑放在 `BEGIN END`block 内。



### 20.1.2 示例

创建一个 AUDIT 的表，每当 COMPANY 表插入记录时，日志信息将插入 AUDIT 中：

```sqlite
sqlite> CREATE TABLE AUDIT(
   ...> EMP_ID INT NOT NULL,
   ...> ENTRY_DATE TEXT NOT NULL
   ...> );
Run Time: real 0.002 user 0.000206 sys 0.001090
```

这里 ID 是 AUDIT 记录的 ID，EMP_ID 是来自 COMPANY 的 ID，DATE 记录插入记录的时间戳。

在 COMPANY 表上创建一个触发器，当年龄大于 20 时，将日志插入 AUDIT。如下所示：

```sqlite
sqlite> CREATE TRIGGER audit_log
   ...> AFTER INSERT ON COMPANY
   ...> WHEN new.age > 20
   ...> BEGIN
   ...> INSERT INTO AUDIT (EMP_ID, ENTRY_DATE) VALUES (new.ID, datetime('now'));
   ...> END;
Run Time: real 0.002 user 0.000221 sys 0.000979
```

向 COMPANY 表插入以下记录：

```sqlite
sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES (9, 'Aray', 34, 'Bristol', 95000.00);
Run Time: real 0.002 user 0.000162 sys 0.001458

sqlite> INSERT INTO COMPANY (ID, NAME, AGE, ADDRESS, SALARY)
   ...> VALUES (10, 'Sansa', 15, 'Chesterton', 95000.00);
Run Time: real 0.001 user 0.000141 sys 0.001032
```

查询 AUDIT 表，如下所示：

```sql
sqlite> SELECT * FROM AUDIT;
EMP_ID      ENTRY_DATE
----------  -------------------
9           2020-12-12 07:30:28
Run Time: real 0.000 user 0.000072 sys 0.000075
```

可以看到只记录了年龄大于 20 的第九条 record。

## 20.2 列出触发器

可以从 sqlite_master 表中列出所有触发器，如下所示：

```sqlite
sqlite> select name from sqlite_master
   ...> where type = 'trigger';
name
----------
audit_log
Run Time: real 0.000 user 0.000080 sys 0.000073
```

如果想要列出特定表上触发器，则使用 AND 子句连接表名。如下所示：

```sqlite
sqlite> SELECT name FROM sqlite_master
   ...> WHERE type = 'trigger' AND tbl_name = 'COMPANY';
name
----------
audit_log
Run Time: real 0.000 user 0.000084 sys 0.000062
```

## 20.3 删除触发器

DROP TRIGGER 语句用于删除 CREATE TRIGGER 创建的触发器。删除之后，触发器将不存在于 sqlite_master、sqlite_temp_master 表，也不会再被触发。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll43a7khyg30jz018mx4.gif)

删除表时会自动删除表关联的触发器。

# 21. ALTER

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll4451gmxg30jn05cdfy.gif)

SQLite 只支持 ALTER TABLE 有限的几种功能。

* 重命名表 ALTER TABLE RENAME。
* 重命名表中的列 ALTER TABLE RENAME COLUMN。
* 为已经存在的表添加列 ALTER TABLE ADD COLUMN。

## 21.1 重命名表 ALTER TABLE RENAME

重命名表基本语法如下：

```sqlite
ALTER TABLE table-name RENAME TO new-table-name;
```

ALTER TABLE RENAME 语句用于修改表名称，不能用于 attached database 间移动表，只能用在同一数据库中重命名表。如果要重命名的表具有触发器或索引，重命名后触发器、索引仍保留在表中。

> 3.25.0 版本开始，trigger、view 中引用的表会同时被重命名。

下面的语句将 COMPANY 重命名为 OLD_COMPANY：

```sqlite
sqlite> ALTER TABLE COMPANY RENAME TO OLD_COMPANY;
Run Time: real 0.003 user 0.000618 sys 0.001001
sqlite> .tables
AUDIT        OLD_COMPANY
```

## 21.2 重命名表中的列 ALTER TABLE RENAME COLUMN

重命名表中列的基本语法如下：

```sqlite
ALTER TABLE table-name RENAME COLUMN column-name TO new-column-name;
```

RENAME COLUMN TO 语句将 table-name 表中的 column-name 列重命名为 new-column-name。这会同时改变表定义、索引、触发器、视图中的 column name。如果 column name 改变会在触发器中引起歧义，则会触发重命名失败。

下面语句将 NAME 重命名为 FIRSTNAME：

```sqlite
sqlite> ALTER TABLE OLD_COMPANY RENAME COLUMN NAME TO FIRSTNAME;
Run Time: real 0.006 user 0.000486 sys 0.001167
sqlite> SELECT * FROM OLD_COMPANY;
ID          FIRSTNAME   AGE         ADDRESS     SALARY    
----------  ----------  ----------  ----------  ----------
1           Paul        32          California  20000.0   
2           Allen       25          Texas       15000.0   
3           Teddy       23          Norway      20000.0   
4           Mark        25          Rich-Mond   65000.0   
5           David       27          Texas       85000.0   
6           Kim         22          Texas       45000.0   
7           James       24          Houston     10000.0   
8           James       24          Houston     10000.0   
9           Arya        34          Bristol     95000.0   
10          Sansa       15          Chesterton  95000.0   
11          Ps          31          Cali        20000.0   
Run Time: real 0.001 user 0.000109 sys 0.000107
```



## 21.3 为已经存在的表添加列 ALTER TABLE ADD COLUMN

ADD COLUMN 基本语法如下：

```sqlite
ALTER TABLE table-name ADD COLUMN column-def;
```

ADD COLUMN 语句用于向已经存在的表添加新的列，添加的列为最后一列。添加的列需满足 CREATE TABLE 列要求，另外还需遵守以下限制：

* column 不能包含 PRIMARY KEY、UNIQUE。
* column 默认值不能为 CURRENT_TIME、CURRENT_DATE、CURRENT_TIMESTAMP 和圆括号表达式。
* 如果指定了 NOT NULL 限制，则必须包含非 NULL 的默认值。

现在，为 OLD_COMPANY 表中添加一个新的列，如下所示：

```sqlite
sqlite> ALTER TABLE OLD_COMPANY ADD COLUMN SEX char(1);
Run Time: real 0.002 user 0.000273 sys 0.000814

sqlite> SELECT * FROM OLD_COMPANY;
ID          FIRSTNAME   AGE         ADDRESS     SALARY      SEX       
----------  ----------  ----------  ----------  ----------  ----------
1           Paul        32          California  20000.0               
2           Allen       25          Texas       15000.0               
3           Teddy       23          Norway      20000.0               
4           Mark        25          Rich-Mond   65000.0               
5           David       27          Texas       85000.0               
6           Kim         22          Texas       45000.0               
7           James       24          Houston     10000.0               
8           James       24          Houston     10000.0               
9           Arya        34          Bristol     95000.0               
10          Sansa       15          Chesterton  95000.0               
11          Ps          31          Cali        20000.0               
Run Time: real 0.001 user 0.000118 sys 0.000106
```

ALTER TABLE 语句通过修改 sqlite_master_table 中的 schema 的 SQL 文本，并不修改表内容。因此，ALTER TABLE 语句执行速度与表数据量无关，表有一百万行内容和一行内容执行速度一样。

# 22. VIEW

## 22.1 CREATE VIEW

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll499505yg30n605jjrh.gif)

CREATE VIEW 语句为预打包的 SELECT 语句分配名称，创建 view 后，可以在另一个 SELECT 语句的 FROM 子句中使用创建的 VIEW。

如果 CREATE 和 VIEW 中间使用了 TEMP 或 TEMPORARY 关键字，则 VIEW 只能用于创建它的 database connection，关闭 database connection 后会自动删除 VIEW。

SQLite 的 VIEW 是只读的，不能 DELETE、INSERT、UPDATE。

view-name 后的 column-name 决定 VIEW 的名称。如果忽略了 column-name，则会自动采用 SELECT 语句查询到的 name。推荐使用 column-name，如果要省略 column-name，需确保 SELECT 语句名称适合 VIEW 用途。此外，忽略 column-name 后自动采用 SELECT 语句名称并非公开接口，后续实现可能发生变化。

```sqlite
sqlite> CREATE VIEW IF NOT EXISTS COMPANY_VIEW (VID, VNAME, VAGE) AS
   ...> SELECT ID, FIRSTNAME, AGE
   ...> FROM OLD_COMPANY;
Run Time: real 0.004 user 0.000252 sys 0.001079

sqlite> SELECT * FROM COMPANY_VIEW;
VID         VNAME       VAGE      
----------  ----------  ----------
1           Paul        32        
2           Allen       25        
3           Teddy       23        
4           Mark        25        
5           David       27        
6           Kim         22        
7           James       24        
8           James       24        
9           Arya        34        
10          Sansa       15        
Run Time: real 0.000 user 0.000090 sys 0.000099
```



## 22.2 DROP VIEW

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gll4he2ndwg30is018jrc.gif)

DROP VIEW 语句用于移除 CREATE VIEW 语句创建的 VIEW。DROP VIEW 语句会从 database schema 移除 VIEW，但不会从底层的 table 移除任何数据。

如果找不到要移除的 VIEW，也没有使用 IF EXISTS，则会产生错误。

下面语句移除 COMPANY_VIEW：

```sqlite
sqlite> DROP VIEW IF EXISTS COMPANY_VIEW;
Run Time: real 0.002 user 0.000120 sys 0.000853
sqlite> .tables
AUDIT        OLD_COMPANY
```



# 参考

* [SQLite 官网](https://sqlite.org/index.html)
* [SQLite Tutorial](https://www.sqlitetutorial.net/)
* [SQLite Documentation](https://www.sqlite.org/docs.html)
* [SQLite 的使用一@pro648](https://github.com/pro648/tips/blob/master/sources/SQLite%E7%9A%84%E4%BD%BF%E7%94%A8%E4%B8%80.md)
* [SQLite 的使用二@pro648](https://github.com/pro648/tips/wiki/SQLite%E7%9A%84%E4%BD%BF%E7%94%A8%E4%BA%8C)
* [SQLite 的使用三@pro648](https://github.com/pro648/tips/wiki/SQLite%E7%9A%84%E4%BD%BF%E7%94%A8%E4%B8%89)
* [SQLite With Swift Tutorial: Getting Started @raywenderlich.com](https://www.raywenderlich.com/6620276-sqlite-with-swift-tutorial-getting-started)
* [SQLite 教程](https://www.runoob.com/sqlite/sqlite-tutorial.html)

