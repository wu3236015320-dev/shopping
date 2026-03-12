/*
 Navicat Premium Data Transfer
 ...
*/

-- 创建数据库（若不存在）并选用
CREATE DATABASE IF NOT EXISTS `shopping` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `shopping`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tbl_category
-- ----------------------------
DROP TABLE IF EXISTS `tbl_category`;
CREATE TABLE `tbl_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pid` int(11) NULL DEFAULT NULL,
  `isleaf` int(11) NULL DEFAULT NULL,
  `grade` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_category
-- ----------------------------
INSERT INTO `tbl_category` VALUES (1, '手机', '智能手机与配件', 0, 1, 1);
INSERT INTO `tbl_category` VALUES (2, '电脑', '笔记本与台式机', 0, 1, 1);
INSERT INTO `tbl_category` VALUES (3, '数码', '相机、耳机、平板', 0, 1, 1);
INSERT INTO `tbl_category` VALUES (4, '家电', '家用电器', 0, 1, 1);
INSERT INTO `tbl_category` VALUES (5, '服饰', '服装鞋帽', 0, 1, 1);

-- ----------------------------
-- Table structure for tbl_log
-- ----------------------------
DROP TABLE IF EXISTS `tbl_log`;
CREATE TABLE `tbl_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `controller` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `act` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `logdate` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_log
-- ----------------------------
INSERT INTO `tbl_log` VALUES (1, 'admin', '/admin', '/admin', '2019-05-09 11:17:09');
INSERT INTO `tbl_log` VALUES (2, 'admin', '/admin', '/admin', '2019-05-09 11:29:48');
INSERT INTO `tbl_log` VALUES (3, 'admin', '/admin', '/admin', '2019-05-09 11:29:52');
INSERT INTO `tbl_log` VALUES (4, 'admin', '/admin', '/admin/listUser', '2019-05-09 11:29:57');
INSERT INTO `tbl_log` VALUES (5, 'admin', '/admin', '/admin', '2019-05-09 11:30:46');
INSERT INTO `tbl_log` VALUES (6, 'admin', '/admin', '/admin/listUser', '2019-05-09 11:30:50');
INSERT INTO `tbl_log` VALUES (7, 'admin', '/admin', '/admin/addUser', '2019-05-09 11:31:05');
INSERT INTO `tbl_log` VALUES (8, 'admin', '/admin', '/admin/addUser', '2019-05-09 11:31:11');
INSERT INTO `tbl_log` VALUES (9, 'admin', '/admin', '/admin/listUser', '2019-05-09 11:31:19');
INSERT INTO `tbl_log` VALUES (10, 'admin', '/product', '/product/list', '2019-05-09 11:31:28');
INSERT INTO `tbl_log` VALUES (11, 'admin', '/product', '/product/add', '2019-05-09 11:31:36');
INSERT INTO `tbl_log` VALUES (12, 'admin', '/category', '/category/list', '2019-05-09 11:32:03');
INSERT INTO `tbl_log` VALUES (13, 'admin', '/category', '/category/ajax', '2019-05-09 11:32:04');
INSERT INTO `tbl_log` VALUES (14, 'admin', '/category', '/category/add', '2019-05-09 11:32:06');
INSERT INTO `tbl_log` VALUES (15, 'admin', '/category', '/category/add', '2019-05-09 11:32:16');
INSERT INTO `tbl_log` VALUES (16, 'admin', '/product', '/product/list', '2019-05-09 11:33:15');
INSERT INTO `tbl_log` VALUES (17, 'admin', '/product', '/product/add', '2019-05-09 11:33:16');
INSERT INTO `tbl_log` VALUES (18, 'admin', '/product', '/product/add', '2019-05-09 11:33:34');
INSERT INTO `tbl_log` VALUES (19, 'admin', '/', '/', '2019-05-09 11:34:24');
INSERT INTO `tbl_log` VALUES (20, 'admin', '/product', '/product/detail', '2019-05-09 11:34:36');

-- ----------------------------
-- Table structure for tbl_product
-- ----------------------------
DROP TABLE IF EXISTS `tbl_product`;
CREATE TABLE `tbl_product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `normalprice` double NULL DEFAULT NULL,
  `memberprice` double NULL DEFAULT NULL,
  `pdate` datetime(0) NULL DEFAULT NULL,
  `categoryid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_product
-- ----------------------------
INSERT INTO `tbl_product` VALUES (1, 'Iphone', '贵不贵', 10000, 900, '2019-05-09 11:33:34', 1);
INSERT INTO `tbl_product` VALUES (2, '华为 Mate 60 Pro', '旗舰影像 超感光主摄', 6999, 6499, '2024-01-15 10:00:00', 1);
INSERT INTO `tbl_product` VALUES (3, '小米14 Ultra', '徕卡光学 骁龙8 Gen3', 5999, 5499, '2024-02-20 09:30:00', 1);
INSERT INTO `tbl_product` VALUES (4, 'OPPO Find X7', '哈苏影像 天玑9300', 4999, 4599, '2024-03-01 14:00:00', 1);
INSERT INTO `tbl_product` VALUES (5, 'vivo X100 Pro', '蔡司APO长焦 蓝晶×天玑9300', 5499, 4999, '2024-03-10 11:00:00', 1);
INSERT INTO `tbl_product` VALUES (6, '红米K70', '2K直屏 骁龙8 Gen2', 2499, 2199, '2024-01-08 10:00:00', 1);
INSERT INTO `tbl_product` VALUES (7, '真我GT5 Pro', '骁龙8 Gen3 150W闪充', 3298, 2998, '2024-02-15 16:00:00', 1);
INSERT INTO `tbl_product` VALUES (8, '一加12', '2K东方屏 100W闪充', 4299, 3999, '2024-01-20 09:00:00', 1);
INSERT INTO `tbl_product` VALUES (9, '联想拯救者Y9000P', 'i9-14900HX RTX4060 16G', 9999, 8999, '2024-02-01 10:00:00', 2);
INSERT INTO `tbl_product` VALUES (10, '华硕天选5 Pro', 'R9-8945HS RTX4070 2.5K屏', 8499, 7799, '2024-03-05 14:00:00', 2);
INSERT INTO `tbl_product` VALUES (11, '戴尔XPS 15', '13代酷睿 4K OLED触控', 12999, 11999, '2024-01-25 11:00:00', 2);
INSERT INTO `tbl_product` VALUES (12, '惠普战66六代', '商务轻薄 长续航', 4599, 4199, '2024-02-28 09:00:00', 2);
INSERT INTO `tbl_product` VALUES (13, 'MacBook Air M3', '8核CPU 10核GPU 13.6寸', 8999, 8499, '2024-02-10 10:00:00', 2);
INSERT INTO `tbl_product` VALUES (14, '索尼A7M4', '全画幅微单 3300万像素', 15999, 14999, '2024-01-12 15:00:00', 3);
INSERT INTO `tbl_product` VALUES (15, '索尼WH-1000XM5', '降噪耳机 30小时续航', 2999, 2599, '2024-02-18 10:30:00', 3);
INSERT INTO `tbl_product` VALUES (16, 'iPad Pro 12.9 M2', 'M2芯片  Liquid视网膜XDR', 9299, 8699, '2024-03-02 09:00:00', 3);
INSERT INTO `tbl_product` VALUES (17, '佳能R6 Mark II', '全画幅 机身防抖', 16999, 15999, '2024-01-22 14:00:00', 3);
INSERT INTO `tbl_product` VALUES (18, '森海塞尔Momentum 4', '无线头戴 60小时续航', 2699, 2399, '2024-02-25 11:00:00', 3);
INSERT INTO `tbl_product` VALUES (19, '海尔冰箱BCD-535', '对开门 风冷无霜 535L', 3999, 3499, '2024-02-05 10:00:00', 4);
INSERT INTO `tbl_product` VALUES (20, '美的空调KFR-35GW', '新一级能效 1.5匹变频', 2699, 2399, '2024-03-08 09:00:00', 4);
INSERT INTO `tbl_product` VALUES (21, '小米扫地机器人X10+', '自动集尘 激光导航', 3299, 2999, '2024-01-30 16:00:00', 4);
INSERT INTO `tbl_product` VALUES (22, '戴森V15 Detect', '激光显尘 60分钟续航', 4990, 4490, '2024-02-12 10:00:00', 4);
INSERT INTO `tbl_product` VALUES (23, '九阳破壁机Y1', '免手洗 静音 1.2L', 1999, 1799, '2024-03-12 14:00:00', 4);
INSERT INTO `tbl_product` VALUES (24, '男士商务休闲衬衫', '纯棉 免烫 多色', 299, 199, '2024-02-20 11:00:00', 5);
INSERT INTO `tbl_product` VALUES (25, '女士羊毛大衣', '双面呢 经典款', 899, 699, '2024-01-18 09:00:00', 5);
INSERT INTO `tbl_product` VALUES (26, '运动跑鞋 轻量透气', '缓震 防滑 多尺码', 459, 359, '2024-03-06 10:00:00', 5);
INSERT INTO `tbl_product` VALUES (27, '休闲帆布双肩包', '大容量 防水 学生办公', 159, 129, '2024-02-22 15:00:00', 5);
INSERT INTO `tbl_product` VALUES (28, '无线充电器 15W', '手机通用 快充', 89, 69, '2024-01-28 10:00:00', 1);
INSERT INTO `tbl_product` VALUES (29, '机械键盘 青轴', 'RGB背光 全键无冲', 399, 329, '2024-03-04 09:00:00', 2);
INSERT INTO `tbl_product` VALUES (30, '蓝牙音箱 便携', '立体声 20小时续航', 199, 159, '2024-02-14 14:00:00', 3);
INSERT INTO `tbl_product` VALUES (31, '手机壳 防摔软壳', '多款配色 贴合机型', 49, 39, '2024-03-15 10:00:00', 1);
INSERT INTO `tbl_product` VALUES (32, '钢化膜 全屏覆盖', '防爆防刮 高清透光', 29, 19, '2024-03-16 11:00:00', 1);
INSERT INTO `tbl_product` VALUES (33, '移动电源 20000mAh', '双向快充 多口输出', 159, 129, '2024-03-17 09:00:00', 1);
INSERT INTO `tbl_product` VALUES (34, '车载手机支架', '重力感应 出风口固定', 59, 45, '2024-03-18 14:00:00', 1);
INSERT INTO `tbl_product` VALUES (35, '自拍杆 蓝牙遥控', '伸缩 三角架 通用', 79, 59, '2024-03-19 10:00:00', 1);
INSERT INTO `tbl_product` VALUES (36, '努比亚Z60 Ultra', '屏下摄像 骁龙8 Gen3', 3999, 3699, '2024-03-20 09:00:00', 1);
INSERT INTO `tbl_product` VALUES (37, '魅族21 Pro', '无界设计 2K直屏', 4999, 4599, '2024-03-21 11:00:00', 1);
INSERT INTO `tbl_product` VALUES (38, '荣耀Magic6', '鹰眼相机 青海湖电池', 4699, 4299, '2024-03-22 15:00:00', 1);
INSERT INTO `tbl_product` VALUES (39, '雷柏键鼠套装', '无线 静音 办公家用', 199, 159, '2024-03-23 10:00:00', 2);
INSERT INTO `tbl_product` VALUES (40, '罗技MX Master 3', '无线鼠标 多设备切换', 699, 599, '2024-03-24 09:00:00', 2);
INSERT INTO `tbl_product` VALUES (41, '金士顿U盘 64GB', 'USB3.2 金属外壳', 89, 69, '2024-03-25 14:00:00', 2);
INSERT INTO `tbl_product` VALUES (42, '西数移动硬盘 2TB', '便携  USB3.0 加密', 499, 429, '2024-03-26 11:00:00', 2);
INSERT INTO `tbl_product` VALUES (43, '笔记本支架 铝合金', '可调节 散热 多档位', 129, 99, '2024-03-27 10:00:00', 2);
INSERT INTO `tbl_product` VALUES (44, '罗技C920摄像头', '1080P 自动对焦 降噪', 499, 429, '2024-03-28 09:00:00', 2);
INSERT INTO `tbl_product` VALUES (45, '小米AX6000路由器', 'WiFi6  mesh组网', 499, 399, '2024-03-29 15:00:00', 2);
INSERT INTO `tbl_product` VALUES (46, 'AOC 27寸显示器', '2K 75Hz IPS 窄边框', 1299, 1099, '2024-03-30 10:00:00', 2);
INSERT INTO `tbl_product` VALUES (47, '大疆Osmo Action 4', '运动相机 4K 防抖', 2598, 2298, '2024-04-01 11:00:00', 3);
INSERT INTO `tbl_product` VALUES (48, 'Kindle Paperwhite', '电子书 6.8寸 300ppi', 998, 898, '2024-04-02 09:00:00', 3);
INSERT INTO `tbl_product` VALUES (49, 'Apple Watch SE', '智能手表 GPS 44mm', 2199, 1999, '2024-04-03 14:00:00', 3);
INSERT INTO `tbl_product` VALUES (50, '小米手环8 Pro', '大屏  NFC 续航14天', 399, 329, '2024-04-04 10:00:00', 3);
INSERT INTO `tbl_product` VALUES (51, '曼富图三脚架', '碳纤维 云台 便携', 699, 599, '2024-04-05 09:00:00', 3);
INSERT INTO `tbl_product` VALUES (52, '罗德VideoMic', '机顶麦克风 降噪', 699, 599, '2024-04-06 15:00:00', 3);
INSERT INTO `tbl_product` VALUES (53, '多合一读卡器', 'SD/TF/USB 高速', 49, 35, '2024-04-07 11:00:00', 3);
INSERT INTO `tbl_product` VALUES (54, '三星T7移动固态1TB', '便携 1050MB/s', 799, 699, '2024-04-08 10:00:00', 3);
INSERT INTO `tbl_product` VALUES (55, '海信65寸4K电视', 'MEMC 远场语音', 3299, 2999, '2024-04-09 09:00:00', 4);
INSERT INTO `tbl_product` VALUES (56, '小天鹅滚筒洗衣机10kg', '变频 除菌 智能投放', 2699, 2399, '2024-04-10 14:00:00', 4);
INSERT INTO `tbl_product` VALUES (57, '格兰仕微波炉23L', '光波 智能菜单 转盘', 399, 329, '2024-04-11 10:00:00', 4);
INSERT INTO `tbl_product` VALUES (58, '美的塔扇', '静音 遥控 七叶', 299, 249, '2024-04-12 11:00:00', 4);
INSERT INTO `tbl_product` VALUES (59, '飞利浦加湿器', '无雾 除菌 4L', 399, 329, '2024-04-13 09:00:00', 4);
INSERT INTO `tbl_product` VALUES (60, '苏泊尔电热水壶1.7L', '304不锈钢 防干烧', 99, 79, '2024-04-14 15:00:00', 4);
INSERT INTO `tbl_product` VALUES (61, '美的电磁炉', '2200W 匀火 触控', 299, 249, '2024-04-15 10:00:00', 4);
INSERT INTO `tbl_product` VALUES (62, '九阳空气炸锅5L', '可视 无油 大容量', 399, 339, '2024-04-16 11:00:00', 4);
INSERT INTO `tbl_product` VALUES (63, '纯棉短袖T恤', '男女同款 多色 基础款', 89, 69, '2024-04-17 09:00:00', 5);
INSERT INTO `tbl_product` VALUES (64, '男士修身牛仔裤', '弹力 深蓝 多码', 199, 159, '2024-04-18 14:00:00', 5);
INSERT INTO `tbl_product` VALUES (65, '女士雪纺连衣裙', '碎花 收腰 夏款', 269, 219, '2024-04-19 10:00:00', 5);
INSERT INTO `tbl_product` VALUES (66, '轻薄羽绒服', '男女款 可收纳 保暖', 399, 329, '2024-04-20 11:00:00', 5);
INSERT INTO `tbl_product` VALUES (67, '男士皮带 自动扣', '头层牛皮 多款', 159, 129, '2024-04-21 09:00:00', 5);
INSERT INTO `tbl_product` VALUES (68, '棉袜 五双装', '纯棉 防臭 多色', 49, 39, '2024-04-22 15:00:00', 5);
INSERT INTO `tbl_product` VALUES (69, '棒球帽 刺绣', '可调节 防晒 多色', 59, 45, '2024-04-23 10:00:00', 5);
INSERT INTO `tbl_product` VALUES (70, '羊绒围巾', '秋冬 柔软 多色', 179, 139, '2024-04-24 11:00:00', 5);

-- ----------------------------
-- Table structure for tbl_salesitem
-- ----------------------------
DROP TABLE IF EXISTS `tbl_salesitem`;
CREATE TABLE `tbl_salesitem`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productid` int(11) NULL DEFAULT NULL,
  `unitprice` double NULL DEFAULT NULL,
  `pcount` int(11) NULL DEFAULT NULL,
  `orderid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tbl_salesorder
-- ----------------------------
DROP TABLE IF EXISTS `tbl_salesorder`;
CREATE TABLE `tbl_salesorder`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NULL DEFAULT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `odate` datetime(0) NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tbl_user
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `rdate` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_user（管理员：账号 admin 密码 admin，密码为 MD5 存储）
-- ----------------------------
INSERT INTO `tbl_user` VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', '10086', '中国广东省广州市越秀区环市东路419号 邮政编码: 510245', '2019-05-09 11:30:36');
INSERT INTO `tbl_user` VALUES (2, 'test', '2a60ed9325f63a5027953fd87290527d', '10086', '请修改你的地址', '2019-05-09 11:31:11');

-- ----------------------------
-- Table structure for tbl_recommend_setting（推荐商品配置表）
-- ----------------------------
DROP TABLE IF EXISTS `tbl_recommend_setting`;
CREATE TABLE `tbl_recommend_setting`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `product_id` int(0) NOT NULL,
  `sort_order` int(0) NULL DEFAULT 0,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `fk_recommend_product` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
