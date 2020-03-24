/*
Navicat MySQL Data Transfer

Source Server         : hadoop102
Source Server Version : 50624
Source Host           : hadoop102:3306
Source Database       : test

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-06-12 11:55:48
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for credit_log
-- ----------------------------
DROP TABLE IF EXISTS `credit_log`;
CREATE TABLE `credit_log` (
  `dist_id` int(11) DEFAULT NULL COMMENT '区组id',
  `account` varchar(100) DEFAULT NULL COMMENT '账号',
  `money` int(11) DEFAULT NULL COMMENT '充值金额',
  `create_time` datetime DEFAULT NULL COMMENT '订单时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of credit_log
-- ----------------------------
INSERT INTO `credit_log` VALUES ('1', 'ace', '1000', '2019-06-11 22:57:45');
INSERT INTO `credit_log` VALUES ('1', 'bce', '2000', '2019-06-11 22:58:15');
INSERT INTO `credit_log` VALUES ('1', 'zxc', '2000', '2019-06-11 09:50:58');
INSERT INTO `credit_log` VALUES ('2', 'ace', '1250', '2019-06-11 11:10:34');
INSERT INTO `credit_log` VALUES ('2', 'bbc', '1350', '2019-06-11 11:10:52');
INSERT INTO `credit_log` VALUES ('2', 'bcd', '1250', '2019-06-11 11:11:16');
INSERT INTO `credit_log` VALUES ('1', 'bce', '3000', '2019-06-11 11:20:12');
