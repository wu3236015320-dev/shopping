# 购物商城系统

基于 JFinal 框架的 Java Web 电商项目，包含完整的商品管理、订单系统、用户体系和推荐商品轮盘功能。

## 项目架构

```
shopping-master/
├── src/                          # Java 源代码
│   └── com/hjp/shop/
│       ├── controller/           # 控制器层 (MVC-C)
│       │   ├── RecommendController.java      # 推荐商品查询
│       │   ├── AdminRecommendController.java # 推荐管理接口
│       │   ├── ProductController.java        # 商品增删改查
│       │   ├── OrderController.java          # 订单管理
│       │   └── AdminController.java          # 后台管理
│       ├── model/                # 模型层 (MVC-M)
│       │   ├── Product.java
│       │   ├── Category.java
│       │   ├── Salesorder.java
│       │   └── RecommendSetting.java
│       ├── Interceptor/          # 拦截器
│       │   └── AdminInterceptor.java         # 管理员权限验证
│       └── config/               # 配置
│           └── ShopConfig.java     # 路由与插件配置
├── WebRoot/                      # Web 前端资源
│   ├── admin/                    # 管理后台页面
│   ├── common/                   # 公共模板
│   │   ├── admin_head.html       # 后台布局模板
│   │   └── head.html             # 前台布局模板
│   └── js/
│       └── carousel.js           # 轮盘状态机实现
└── db/
    └── shopping.sql              # 数据库初始化脚本
```

## 技术栈

- **后端框架**: JFinal 1.3 (轻量级 Java Web 框架)
- **模板引擎**: FreeMarker
- **数据库**: MySQL + C3P0 连接池
- **前端**: 原生 HTML/CSS/JavaScript + jQuery
- **构建**: 原生 Java Compiler (无 Maven/Gradle)

## 核心功能模块

### 1. 推荐商品轮盘系统

#### 数据层设计

**独立推荐配置表** (`tbl_recommend_setting`)：
```sql
CREATE TABLE tbl_recommend_setting (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,          -- 关联商品ID
  sort_order INT DEFAULT 0,           -- 轮播排序
  is_active TINYINT(1) DEFAULT 1,   -- 是否启用
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES tbl_product(id)
);
```

设计考量：
- 与商品表分离，支持排序调整和软删除
- 新环境自动初始化10个商品（容错机制）

#### 业务层逻辑

**查询流程** (`RecommendController.index()`)：
```java
// 1. 查询已配置的推荐商品
List<Product> recommendProducts = getRecommendProducts();

// 2. 如果推荐表为空，自动随机初始化10个商品
if (recommendProducts.isEmpty()) {
    initRecommendProducts(10);
    recommendProducts = getRecommendProducts();
}

// 3. JOIN查询获取完整商品信息
String sql = "SELECT p.* FROM tbl_product p " +
             "INNER JOIN tbl_recommend_setting r ON p.id = r.product_id " +
             "WHERE r.is_active = 1 ORDER BY r.sort_order ASC";
return Product.dao.find(sql);
```

**管理接口** (`AdminRecommendController`)：
- `add()` - 添加商品到推荐列表
- `remove()` - 从推荐列表移除
- `updateSort()` - 调整展示顺序
- `adjustCount()` - 批量调整推荐数量

#### 前端状态机实现

**核心函数调用链** (`carousel.js`)：
```javascript
// 初始化
initCarousel() → 获取所有 slide → currentIndex = 0 → updateCarousel()

// 用户交互
eventListener('click'|'swipe') → goToSlide(index) → updateCarousel() → CSS动画

// 自动轮播
setInterval(goToNext, 5000) → updateCarousel()
```

**状态分配逻辑** (`updateCarousel()`)：
```javascript
slides.forEach((slide, index) => {
    // 计算相对当前索引的位置
    let diff = index - currentIndex;
    
    // 循环边界处理
    if (diff > total/2) diff -= total;
    if (diff < -total/2) diff += total;
    
    // 分配 CSS 状态类
    if (diff === 0)  slide.classList.add('active');  // 中间聚焦
    else if (diff === -1) slide.classList.add('prev');  // 左侧预览
    else if (diff === 1) slide.classList.add('next');   // 右侧预览
    else slide.classList.add('hidden');                  // 隐藏
});
```

**CSS 状态定义**：
```css
.carousel-slide.active {
    transform: translateX(0) scale(1.2);
    filter: none;
    z-index: 10;
}
.carousel-slide.prev {
    transform: translateX(-320px) scale(0.75);
    filter: blur(2px);
    opacity: 0.5;
}
.carousel-slide.next {
    transform: translateX(320px) scale(0.75);
    filter: blur(2px);
    opacity: 0.5;
}
```

### 2. 商品管理系统

**添加商品时同步上传图片** (`ProductController.add()`)：
```java
// 1. 保存商品信息到数据库
Product p = new Product();
p.set("name", name)
 .set("normalprice", normalprice)
 .set("memberprice", memberprice)
 .set("categoryid", categoryId)
 .set("pdate", new Date());

if (p.save()) {
    int newProductId = p.getInt("id");
    
    // 2. 处理图片上传，重命名为 {商品ID}.jpg
    UploadFile upfile = getFile("productImage", 
        PathKit.getWebRootPath() + "/img/product", 
        10 * 1024 * 1024, "utf-8");
    
    if (upfile != null) {
        upfile.getFile().renameTo(
            new File(path + "/" + newProductId + ".jpg")
        );
    }
}
```

### 3. 后台管理重构

**独立模板设计**：
- `admin_head.html` - 去除前台导航，只保留管理菜单
- `admin/tail.html` - 简化页脚
- 左侧菜单：商品/订单/用户/报表/推荐 五大模块

**分类管理合并**：
- 商品管理页面内嵌分类管理面板
- 点击展开，无需页面跳转
- 减少用户操作路径

## 快速开始

### 环境要求
- JDK 8+
- MySQL 5.7+

### 一键启动
```bash
双击运行：一键启动.bat
```

自动完成：
1. 检查并启动 MySQL 服务
2. 编译项目（如果需要）
3. 启动 Web 服务器
4. 打开浏览器访问 http://127.0.0.1:8090

### 管理员登录
- 地址：http://127.0.0.1:8090/user/login
- 账号：admin
- 密码：admin

### 数据库迁移

**导出当前数据**（换电脑使用）：
```bash
db\导出数据库-用于迁移.bat
# 生成 shopping-export.sql，包含完整表结构和数据
```

**新电脑导入**：
```bash
mysql -u root -p shopping < shopping-export.sql
```

## 系统架构特点

### 三层解耦设计

```
数据层 (SQL表) 
    ↓ JOIN查询
业务层 (Controller)
    ↓ setAttr
表现层 (FreeMarker + JS)
    ↓ CSS状态机
用户界面
```

优势：
- 修改动画效果只需改 CSS，不动 Java 代码
- 调整业务逻辑只需改 Controller，不动 SQL
- 表结构变更只需改 Model，不动前端

### 状态机驱动的前端

轮盘交互不是简单的 DOM 操作，而是：
1. 维护单一状态源 (`currentIndex`)
2. 计算相对位置，分配状态类
3. CSS 接管所有过渡动画

实现丝滑的 0.5s 缓动过渡，支持鼠标、触摸、键盘、定时器四种交互方式。

### 容错机制

- 推荐表为空时自动随机初始化
- 图片上传失败不影响商品保存
- 页面不可见时自动暂停轮播节省资源

## 脚本文件说明

6 个 bat 脚本按使用频率排序，编号越小越常用：

| 脚本文件 | 功能 | 使用场景 |
|---------|------|---------|
| `1-启动系统.bat` | 一键启动：检查 MySQL → 编译项目 → 启动网站 → 打开浏览器 | **最常用**，每天开机后双击运行 |
| `2-编译项目.bat` | 编译 Java 源代码到 bin 目录 | 修改了 Java 代码后，需要重新编译 |
| `3-重置数据库.bat` | 清空数据库，重置为初始 70 条商品数据 | 新电脑首次部署，或想清空重来 |
| `4-导出完整数据.bat` | 导出完整数据库（表结构 + 所有数据）| 换电脑部署、完整备份 |
| `5-导出仅数据.bat` | 仅导出数据（INSERT 语句，不含表结构）| 表结构已存在，只想迁移业务数据 |
| `6-诊断故障.bat` | 自动检测 503 错误原因 | 网站打不开，排查 MySQL/端口问题 |

### 日常使用流程

```
第1步：双击 "1-启动系统.bat"
       ↓ 等待 10 秒
第2步：浏览器自动打开 http://127.0.0.1:8090
       ↓ 开始使用
第3步：关机时直接关闭浏览器和 bat 窗口即可
```

### 换电脑部署流程

**旧电脑**：
1. 双击 `4-导出完整数据.bat`
2. 复制生成的 `db/shopping-export.sql` 到新电脑

**新电脑**：
1. 安装 JDK + MySQL
2. 导入数据：`mysql -u root -p shopping < shopping-export.sql`
3. 双击 `1-启动系统.bat`

## 文档

- [部署说明.md](部署说明.md) - 部署说明


## License

MIT License
