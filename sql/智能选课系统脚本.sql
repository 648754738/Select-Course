create database `college-course`;


-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        11.4.2-MariaDB - mariadb.org binary distribution
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 导出  表 college-course.course 结构
CREATE TABLE IF NOT EXISTS `course` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '课程ID，主键',
  `course_no` varchar(20) NOT NULL COMMENT '课程编号，唯一标识',
  `course_name` varchar(100) NOT NULL COMMENT '课程名称',
  `credit` decimal(2,1) NOT NULL COMMENT '学分',
  `hours` int(11) NOT NULL COMMENT '学时',
  `department` varchar(100) NOT NULL COMMENT '开课部门',
  `course_type` enum('必修课','选修课') NOT NULL COMMENT '课程类型',
  `create_time` timestamp NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间，自动更新',
  `deleted` tinyint(4) DEFAULT 0 COMMENT '删除标记，0-未删除，1-已删除',
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_no` (`course_no`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='课程信息表';

-- 正在导出表  college-course.course 的数据：~5 rows (大约)
INSERT INTO `course` (`course_id`, `course_no`, `course_name`, `credit`, `hours`, `department`, `course_type`, `create_time`, `update_time`, `deleted`) VALUES
	(1, 'CS101', '数据结构', 4.0, 64, '商学院', '必修课', '2025-08-19 09:27:41', '2025-08-20 06:39:45', 0),
	(2, 'MA101', '高等数学', 5.0, 80, '商学院', '必修课', '2025-08-19 09:27:41', '2025-08-20 06:39:45', 0),
	(3, 'EN101', '商务英语', 4.0, 64, '商学院', '必修课', '2025-08-19 09:27:41', '2025-08-20 06:39:45', 0),
	(4, 'CS201', '人工智能导论', 3.0, 48, '商学院', '选修课', '2025-08-19 09:27:41', '2025-08-20 06:39:45', 0),
	(5, 'EE101', '操作系统', 4.0, 64, '商学院', '必修课', '2025-08-19 09:27:41', '2025-08-20 06:39:45', 0);

-- 导出  表 college-course.course_schedule 结构
CREATE TABLE IF NOT EXISTS `course_schedule` (
  `schedule_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '排课ID，主键',
  `course_name` varchar(50) NOT NULL COMMENT '课程名称作为外键',
  `teacher_name` varchar(50) NOT NULL COMMENT '老师姓名',
  `class_time` varchar(100) NOT NULL COMMENT '上课时间，如：周一1-2节，周三3-4节',
  `classroom` varchar(50) NOT NULL COMMENT '上课地点',
  `max_students` int(11) NOT NULL COMMENT '最大选课人数',
  `current_students` int(11) DEFAULT 0 COMMENT '当前选课人数',
  `semester` varchar(20) NOT NULL COMMENT '学期，如：2023-2024-1',
  `create_time` timestamp NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间，自动更新',
  `deleted` tinyint(4) DEFAULT 0 COMMENT '删除标记，0-未删除，1-已删除',
  `week` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='课程安排表，记录课程的授课教师、时间和地点';

-- 正在导出表  college-course.course_schedule 的数据：~3 rows (大约)
INSERT INTO `course_schedule` (`schedule_id`, `course_name`, `teacher_name`, `class_time`, `classroom`, `max_students`, `current_students`, `semester`, `create_time`, `update_time`, `deleted`, `week`) VALUES
	(13, '数据结构', '陈教授', '周一 1、2节、周三3、4节', '实验3楼503教室', 30, 0, '第二学期', '2025-08-24 08:21:34', '2025-08-24 08:21:34', 0, '星期一'),
	(14, '高等数学', '林老师', '星期二4、5节', '3号实验楼403教室', 30, 0, '第二学期', '2025-08-24 08:22:35', '2025-08-24 08:22:35', 0, '星期二'),
	(15, '人工智能导论', '吴教授', '星期二1、2节', '3实验楼514教室', 30, 0, '第二学期', '2025-08-24 10:32:26', '2025-08-24 10:32:26', 0, '星期三');

-- 导出  表 college-course.course_selection 结构
CREATE TABLE IF NOT EXISTS `course_selection` (
  `selection_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '选课记录ID，主键',
  `student_no` varchar(20) DEFAULT NULL COMMENT '学生学号',
  `student_name` varchar(30) NOT NULL COMMENT '学生名称',
  `course_name` varchar(30) NOT NULL COMMENT '课程名称',
  `select_time` timestamp NULL DEFAULT current_timestamp() COMMENT '选课时间',
  `score` decimal(5,2) DEFAULT NULL COMMENT '成绩，选课结束后由教师录入',
  `create_time` datetime DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间，自动更新',
  `teacher_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`selection_id`),
  KEY `idx_student_no` (`student_no`),
  KEY `idx_student_info` (`student_no`,`student_name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='选课记录表，记录学生选课信息及成绩';

-- 正在导出表  college-course.course_selection 的数据：~2 rows (大约)
INSERT INTO `course_selection` (`selection_id`, `student_no`, `student_name`, `course_name`, `select_time`, `score`, `create_time`, `update_time`, `teacher_name`) VALUES
	(11, '20210101', '张明', '数据结构', '2025-08-30 18:00:00', NULL, '2025-08-24 12:14:37', '2025-08-24 04:14:37', '陈教授'),
	(12, '20210102', '李娜', '高等数学', '2025-08-25 16:00:00', 100.00, '2025-08-24 12:15:20', '2025-08-24 10:14:56', '黄老师');

-- 导出  表 college-course.gen_table 结构
CREATE TABLE IF NOT EXISTS `gen_table` (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表';

-- 正在导出表  college-course.gen_table 的数据：~4 rows (大约)
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `tpl_web_type`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, 'course', '课程信息表', NULL, NULL, 'Course', 'crud', 'element-ui', 'com.course.college', 'course', 'course', '课程管理', '席老师', '0', '/', '{"parentMenuId":2000}', 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33', NULL),
	(2, 'course_schedule', '课程安排表', NULL, NULL, 'CourseSchedule', 'crud', 'element-ui', 'com.course.college', 'schedule', 'schedule', '课表管理', '席老师', '0', '/', '{"parentMenuId":2007}', 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44', NULL),
	(3, 'course_selection', '选课记录表，记录学生选课信息及成绩', NULL, NULL, 'CourseSelection', 'crud', 'element-ui', 'com.course.college', 'selection', 'selection', '选课管理', 'ruoyi', '0', '/', '{"parentMenuId":2007}', 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07', NULL),
	(4, 'student', '学生信息表', NULL, NULL, 'Student', 'crud', 'element-ui', 'com.course.college', 'student', 'student', '学生管理', '席老师', '0', '/', '{"parentMenuId":2007}', 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45', NULL);

-- 导出  表 college-course.gen_table_column 结构
CREATE TABLE IF NOT EXISTS `gen_table_column` (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成业务表字段';

-- 正在导出表  college-course.gen_table_column 的数据：~41 rows (大约)
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
	(1, 1, 'course_id', '课程ID，主键', 'int(11)', 'Long', 'courseId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(2, 1, 'course_no', '课程编号，唯一标识', 'varchar(20)', 'String', 'courseNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(3, 1, 'course_name', '课程名称', 'varchar(100)', 'String', 'courseName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(4, 1, 'credit', '学分', 'decimal(2,1)', 'BigDecimal', 'credit', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(5, 1, 'hours', '学时', 'int(11)', 'Long', 'hours', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(6, 1, 'department', '开课部门', 'varchar(100)', 'String', 'department', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(7, 1, 'course_type', '课程类型', 'enum(\'必修课\',\'选修课\')', 'String', 'courseType', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'select', '', 7, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(8, 1, 'create_time', '创建时间', 'timestamp', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(9, 1, 'update_time', '更新时间，自动更新', 'timestamp', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(10, 1, 'deleted', '删除标记，0-未删除，1-已删除', 'tinyint(4)', 'Integer', 'deleted', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 10, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 10:32:33'),
	(11, 2, 'schedule_id', '排课ID', 'int(11)', 'Long', 'scheduleId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(12, 2, 'course_name', '课程名', 'varchar(50)', 'String', 'courseName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(13, 2, 'teacher_name', '老师姓名', 'varchar(50)', 'String', 'teacherName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(14, 2, 'class_time', '上课时间', 'varchar(100)', 'String', 'classTime', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(15, 2, 'classroom', '上课地点', 'varchar(50)', 'String', 'classroom', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(16, 2, 'max_students', '最大选课人数', 'int(11)', 'Long', 'maxStudents', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(17, 2, 'current_students', '当前选课人数', 'int(11)', 'Long', 'currentStudents', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 7, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(18, 2, 'semester', '学期', 'varchar(20)', 'String', 'semester', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'select', 'semester_time', 8, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(19, 2, 'create_time', '创建时间', 'timestamp', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(20, 2, 'update_time', '更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 10, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(21, 2, 'deleted', '删除标记，0-未删除，1-已删除', 'tinyint(4)', 'Integer', 'deleted', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 11, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(22, 2, 'week', '星期', 'varchar(20)', 'String', 'week', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'select', 'week_day', 12, 'admin', '2025-08-21 10:30:23', '', '2025-08-22 09:58:44'),
	(23, 3, 'selection_id', '选课记录ID，主键', 'int(11)', 'Long', 'selectionId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(24, 3, 'student_name', '学生名称', 'varchar(30)', 'String', 'studentName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(25, 3, 'course_name', '课程名称', 'varchar(30)', 'String', 'courseName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(26, 3, 'select_time', '选课时间', 'timestamp', 'Date', 'selectTime', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'datetime', '', 4, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(27, 3, 'score', '成绩，选课结束后由教师录入', 'decimal(5,2)', 'BigDecimal', 'score', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 5, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(28, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(29, 3, 'update_time', '更新时间，自动更新', 'timestamp', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(30, 3, 'deleted', '删除标记，0-未删除，1-已删除', 'tinyint(4)', 'Integer', 'deleted', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 8, 'admin', '2025-08-21 10:30:23', '', '2025-08-21 16:54:07'),
	(31, 4, 'student_id', '学生ID，主键', 'int(11)', 'Long', 'studentId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(32, 4, 'student_no', '学号，唯一标识', 'varchar(20)', 'String', 'studentNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(33, 4, 'student_name', '学生姓名', 'varchar(50)', 'String', 'studentName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(34, 4, 'gender', '性别', 'enum(\'男\',\'女\')', 'String', 'gender', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'select', 'sys_user_sex', 4, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(35, 4, 'major', '专业', 'varchar(100)', 'String', 'major', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(36, 4, 'grade', '年级', 'year(4)', 'String', 'grade', '0', '0', '1', '1', '1', '1', '0', 'EQ', NULL, '', 6, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(37, 4, 'contact', '联系方式', 'varchar(20)', 'String', 'contact', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 7, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(38, 4, 'create_time', '创建时间', 'timestamp', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(39, 4, 'update_time', '更新时间，自动更新', 'timestamp', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(40, 4, 'deleted', '删除标记，0-未删除，1-已删除', 'tinyint(4)', 'Integer', 'deleted', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 10, 'admin', '2025-08-21 10:30:39', '', '2025-08-21 14:38:45'),
	(41, 3, 'teacherName', '老师名称', 'varchar(20)', 'String', 'teacherName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 9, '', '2025-08-21 16:52:13', '', '2025-08-21 16:54:07');

-- 导出  表 college-course.history_course_selection 结构
CREATE TABLE IF NOT EXISTS `history_course_selection` (
  `selection_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '选课记录id',
  `student_no` varchar(20) DEFAULT NULL COMMENT '学生学号',
  `student_name` varchar(30) DEFAULT NULL COMMENT '学生姓名',
  `course_name` varchar(30) DEFAULT NULL COMMENT '课程名称',
  `select_time` timestamp NULL DEFAULT current_timestamp() COMMENT '选课时间',
  `teacher_name` varchar(20) DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL COMMENT '成绩',
  `create_time` timestamp NULL DEFAULT current_timestamp(),
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `cancel_time` timestamp NULL DEFAULT current_timestamp() COMMENT '取消选课时间',
  `operation_type` varchar(10) DEFAULT '取消选课' COMMENT '操作类型：选课/取消选课',
  PRIMARY KEY (`selection_id`),
  KEY `idx_history_student_no` (`student_no`),
  KEY `idx_history_operation_type` (`operation_type`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 正在导出表  college-course.history_course_selection 的数据：~0 rows (大约)
INSERT INTO `history_course_selection` (`selection_id`, `student_no`, `student_name`, `course_name`, `select_time`, `teacher_name`, `score`, `create_time`, `update_time`, `cancel_time`, `operation_type`) VALUES
	(8, '20210101', '张明', '数据结构', '2025-08-24 16:00:00', '陈教授', NULL, '2025-08-24 01:55:13', '2025-08-24 01:55:13', '2025-08-24 03:11:14', '取消选课');

-- 导出  表 college-course.qrtz_blob_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob DEFAULT NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Blob类型的触发器表';

-- 正在导出表  college-course.qrtz_blob_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_calendars 结构
CREATE TABLE IF NOT EXISTS `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='日历信息表';

-- 正在导出表  college-course.qrtz_calendars 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_cron_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cron类型的触发器表';

-- 正在导出表  college-course.qrtz_cron_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_fired_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='已触发的触发器表';

-- 正在导出表  college-course.qrtz_fired_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_job_details 结构
CREATE TABLE IF NOT EXISTS `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务组名',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob DEFAULT NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务详细信息表';

-- 正在导出表  college-course.qrtz_job_details 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_locks 结构
CREATE TABLE IF NOT EXISTS `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='存储的悲观锁信息表';

-- 正在导出表  college-course.qrtz_locks 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_paused_trigger_grps 结构
CREATE TABLE IF NOT EXISTS `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='暂停的触发器表';

-- 正在导出表  college-course.qrtz_paused_trigger_grps 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_scheduler_state 结构
CREATE TABLE IF NOT EXISTS `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='调度器状态表';

-- 正在导出表  college-course.qrtz_scheduler_state 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_simple_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简单触发器的信息表';

-- 正在导出表  college-course.qrtz_simple_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_simprop_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='同步机制的行锁表';

-- 正在导出表  college-course.qrtz_simprop_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.qrtz_triggers 结构
CREATE TABLE IF NOT EXISTS `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob DEFAULT NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='触发器详细信息表';

-- 正在导出表  college-course.qrtz_triggers 的数据：~0 rows (大约)

-- 导出  表 college-course.student 结构
CREATE TABLE IF NOT EXISTS `student` (
  `student_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生ID，主键',
  `student_no` varchar(20) NOT NULL COMMENT '学号，唯一标识',
  `student_name` varchar(50) NOT NULL COMMENT '学生姓名',
  `gender` enum('男','女') NOT NULL COMMENT '性别',
  `major` varchar(100) NOT NULL COMMENT '专业',
  `grade` varchar(20) NOT NULL COMMENT '年级',
  `contact` varchar(20) DEFAULT NULL COMMENT '联系方式',
  `create_time` timestamp NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp() COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT 0 COMMENT '删除标记，0-未删除，1-已删除',
  `college_name` varchar(20) DEFAULT NULL COMMENT '学院名称',
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `student_no` (`student_no`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='学生信息表';

-- 正在导出表  college-course.student 的数据：~9 rows (大约)
INSERT INTO `student` (`student_id`, `student_no`, `student_name`, `gender`, `major`, `grade`, `contact`, `create_time`, `update_time`, `deleted`, `college_name`) VALUES
	(1, '20210101', '张明', '男', '电子商务', '2021电商1班', '13812345678', '2025-08-19 09:27:41', '2025-08-21 08:13:25', 0, '商学院'),
	(2, '20210102', '李娜', '女', '电子商务', '2021工商1班', '13887654321', '2025-08-19 09:27:41', '2025-08-21 08:13:25', 0, '商学院'),
	(3, '20220201', '王浩', '男', '电子商务', '2021物流1班', '13911223344', '2025-08-19 09:27:41', '2025-08-21 08:13:25', 0, '商学院'),
	(4, '20220202', '赵琳', '女', '电子商务', '2021软工1班', '13944332211', '2025-08-19 09:27:41', '2025-08-21 08:13:25', 0, '商学院'),
	(5, '20230301', '刘阳', '男', '电子商务', '2021计科1班', '13755667788', '2025-08-19 09:27:41', '2025-08-21 08:13:25', 0, '商学院'),
	(6, '20211003', '菲菲', '男', '电子商务', '2021电商2班', '18700000000', '2025-08-21 07:00:08', '2025-08-21 08:13:25', 0, '商学院'),
	(8, '20211005', '张丽丹', '男', '电子商务', '2021电商级1班', '110', '2025-08-21 07:39:25', '2025-08-21 08:13:25', 0, '商学院'),
	(9, '20211006', '张飞飞', '男', '电子商务', '2021电商级2班', '110', '2025-08-21 07:40:45', '2025-08-21 08:13:25', 0, '商学院'),
	(10, '20221007', '李花花', '男', '电子商务', '2021电商2班', '120', '2025-08-21 08:12:54', NULL, 0, '商学院');

-- 导出  表 college-course.sys_config 结构
CREATE TABLE IF NOT EXISTS `sys_config` (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='参数配置表';

-- 正在导出表  college-course.sys_config 的数据：~8 rows (大约)
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),
	(2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '初始化密码 123456'),
	(3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '深色主题theme-dark，浅色主题theme-light'),
	(4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2025-08-19 17:28:44', 'admin', '2025-08-21 09:56:01', '是否开启验证码功能（true开启，false关闭）'),
	(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '是否开启注册用户功能（true开启，false关闭）'),
	(6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),
	(7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),
	(8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-08-19 17:28:44', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- 导出  表 college-course.sys_dept 结构
CREATE TABLE IF NOT EXISTS `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='部门表';

-- 正在导出表  college-course.sys_dept 的数据：~10 rows (大约)
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
	(100, 0, '0', '北方民族大学', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 11:05:30'),
	(101, 100, '0,100', '商学院', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 11:05:39'),
	(102, 100, '0,100', '计算机科学院', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 11:12:29'),
	(103, 101, '0,100,101', '教务处', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 11:05:50'),
	(104, 101, '0,100,101', '学生处', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 15:12:28'),
	(105, 101, '0,100,101', '教研部', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 15:12:38'),
	(106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', '', NULL),
	(107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', '', NULL),
	(108, 102, '0,100,102', '教务处', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', 'admin', '2025-08-21 11:12:46'),
	(109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-19 17:28:41', '', NULL);

-- 导出  表 college-course.sys_dict_data 结构
CREATE TABLE IF NOT EXISTS `sys_dict_data` (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';

-- 正在导出表  college-course.sys_dict_data 的数据：~42 rows (大约)
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '性别男'),
	(2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '性别女'),
	(3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '性别未知'),
	(4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '显示菜单'),
	(5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '隐藏菜单'),
	(6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '正常状态'),
	(7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '停用状态'),
	(8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '正常状态'),
	(9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '停用状态'),
	(10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '默认分组'),
	(11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '系统分组'),
	(12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '系统默认是'),
	(13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '系统默认否'),
	(14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '通知'),
	(15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '公告'),
	(16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '正常状态'),
	(17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '关闭状态'),
	(18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '其他操作'),
	(19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '新增操作'),
	(20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '修改操作'),
	(21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '删除操作'),
	(22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '授权操作'),
	(23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '导出操作'),
	(24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '导入操作'),
	(25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '强退操作'),
	(26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '生成操作'),
	(27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '清空操作'),
	(28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '正常状态'),
	(29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-08-19 17:28:44', '', NULL, '停用状态'),
	(100, 0, '星期一', '星期一', 'week_day', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:53:38', '', NULL, NULL),
	(101, 0, '星期二', '星期二', 'week_day', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:53:46', '', NULL, NULL),
	(102, 0, '星期三', '星期三', 'week_day', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:53:53', '', NULL, NULL),
	(103, 0, '星期四', '星期四', 'week_day', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:54:00', '', NULL, NULL),
	(104, 0, '星期五', '星期五', 'week_day', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:54:07', '', NULL, NULL),
	(105, 0, '第一学期', '第一学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:55:57', '', NULL, NULL),
	(106, 0, '第二学期', '第二学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:05', '', NULL, NULL),
	(107, 0, '第三学期', '第三学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:11', '', NULL, NULL),
	(108, 0, '第四学期', '第四学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:17', '', NULL, NULL),
	(109, 0, '第五学期', '第五学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:23', '', NULL, NULL),
	(110, 0, '第六学期', '第六学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:34', '', NULL, NULL),
	(111, 0, '第七学期', '第七学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:40', '', NULL, NULL),
	(112, 0, '第八学期', '第八学期', 'semester_time', NULL, 'default', 'N', '0', 'admin', '2025-08-22 09:56:47', '', NULL, NULL);

-- 导出  表 college-course.sys_dict_type 结构
CREATE TABLE IF NOT EXISTS `sys_dict_type` (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典类型表';

-- 正在导出表  college-course.sys_dict_type 的数据：~12 rows (大约)
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '用户性别列表'),
	(2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '菜单状态列表'),
	(3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '系统开关列表'),
	(4, '任务状态', 'sys_job_status', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '任务状态列表'),
	(5, '任务分组', 'sys_job_group', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '任务分组列表'),
	(6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '系统是否列表'),
	(7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '通知类型列表'),
	(8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '通知状态列表'),
	(9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '操作类型列表'),
	(10, '系统状态', 'sys_common_status', '0', 'admin', '2025-08-19 17:28:43', '', NULL, '登录状态列表'),
	(100, '星期', 'week_day', '0', 'admin', '2025-08-22 09:53:15', '', NULL, NULL),
	(101, '学期', 'semester_time', '0', 'admin', '2025-08-22 09:55:43', '', NULL, NULL);

-- 导出  表 college-course.sys_job 结构
CREATE TABLE IF NOT EXISTS `sys_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度表';

-- 正在导出表  college-course.sys_job 的数据：~3 rows (大约)
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-08-19 17:28:44', '', NULL, ''),
	(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-08-19 17:28:44', '', NULL, ''),
	(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-08-19 17:28:44', '', NULL, '');

-- 导出  表 college-course.sys_job_log 结构
CREATE TABLE IF NOT EXISTS `sys_job_log` (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度日志表';

-- 正在导出表  college-course.sys_job_log 的数据：~0 rows (大约)

-- 导出  表 college-course.sys_logininfor 结构
CREATE TABLE IF NOT EXISTS `sys_logininfor` (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统访问记录';

-- 正在导出表  college-course.sys_logininfor 的数据：~17 rows (大约)
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
	(100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-08-21 09:55:35'),
	(101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 09:55:41'),
	(102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-21 09:56:08'),
	(103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 09:56:10'),
	(104, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 10:29:14'),
	(105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 14:34:25'),
	(106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-21 15:26:41'),
	(107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 15:27:14'),
	(108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 16:51:34'),
	(109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-21 17:22:25'),
	(110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-22 09:00:27'),
	(111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 08:30:18'),
	(112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 11:06:16'),
	(113, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 16:01:44'),
	(114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 18:10:01'),
	(115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-24 18:30:13'),
	(116, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 18:30:38');

-- 导出  表 college-course.sys_menu 结构
CREATE TABLE IF NOT EXISTS `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2066 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单权限表';

-- 正在导出表  college-course.sys_menu 的数据：~112 rows (大约)
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-08-19 17:28:42', '', NULL, '系统管理目录'),
	(2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-08-19 17:28:42', '', NULL, '系统监控目录'),
	(3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '1', '0', '', 'tool', 'admin', '2025-08-19 17:28:42', 'admin', '2025-08-24 13:19:08', '系统工具目录'),
	(4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '0', '', 'guide', 'admin', '2025-08-19 17:28:42', 'admin', '2025-08-21 09:56:27', '若依官网地址'),
	(100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-08-19 17:28:42', '', NULL, '用户管理菜单'),
	(101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-08-19 17:28:42', '', NULL, '角色管理菜单'),
	(102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-08-19 17:28:42', '', NULL, '菜单管理菜单'),
	(103, '院系管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-08-19 17:28:42', 'admin', '2025-08-21 15:11:57', '部门管理菜单'),
	(104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-08-19 17:28:42', '', NULL, '岗位管理菜单'),
	(105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-08-19 17:28:42', '', NULL, '字典管理菜单'),
	(106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-08-19 17:28:42', '', NULL, '参数设置菜单'),
	(107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-08-19 17:28:42', '', NULL, '通知公告菜单'),
	(108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-08-19 17:28:42', '', NULL, '日志管理菜单'),
	(109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-08-19 17:28:42', '', NULL, '在线用户菜单'),
	(110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-08-19 17:28:42', '', NULL, '定时任务菜单'),
	(111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-08-19 17:28:42', '', NULL, '数据监控菜单'),
	(112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-08-19 17:28:42', '', NULL, '服务监控菜单'),
	(113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-08-19 17:28:42', '', NULL, '缓存监控菜单'),
	(114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-08-19 17:28:42', '', NULL, '缓存列表菜单'),
	(115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '1', '0', 'tool:build:list', 'build', 'admin', '2025-08-19 17:28:42', 'admin', '2025-08-21 09:56:39', '表单构建菜单'),
	(116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-08-19 17:28:42', '', NULL, '代码生成菜单'),
	(117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '1', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-08-19 17:28:42', 'admin', '2025-08-21 09:56:45', '系统接口菜单'),
	(500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-08-19 17:28:42', '', NULL, '操作日志菜单'),
	(501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-08-19 17:28:42', '', NULL, '登录日志菜单'),
	(1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(2007, '数据管理', 0, 0, 'selection-course', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'tab', 'admin', '2025-08-21 14:36:01', 'admin', '2025-08-24 14:25:54', ''),
	(2008, '学生管理', 2007, 4, 'student', 'student/student/index', NULL, '', 1, 0, 'C', '0', '0', 'student:student:list', 'language', 'admin', '2025-08-21 14:43:22', 'admin', '2025-08-24 18:18:28', '学生管理菜单'),
	(2009, '学生管理查询', 2008, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'student:student:query', '#', 'admin', '2025-08-21 14:43:23', '', NULL, ''),
	(2010, '学生管理新增', 2008, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'student:student:add', '#', 'admin', '2025-08-21 14:43:23', '', NULL, ''),
	(2011, '学生管理修改', 2008, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'student:student:edit', '#', 'admin', '2025-08-21 14:43:23', '', NULL, ''),
	(2012, '学生管理删除', 2008, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'student:student:remove', '#', 'admin', '2025-08-21 14:43:23', '', NULL, ''),
	(2013, '学生管理导出', 2008, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'student:student:export', '#', 'admin', '2025-08-21 14:43:23', '', NULL, ''),
	(2014, '选课管理', 2007, 1, 'selection', 'selection/selection/index', NULL, '', 1, 0, 'C', '0', '0', 'selection:selection:list', 'theme', 'admin', '2025-08-21 16:54:32', 'admin', '2025-08-24 14:26:15', '选课管理菜单'),
	(2015, '选课管理查询', 2014, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'selection:selection:query', '#', 'admin', '2025-08-21 16:54:33', '', NULL, ''),
	(2016, '选课管理新增', 2014, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'selection:selection:add', '#', 'admin', '2025-08-21 16:54:33', '', NULL, ''),
	(2017, '选课管理修改', 2014, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'selection:selection:edit', '#', 'admin', '2025-08-21 16:54:33', '', NULL, ''),
	(2018, '选课管理删除', 2014, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'selection:selection:remove', '#', 'admin', '2025-08-21 16:54:33', '', NULL, ''),
	(2019, '选课管理导出', 2014, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'selection:selection:export', '#', 'admin', '2025-08-21 16:54:33', '', NULL, ''),
	(2020, '课表管理', 2007, 2, 'schedule', 'schedule/schedule/index', NULL, '', 1, 0, 'C', '0', '0', 'schedule:schedule:list', 'textarea', 'admin', '2025-08-22 09:59:02', 'admin', '2025-08-24 14:52:48', '课表管理菜单'),
	(2021, '课表管理查询', 2020, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'schedule:schedule:query', '#', 'admin', '2025-08-22 09:59:04', '', NULL, ''),
	(2022, '课表管理新增', 2020, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'schedule:schedule:add', '#', 'admin', '2025-08-22 09:59:04', '', NULL, ''),
	(2023, '课表管理修改', 2020, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'schedule:schedule:edit', '#', 'admin', '2025-08-22 09:59:04', '', NULL, ''),
	(2024, '课表管理删除', 2020, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'schedule:schedule:remove', '#', 'admin', '2025-08-22 09:59:05', '', NULL, ''),
	(2025, '课表管理导出', 2020, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'schedule:schedule:export', '#', 'admin', '2025-08-22 09:59:05', '', NULL, ''),
	(2026, '课程管理', 2007, 3, 'course', 'course/course/index', NULL, '', 1, 0, 'C', '0', '0', 'course:course:list', 'shopping', 'admin', '2025-08-24 10:00:00', 'admin', '2025-08-24 18:18:36', '课程管理菜单'),
	(2027, '课程管理查询', 2026, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'course:course:query', '#', 'admin', '2025-08-24 10:00:01', '', NULL, ''),
	(2028, '课程管理新增', 2026, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'course:course:add', '#', 'admin', '2025-08-24 10:00:02', '', NULL, ''),
	(2029, '课程管理修改', 2026, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'course:course:edit', '#', 'admin', '2025-08-24 10:00:03', '', NULL, ''),
	(2030, '课程管理删除', 2026, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'course:course:remove', '#', 'admin', '2025-08-24 10:00:04', '', NULL, ''),
	(2031, '课程管理导出', 2026, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'course:course:export', '#', 'admin', '2025-08-24 10:00:05', '', NULL, ''),
	(2033, '数据统计', 2007, 7, 'statistics', 'statistics/index', NULL, '', 1, 0, 'C', '0', '0', 'statistics:data:view', 'wechat', 'admin', '2025-08-24 10:00:07', 'admin', '2025-08-24 18:18:15', '数据统计菜单'),
	(2051, '选课历史', 2007, 6, 'history/selection', 'history/selection/index', '', '', 1, 0, 'C', '0', '0', 'history:selection:list', 'documentation', 'admin', '2025-08-24 10:17:22', 'admin', '2025-08-24 18:17:49', '选课历史记录菜单'),
	(2052, '历史记录查询', 2051, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'history:selection:query', '#', 'admin', '2025-08-24 10:17:22', '', NULL, ''),
	(2053, '历史记录列表', 2051, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'history:selection:list', '#', 'admin', '2025-08-24 10:17:22', '', NULL, ''),
	(2054, '历史记录导出', 2051, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'history:selection:export', '#', 'admin', '2025-08-24 10:17:22', '', NULL, ''),
	(2055, '历史记录删除', 2051, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'history:selection:remove', '#', 'admin', '2025-08-24 10:17:22', '', NULL, ''),
	(2060, '教师管理', 2007, 5, 'teacher', 'college/teacher/index', NULL, '', 1, 0, 'C', '0', '0', 'college:teacher:list', 'peoples', 'admin', '2025-08-24 14:09:32', 'admin', '2025-08-24 18:17:36', '教师管理菜单'),
	(2061, '教师查询', 2060, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'college:teacher:query', '#', 'admin', '2025-08-24 14:09:33', 'admin', '2025-08-24 14:45:11', ''),
	(2062, '教师新增', 2060, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'college:teacher:add', '#', 'admin', '2025-08-24 14:09:33', 'admin', '2025-08-24 14:45:20', ''),
	(2063, '教师修改', 2060, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'college:teacher:edit', '#', 'admin', '2025-08-24 14:09:33', 'admin', '2025-08-24 14:45:30', ''),
	(2064, '教师删除', 2060, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'college:teacher:remove', '#', 'admin', '2025-08-24 14:09:33', 'admin', '2025-08-24 14:45:38', ''),
	(2065, '教师导出', 2060, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'college:teacher:export', '#', 'admin', '2025-08-24 14:09:33', 'admin', '2025-08-24 14:45:47', '');

-- 导出  表 college-course.sys_notice 结构
CREATE TABLE IF NOT EXISTS `sys_notice` (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob DEFAULT NULL COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知公告表';

-- 正在导出表  college-course.sys_notice 的数据：~2 rows (大约)
INSERT INTO `sys_notice` (`notice_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', _binary 0xe696b0e78988e69cace58685e5aeb9, '0', 'admin', '2025-08-19 17:28:45', '', NULL, '管理员'),
	(2, '维护通知：2018-07-01 若依系统凌晨维护', '1', _binary 0xe7bbb4e68aa4e58685e5aeb9, '0', 'admin', '2025-08-19 17:28:45', '', NULL, '管理员');

-- 导出  表 college-course.sys_oper_log 结构
CREATE TABLE IF NOT EXISTS `sys_oper_log` (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int(1) DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志记录';

-- 正在导出表  college-course.sys_oper_log 的数据：~115 rows (大约)
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES
	(100, '参数管理', 2, 'com.course.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{"configId":4,"configKey":"sys.account.captchaEnabled","configName":"账号自助-验证码开关","configType":"Y","configValue":"false","createBy":"admin","createTime":"2025-08-19 17:28:44","params":{},"remark":"是否开启验证码功能（true开启，false关闭）","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 09:56:01', 39),
	(101, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createTime":"2025-08-19 17:28:42","icon":"guide","isCache":"0","isFrame":"0","menuId":4,"menuName":"若依官网","menuType":"M","orderNum":4,"params":{},"parentId":0,"path":"http://ruoyi.vip","perms":"","query":"","routeName":"","status":"0","updateBy":"admin","visible":"1"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 09:56:27', 37),
	(102, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"tool/build/index","createTime":"2025-08-19 17:28:42","icon":"build","isCache":"0","isFrame":"1","menuId":115,"menuName":"表单构建","menuType":"C","orderNum":1,"params":{},"parentId":3,"path":"build","perms":"tool:build:list","query":"","routeName":"","status":"0","updateBy":"admin","visible":"1"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 09:56:39', 17),
	(103, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"tool/swagger/index","createTime":"2025-08-19 17:28:42","icon":"swagger","isCache":"0","isFrame":"1","menuId":117,"menuName":"系统接口","menuType":"C","orderNum":3,"params":{},"parentId":3,"path":"swagger","perms":"tool:swagger:list","query":"","routeName":"","status":"0","updateBy":"admin","visible":"1"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 09:56:45', 13),
	(104, '菜单管理', 1, 'com.course.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createBy":"admin","icon":"bug","isCache":"0","isFrame":"1","menuName":"数据 管理","menuType":"M","orderNum":0,"params":{},"parentId":0,"path":"course-selections","status":"0","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 10:29:39', 26),
	(105, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createTime":"2025-08-21 10:29:38","icon":"bug","isCache":"0","isFrame":"1","menuId":2000,"menuName":"数据管理","menuType":"M","orderNum":0,"params":{},"parentId":0,"path":"course-selections","perms":"","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 10:29:52', 10),
	(106, '代码生成', 6, 'com.course.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"course,course_selection,course_schedule"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 10:30:23', 185),
	(107, '代码生成', 6, 'com.course.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"student"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 10:30:39', 43),
	(108, '代码生成', 2, 'com.course.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"course","className":"Course","columns":[{"capJavaField":"CourseId","columnComment":"课程ID，主键","columnId":1,"columnName":"course_id","columnType":"int(11)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":false,"isIncrement":"1","isInsert":"0","isPk":"1","isRequired":"0","javaField":"courseId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":1,"updateBy":"","usableColumn":false},{"capJavaField":"CourseNo","columnComment":"课程编号，唯一标识","columnId":2,"columnName":"course_no","columnType":"varchar(20)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"courseNo","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"EQ","required":true,"sort":2,"superColumn":false,"tableId":1,"updateBy":"","usableColumn":false},{"capJavaField":"CourseName","columnComment":"课程名称","columnId":3,"columnName":"course_name","columnType":"varchar(100)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"courseName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":3,"superColumn":false,"tableId":1,"updateBy":"","usableColumn":false},{"capJavaField":"Credit","columnComment":"学分","columnId":4,"columnName":"credit","columnType":"decimal(2,1)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"0","', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 10:32:33', 57),
	(109, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0","children":[],"deptId":100,"deptName":"北方民族大学","email":"ry@qq.com","leader":"若依","orderNum":0,"params":{},"parentId":0,"phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 11:05:30', 40),
	(110, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100","children":[],"deptId":101,"deptName":"商学院","email":"ry@qq.com","leader":"若依","orderNum":1,"params":{},"parentId":100,"parentName":"北方民族大学","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 11:05:39', 39),
	(111, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100,101","children":[],"deptId":103,"deptName":"教务处","email":"ry@qq.com","leader":"若依","orderNum":1,"params":{},"parentId":101,"parentName":"商学院","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 11:05:50', 28),
	(112, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100","children":[],"deptId":102,"deptName":"计算机科学院","email":"ry@qq.com","leader":"若依","orderNum":2,"params":{},"parentId":100,"parentName":"北方民族大学","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 11:12:29', 28),
	(113, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100,102","children":[],"deptId":108,"deptName":"教务处","email":"ry@qq.com","leader":"若依","orderNum":1,"params":{},"parentId":102,"parentName":"计算机科学院","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 11:12:46', 20),
	(114, '菜单管理', 1, 'com.course.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createBy":"admin","icon":"clipboard","isCache":"0","isFrame":"1","menuName":"数据管理","menuType":"M","orderNum":0,"params":{},"parentId":0,"path":"selection-course","status":"0","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 14:36:01', 39),
	(115, '代码生成', 2, 'com.course.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '教务处', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"student","className":"Student","columns":[{"capJavaField":"StudentId","columnComment":"学生ID，主键","columnId":31,"columnName":"student_id","columnType":"int(11)","createBy":"admin","createTime":"2025-08-21 10:30:39","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":false,"isIncrement":"1","isInsert":"0","isPk":"1","isRequired":"0","javaField":"studentId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":4,"updateBy":"","usableColumn":false},{"capJavaField":"StudentNo","columnComment":"学号，唯一标识","columnId":32,"columnName":"student_no","columnType":"varchar(20)","createBy":"admin","createTime":"2025-08-21 10:30:39","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"studentNo","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"EQ","required":true,"sort":2,"superColumn":false,"tableId":4,"updateBy":"","usableColumn":false},{"capJavaField":"StudentName","columnComment":"学生姓名","columnId":33,"columnName":"student_name","columnType":"varchar(50)","createBy":"admin","createTime":"2025-08-21 10:30:39","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"studentName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":3,"superColumn":false,"tableId":4,"updateBy":"","usableColumn":false},{"capJavaField":"Gender","columnComment":"性别","columnId":34,"columnName":"gender","columnType":"enum(\'男\',\'女\')","createBy":"admin","createTime":"2025-08-21 10:30:39","dictType":"sys_user_sex","edit":true,"htmlType":"select","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1",', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 14:38:45', 142),
	(116, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"110","gender":"0","major":"软件工程","studentName":"张飞","studentNo":"20241001"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'grade\' doesn\'t have a default value\r\n### The error may exist in com/course/college/mapper/StudentMapper.java (best guess)\r\n### The error may involve com.course.college.mapper.StudentMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO student  ( student_no, student_name, gender, major,  contact )  VALUES  ( ?, ?, ?, ?,  ? )\r\n### Cause: java.sql.SQLException: Field \'grade\' doesn\'t have a default value\n; Field \'grade\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'grade\' doesn\'t have a default value', '2025-08-21 14:55:00', 17),
	(117, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"120","gender":"1","grade":"2021电商2班","major":"电子商务","studentId":6,"studentName":"菲菲","studentNo":"20211003"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:00:08', 9),
	(118, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"18700000000","createTime":"2025-08-21 15:00:08","deleted":0,"gender":"男","grade":"2021电商2班","major":"电子商务","studentId":6,"studentName":"菲菲","studentNo":"20211003"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:00:19', 15),
	(119, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"system/dept/index","createTime":"2025-08-19 17:28:42","icon":"tree","isCache":"0","isFrame":"1","menuId":103,"menuName":"院系管理","menuType":"C","orderNum":4,"params":{},"parentId":1,"path":"dept","perms":"system:dept:list","query":"","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:11:57', 15),
	(120, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '教务处', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100,101","children":[],"deptId":104,"deptName":"学生处","email":"ry@qq.com","leader":"若依","orderNum":2,"params":{},"parentId":101,"parentName":"商学院","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:12:28', 45),
	(121, '部门管理', 2, 'com.course.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '教务处', '/system/dept', '127.0.0.1', '内网IP', '{"ancestors":"0,100,101","children":[],"deptId":105,"deptName":"教研部","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"parentName":"商学院","phone":"15888888888","status":"0","updateBy":"admin"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:12:38', 22),
	(122, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","gender":"0","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:24:16', 168),
	(123, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","createTime":"2025-08-21 15:24:16","deleted":0,"gender":"0","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:24:26', 15),
	(124, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","createTime":"2025-08-21 15:24:16","deleted":0,"gender":"1","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:24:51', 8),
	(125, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","createTime":"2025-08-21 15:24:16","deleted":0,"gender":"男","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545","updateTime":"2025-08-21 15:24:51"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:26:41', 56517),
	(126, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","createTime":"2025-08-21 15:24:16","deleted":0,"deptId":"101","gender":"男","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545","updateTime":"2025-08-21 15:24:51"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:28:03', 39590),
	(127, '学生管理', 2, 'com.course.college.controller.StudentController.edit()', 'PUT', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"contact":"4545","createTime":"2025-08-21 15:24:16","deleted":0,"gender":"男","grade":"4545","major":"4545","studentId":7,"studentName":"4545","studentNo":"4545","updateTime":"2025-08-21 15:24:51"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:36:29', 22),
	(128, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"collegeName":"商学院","contact":"110","deptId":101,"gender":"1","grade":"2021电商级1班","major":"电子商务","studentName":"张丽丹","studentNo":"20211005"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:39:25', 13852),
	(129, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"collegeName":"商学院","contact":"110","deptId":101,"gender":"1","grade":"2021电商级2班","major":"电子商务","studentName":"张飞飞","studentNo":"20211006"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 15:40:45', 26373),
	(130, '学生管理', 1, 'com.course.college.controller.StudentController.add()', 'POST', 1, 'admin', '教务处', '/student/student', '127.0.0.1', '内网IP', '{"collegeName":"商学院","contact":"120","deptId":101,"gender":"1","grade":"2021电商2班","major":"电子商务","studentId":10,"studentName":"李花花","studentNo":"20221007"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 16:12:54', 277),
	(131, '代码生成', 2, 'com.course.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '教务处', '/tool/gen/synchDb/course_selection', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 16:52:13', 202),
	(132, '代码生成', 2, 'com.course.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '教务处', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"selection","className":"CourseSelection","columns":[{"capJavaField":"SelectionId","columnComment":"选课记录ID，主键","columnId":23,"columnName":"selection_id","columnType":"int(11)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":false,"isIncrement":"1","isInsert":"0","isPk":"1","isRequired":"0","javaField":"selectionId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":3,"updateBy":"","updateTime":"2025-08-21 16:52:12","usableColumn":false},{"capJavaField":"StudentName","columnComment":"学生名称","columnId":24,"columnName":"student_name","columnType":"varchar(30)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"studentName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":2,"superColumn":false,"tableId":3,"updateBy":"","updateTime":"2025-08-21 16:52:12","usableColumn":false},{"capJavaField":"CourseName","columnComment":"课程名称","columnId":25,"columnName":"course_name","columnType":"varchar(30)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"courseName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":3,"superColumn":false,"tableId":3,"updateBy":"","updateTime":"2025-08-21 16:52:12","usableColumn":false},{"capJavaField":"SelectTime","columnComment":"选课时间","columnId":26,"columnName":"select_time","columnType":"timestamp","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","ed', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-21 16:54:07', 87),
	(133, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/3', '127.0.0.1', '内网IP', '[3]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:24:38', 111754),
	(134, '字典类型', 1, 'com.course.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/type', '127.0.0.1', '内网IP', '{"createBy":"admin","dictName":"星期","dictType":"week_day","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:53:15', 29),
	(135, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"星期一","dictSort":0,"dictType":"week_day","dictValue":"星期一","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:53:38', 16),
	(136, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"星期二","dictSort":0,"dictType":"week_day","dictValue":"星期二","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:53:46', 25),
	(137, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"星期三","dictSort":0,"dictType":"week_day","dictValue":"星期三","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:53:53', 22),
	(138, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"星期四","dictSort":0,"dictType":"week_day","dictValue":"星期四","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:54:00', 11),
	(139, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"星期五","dictSort":0,"dictType":"week_day","dictValue":"星期五","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:54:07', 20),
	(140, '字典类型', 1, 'com.course.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/type', '127.0.0.1', '内网IP', '{"createBy":"admin","dictName":"学期","dictType":"semester_time","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:55:43', 13),
	(141, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第一学期","dictSort":0,"dictType":"semester_time","dictValue":"第一学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:55:57', 28),
	(142, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第二学期","dictSort":0,"dictType":"semester_time","dictValue":"第二学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:05', 16),
	(143, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第三学期","dictSort":0,"dictType":"semester_time","dictValue":"第三学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:11', 12),
	(144, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第四学期","dictSort":0,"dictType":"semester_time","dictValue":"第四学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:17', 19),
	(145, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第五学期","dictSort":0,"dictType":"semester_time","dictValue":"第五学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:23', 13),
	(146, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第六学期","dictSort":0,"dictType":"semester_time","dictValue":"第六学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:34', 23),
	(147, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第七学期","dictSort":0,"dictType":"semester_time","dictValue":"第七学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:40', 14),
	(148, '字典数据', 1, 'com.course.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '教务处', '/system/dict/data', '127.0.0.1', '内网IP', '{"createBy":"admin","default":false,"dictLabel":"第八学期","dictSort":0,"dictType":"semester_time","dictValue":"第八学期","listClass":"default","params":{},"status":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:56:47', 22),
	(149, '代码生成', 2, 'com.course.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '教务处', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"schedule","className":"CourseSchedule","columns":[{"capJavaField":"ScheduleId","columnComment":"排课ID","columnId":11,"columnName":"schedule_id","columnType":"int(11)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":false,"isIncrement":"1","isInsert":"0","isPk":"1","isRequired":"0","javaField":"scheduleId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":2,"updateBy":"","usableColumn":false},{"capJavaField":"CourseName","columnComment":"课程名","columnId":12,"columnName":"course_name","columnType":"varchar(50)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"courseName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":2,"superColumn":false,"tableId":2,"updateBy":"","usableColumn":false},{"capJavaField":"TeacherName","columnComment":"老师姓名","columnId":13,"columnName":"teacher_name","columnType":"varchar(50)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"1","javaField":"teacherName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":true,"sort":3,"superColumn":false,"tableId":2,"updateBy":"","usableColumn":false},{"capJavaField":"ClassTime","columnComment":"上课时间","columnId":14,"columnName":"class_time","columnType":"varchar(100)","createBy":"admin","createTime":"2025-08-21 10:30:23","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 09:58:44', 119),
	(150, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/1', '127.0.0.1', '内网IP', '[1]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 10:50:26', 874),
	(151, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-22","selectionId":4,"studentName":"王菲菲","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 10:51:06', 9),
	(152, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/4', '127.0.0.1', '内网IP', '[4]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 10:57:28', 598),
	(153, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-22","selectionId":5,"studentName":"张菲菲","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 11:07:19', 425),
	(154, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-22","selectionId":6,"studentName":"李菲菲","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 11:07:30', 32),
	(155, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/5,6', '127.0.0.1', '内网IP', '[5,6]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 11:07:50', 302),
	(156, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-06","selectionId":7,"studentName":"李娜","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 11:08:40', 29),
	(157, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/2,7', '127.0.0.1', '内网IP', '[2,7]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-22 11:09:02', 129),
	(158, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-24 00:00:00","selectionId":8,"studentName":"王菲菲","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 08:31:10', 52),
	(159, '菜单管理', 3, 'com.course.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '教务处', '/system/menu/2032', '127.0.0.1', '内网IP', '2032', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 08:49:02', 11),
	(160, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第一学期"}', '{"msg":"自动排课成功！已根据学生选课情况生成课表安排。","code":200}', 0, NULL, '2025-08-24 09:14:48', 62),
	(161, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"电子技术基础","selectTime":"2025-08-24 09:35:22","selectionId":9,"studentName":"花花","teacherName":"郑老师"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 09:35:24', 26),
	(162, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/6', '127.0.0.1', '内网IP', '[6]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 09:49:00', 13),
	(163, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-25 00:00:00","selectionId":10,"studentName":"张明","studentNo":"20210101","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 09:55:13', 236),
	(164, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/10', '127.0.0.1', '内网IP', '[10]', NULL, 1, '取消选课失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:47 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1\r\n### The error may exist in com/course/college/mapper/HistoryCourseSelectionMapper.java (best guess)\r\n### The error may involve com.course.college.mapper.HistoryCourseSelectionMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO history_course_selection  ( student_no, student_name, course_name, select_time, teacher_name,  create_time, update_time, cancel_time, operation_type )  VALUES  ( ?, ?, ?, ?, ?,  ?, ?, ?, ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:47 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1\n; Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:47 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:47 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1', '2025-08-24 11:08:47', 79),
	(165, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/10', '127.0.0.1', '内网IP', '[10]', NULL, 1, '取消选课失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:55 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1\r\n### The error may exist in com/course/college/mapper/HistoryCourseSelectionMapper.java (best guess)\r\n### The error may involve com.course.college.mapper.HistoryCourseSelectionMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO history_course_selection  ( student_no, student_name, course_name, select_time, teacher_name,  create_time, update_time, cancel_time, operation_type )  VALUES  ( ?, ?, ?, ?, ?,  ?, ?, ?, ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:55 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1\n; Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:55 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sun Aug 24 11:08:55 CST 2025\' for column `college-course`.`history_course_selection`.`cancel_time` at row 1', '2025-08-24 11:08:55', 9),
	(166, '选课管理', 3, 'com.course.college.controller.CourseSelectionController.remove()', 'DELETE', 1, 'admin', '教务处', '/selection/selection/10', '127.0.0.1', '内网IP', '[10]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 11:11:15', 266),
	(167, '课表管理', 5, 'com.course.college.controller.CourseScheduleController.export()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/export', '127.0.0.1', '内网IP', '{"pageSize":"10000","pageNum":"1"}', NULL, 0, NULL, '2025-08-24 11:32:15', 1457),
	(168, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第一学期"}', '{"msg":"自动排课失败，请检查是否有选课记录或系统配置。","code":500}', 0, NULL, '2025-08-24 11:54:55', 22),
	(169, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第一学期"}', '{"msg":"自动排课失败，请检查是否有选课记录或系统配置。","code":500}', 0, NULL, '2025-08-24 11:55:21', 6),
	(170, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"数据结构","selectTime":"2025-08-31 02:00:00","selectionId":11,"studentName":"张明","studentNo":"20210101","teacherName":"陈教授"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:14:37', 306),
	(171, '选课管理', 1, 'com.course.college.controller.CourseSelectionController.add()', 'POST', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"courseName":"高等数学","selectTime":"2025-08-26 00:00:00","selectionId":12,"studentName":"李娜","studentNo":"20210102","teacherName":"黄老师"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:15:20', 31),
	(172, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第一学期"}', '{"msg":"自动排课成功！已根据学生选课情况生成课表安排。","code":200}', 0, NULL, '2025-08-24 12:15:40', 27),
	(173, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/7', '127.0.0.1', '内网IP', '[7]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:15:54', 7),
	(174, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/8', '127.0.0.1', '内网IP', '[8]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:16:00', 8),
	(175, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第五学期"}', '{"msg":"自动排课成功！已根据学生选课情况生成 第五学期 的课表安排。请刷新页面查看最新课表。","code":200}', 0, NULL, '2025-08-24 12:25:09', 74),
	(176, '自动排课', 1, 'com.course.college.controller.CourseScheduleController.generateSchedule()', 'POST', 1, 'admin', '教务处', '/schedule/schedule/generateSchedule', '127.0.0.1', '内网IP', '{"semester":"第二学期"}', '{"msg":"自动排课成功！已根据学生选课情况生成 第二学期 的课表安排。请刷新页面查看最新课表。","code":200}', 0, NULL, '2025-08-24 12:25:45', 22),
	(177, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/9', '127.0.0.1', '内网IP', '[9]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:26:02', 9),
	(178, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/12', '127.0.0.1', '内网IP', '[12]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 12:26:07', 8),
	(179, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createTime":"2025-08-19 17:28:42","icon":"tool","isCache":"0","isFrame":"1","menuId":3,"menuName":"系统工具","menuType":"M","orderNum":3,"params":{},"parentId":0,"path":"tool","perms":"","query":"","routeName":"","status":"0","updateBy":"admin","visible":"1"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 13:19:09', 35),
	(180, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"student/student/index","createTime":"2025-08-21 14:43:22","icon":"clipboard","isCache":"0","isFrame":"1","menuId":2008,"menuName":"学生管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"student","perms":"student:student:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:25:32', 40),
	(181, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"student/student/index","createTime":"2025-08-21 14:43:22","icon":"tab","isCache":"0","isFrame":"1","menuId":2008,"menuName":"学生管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"student","perms":"student:student:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:25:43', 10),
	(182, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createTime":"2025-08-21 14:36:01","icon":"tab","isCache":"0","isFrame":"1","menuId":2007,"menuName":"数据管理","menuType":"M","orderNum":0,"params":{},"parentId":0,"path":"selection-course","perms":"","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:25:54', 9),
	(183, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"student/student/index","createTime":"2025-08-21 14:43:22","icon":"language","isCache":"0","isFrame":"1","menuId":2008,"menuName":"学生管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"student","perms":"student:student:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:26:04', 7),
	(184, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"selection/selection/index","createTime":"2025-08-21 16:54:32","icon":"theme","isCache":"0","isFrame":"1","menuId":2014,"menuName":"选课管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"selection","perms":"selection:selection:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:26:15', 10),
	(185, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"schedule/schedule/index","createTime":"2025-08-22 09:59:02","icon":"textarea","isCache":"0","isFrame":"1","menuId":2020,"menuName":"课表管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"schedule","perms":"schedule:schedule:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:26:26', 9),
	(186, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"course/course/index","createTime":"2025-08-24 10:00:00","icon":"shopping","isCache":"0","isFrame":"1","menuId":2026,"menuName":"课程管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"course","perms":"course:course:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:26:42', 7),
	(187, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"statistics/index","createTime":"2025-08-24 10:00:07","icon":"wechat","isCache":"0","isFrame":"1","menuId":2033,"menuName":"数据统计","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"statistics","perms":"statistics:data:view","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:26:58', 10),
	(188, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"schedule/schedule/index","createTime":"2025-08-22 09:59:02","icon":"textarea","isCache":"0","isFrame":"1","menuId":2020,"menuName":"排课管理","menuType":"C","orderNum":1,"params":{},"parentId":2007,"path":"schedule","perms":"schedule:schedule:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:27:14', 9),
	(189, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"student/student/index","createTime":"2025-08-21 14:43:22","icon":"language","isCache":"0","isFrame":"1","menuId":2008,"menuName":"学生管理","menuType":"C","orderNum":3,"params":{},"parentId":2007,"path":"student","perms":"student:student:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:29:56', 11),
	(190, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"schedule/schedule/index","createTime":"2025-08-22 09:59:02","icon":"textarea","isCache":"0","isFrame":"1","menuId":2020,"menuName":"排课管理","menuType":"C","orderNum":2,"params":{},"parentId":2007,"path":"schedule","perms":"schedule:schedule:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:30:09', 15),
	(191, '菜单管理', 3, 'com.course.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '教务处', '/system/menu/2065', '127.0.0.1', '内网IP', '2065', '{"msg":"菜单已分配,不允许删除","code":601}', 0, NULL, '2025-08-24 14:44:28', 13),
	(192, '菜单管理', 3, 'com.course.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '教务处', '/system/menu/2061', '127.0.0.1', '内网IP', '2061', '{"msg":"菜单已分配,不允许删除","code":601}', 0, NULL, '2025-08-24 14:44:39', 4),
	(193, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"","createTime":"2025-08-24 14:09:33","icon":"#","isCache":"0","isFrame":"1","menuId":2061,"menuName":"教师查询","menuType":"F","orderNum":1,"params":{},"parentId":2060,"path":"#","perms":"college:teacher:query","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:45:11', 30),
	(194, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"","createTime":"2025-08-24 14:09:33","icon":"#","isCache":"0","isFrame":"1","menuId":2062,"menuName":"教师新增","menuType":"F","orderNum":2,"params":{},"parentId":2060,"path":"#","perms":"college:teacher:add","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:45:20', 9),
	(195, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"","createTime":"2025-08-24 14:09:33","icon":"#","isCache":"0","isFrame":"1","menuId":2063,"menuName":"教师修改","menuType":"F","orderNum":3,"params":{},"parentId":2060,"path":"#","perms":"college:teacher:edit","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:45:30', 8),
	(196, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"","createTime":"2025-08-24 14:09:33","icon":"#","isCache":"0","isFrame":"1","menuId":2064,"menuName":"教师删除","menuType":"F","orderNum":4,"params":{},"parentId":2060,"path":"#","perms":"college:teacher:remove","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:45:38', 10),
	(197, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"","createTime":"2025-08-24 14:09:33","icon":"#","isCache":"0","isFrame":"1","menuId":2065,"menuName":"教师导出","menuType":"F","orderNum":5,"params":{},"parentId":2060,"path":"#","perms":"college:teacher:export","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:45:47', 11),
	(198, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"history/selection/index","createTime":"2025-08-24 10:17:22","icon":"documentation","isCache":"0","isFrame":"1","menuId":2051,"menuName":"选课历史","menuType":"C","orderNum":4,"params":{},"parentId":2007,"path":"history/selection","perms":"history:selection:list","query":"","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:46:13', 11),
	(199, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"schedule/schedule/index","createTime":"2025-08-22 09:59:02","icon":"textarea","isCache":"0","isFrame":"1","menuId":2020,"menuName":"课表管理","menuType":"C","orderNum":2,"params":{},"parentId":2007,"path":"schedule","perms":"schedule:schedule:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 14:52:48', 10),
	(200, '教师信息', 2, 'com.course.college.controller.TeacherController.edit()', 'PUT', 1, 'admin', '教务处', '/college/teacher', '127.0.0.1', '内网IP', '{"contact":"13512345678","createTime":"2025-08-19 17:27:41","department":"商学院","gender":"男","teacherId":1,"teacherName":"陈教授","teacherNo":"T001","title":"教授","updateTime":"2025-08-19 17:27:41"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 15:11:59', 50),
	(201, '教师信息', 2, 'com.course.college.controller.TeacherController.edit()', 'PUT', 1, 'admin', '教务处', '/college/teacher', '127.0.0.1', '内网IP', '{"contact":"13512345678","createTime":"2025-08-19 17:27:41","department":"商学院","gender":"男","teacherId":1,"teacherName":"陈教授","teacherNo":"T001","title":"教授","updateTime":"2025-08-19 17:27:41"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 15:12:15', 5),
	(202, '教师信息', 2, 'com.course.college.controller.TeacherController.edit()', 'PUT', 1, 'admin', '教务处', '/college/teacher', '127.0.0.1', '内网IP', '{"contact":"13644332211","createTime":"2025-08-19 17:27:41","department":"商学院","gender":"女","teacherId":4,"teacherName":"吴教授","teacherNo":"T004","title":"教授","updateTime":"2025-08-19 17:27:41"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:02:25', 15),
	(203, '教师信息', 2, 'com.course.college.controller.TeacherController.edit()', 'PUT', 1, 'admin', '教务处', '/college/teacher', '127.0.0.1', '内网IP', '{"contact":"13755667788","createTime":"2025-08-19 17:27:41","department":"商学院","gender":"男","teacherId":5,"teacherName":"郑老师","teacherNo":"T005","title":"副教授","updateTime":"2025-08-19 17:27:41"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:02:33', 7),
	(204, '教师信息', 2, 'com.course.college.controller.TeacherController.edit()', 'PUT', 1, 'admin', '教务处', '/college/teacher', '127.0.0.1', '内网IP', '{"contact":"13611223344","createTime":"2025-08-19 17:27:41","department":"计算机科学院","gender":"男","teacherId":3,"teacherName":"黄老师","teacherNo":"T003","title":"讲师","updateTime":"2025-08-19 17:27:41"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:02:42', 8),
	(205, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/10', '127.0.0.1', '内网IP', '[10]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:18:39', 35),
	(206, '课表管理', 3, 'com.course.college.controller.CourseScheduleController.remove()', 'DELETE', 1, 'admin', '教务处', '/schedule/schedule/11', '127.0.0.1', '内网IP', '[11]', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:18:48', 12),
	(207, '课表管理', 1, 'com.course.college.controller.CourseScheduleController.add()', 'POST', 1, 'admin', '教务处', '/schedule/schedule', '127.0.0.1', '内网IP', '{"classTime":"周一 1、2节、周三3、4节","classroom":"实验3楼503教室","courseName":"数据结构","currentStudents":0,"maxStudents":30,"scheduleId":13,"semester":"第二学期","teacherName":"陈教授","week":"星期一"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:21:34', 16),
	(208, '课表管理', 1, 'com.course.college.controller.CourseScheduleController.add()', 'POST', 1, 'admin', '教务处', '/schedule/schedule', '127.0.0.1', '内网IP', '{"classTime":"星期二5、6节","classroom":"3号实验楼403教室","courseName":"高等数学","currentStudents":0,"maxStudents":30,"scheduleId":14,"semester":"第二学期","teacherName":"林老师","week":"星期二"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:22:35', 9),
	(209, '课表管理', 2, 'com.course.college.controller.CourseScheduleController.edit()', 'PUT', 1, 'admin', '教务处', '/schedule/schedule', '127.0.0.1', '内网IP', '{"classTime":"星期二4、5节","classroom":"3号实验楼403教室","courseName":"高等数学","createTime":"2025-08-24 16:22:35","currentStudents":0,"deleted":0,"maxStudents":30,"scheduleId":14,"semester":"第二学期","teacherName":"林老师","updateTime":"2025-08-24 16:22:35","week":"星期二"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 16:23:14', 14),
	(210, '选课管理', 2, 'com.course.college.controller.CourseSelectionController.edit()', 'PUT', 1, 'admin', '教务处', '/selection/selection', '127.0.0.1', '内网IP', '{"score":"100","selectionId":12}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:14:56', 16),
	(211, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"statistics/index","createTime":"2025-08-24 10:00:07","icon":"wechat","isCache":"0","isFrame":"1","menuId":2033,"menuName":"数据统计","menuType":"C","orderNum":8,"params":{},"parentId":2007,"path":"statistics","perms":"statistics:data:view","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:16:35', 21),
	(212, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"course/course/index","createTime":"2025-08-24 10:00:00","icon":"shopping","isCache":"0","isFrame":"1","menuId":2026,"menuName":"课程管理","menuType":"C","orderNum":4,"params":{},"parentId":2007,"path":"course","perms":"course:course:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:17:18', 10),
	(213, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"college/teacher/index","createTime":"2025-08-24 14:09:32","icon":"peoples","isCache":"0","isFrame":"1","menuId":2060,"menuName":"教师管理","menuType":"C","orderNum":5,"params":{},"parentId":2007,"path":"teacher","perms":"college:teacher:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:17:36', 8),
	(214, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"history/selection/index","createTime":"2025-08-24 10:17:22","icon":"documentation","isCache":"0","isFrame":"1","menuId":2051,"menuName":"选课历史","menuType":"C","orderNum":6,"params":{},"parentId":2007,"path":"history/selection","perms":"history:selection:list","query":"","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:17:49', 8),
	(215, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"statistics/index","createTime":"2025-08-24 10:00:07","icon":"wechat","isCache":"0","isFrame":"1","menuId":2033,"menuName":"数据统计","menuType":"C","orderNum":7,"params":{},"parentId":2007,"path":"statistics","perms":"statistics:data:view","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:18:15', 10),
	(216, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"student/student/index","createTime":"2025-08-21 14:43:22","icon":"language","isCache":"0","isFrame":"1","menuId":2008,"menuName":"学生管理","menuType":"C","orderNum":4,"params":{},"parentId":2007,"path":"student","perms":"student:student:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:18:28', 8),
	(217, '菜单管理', 2, 'com.course.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '教务处', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"component":"course/course/index","createTime":"2025-08-24 10:00:00","icon":"shopping","isCache":"0","isFrame":"1","menuId":2026,"menuName":"课程管理","menuType":"C","orderNum":3,"params":{},"parentId":2007,"path":"course","perms":"course:course:list","routeName":"","status":"0","updateBy":"admin","visible":"0"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:18:36', 7),
	(218, '课程管理', 2, 'com.course.college.controller.CourseController.edit()', 'PUT', 1, 'admin', '教务处', '/course/course', '127.0.0.1', '内网IP', '{"courseId":5,"courseName":"操作系统","courseNo":"EE101","courseType":"必修课","createTime":"2025-08-19 17:27:41","credit":"4.0","deleted":0,"department":"商学院","hours":"64","updateTime":"2025-08-20 14:39:45"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:19:40', 10),
	(219, '课程管理', 2, 'com.course.college.controller.CourseController.edit()', 'PUT', 1, 'admin', '教务处', '/course/course', '127.0.0.1', '内网IP', '{"courseId":3,"courseName":"商务英语","courseNo":"EN101","courseType":"必修课","createTime":"2025-08-19 17:27:41","credit":"4.0","deleted":0,"department":"商学院","hours":"64","updateTime":"2025-08-20 14:39:45"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:19:56', 6),
	(220, '课表管理', 1, 'com.course.college.controller.CourseScheduleController.add()', 'POST', 1, 'admin', '教务处', '/schedule/schedule', '127.0.0.1', '内网IP', '{"classTime":"星期二1、2节","classroom":"3实验楼514教室","courseName":"人工智能导论","currentStudents":0,"maxStudents":30,"scheduleId":15,"semester":"第二学期","teacherName":"吴教授","week":"星期三"}', '{"msg":"操作成功","code":200}', 0, NULL, '2025-08-24 18:32:26', 13);

-- 导出  表 college-course.sys_post 结构
CREATE TABLE IF NOT EXISTS `sys_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='岗位信息表';

-- 正在导出表  college-course.sys_post 的数据：~4 rows (大约)
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, 'ceo', '董事长', 1, '0', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(2, 'se', '项目经理', 2, '0', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(3, 'hr', '人力资源', 3, '0', 'admin', '2025-08-19 17:28:42', '', NULL, ''),
	(4, 'user', '普通员工', 4, '0', 'admin', '2025-08-19 17:28:42', '', NULL, '');

-- 导出  表 college-course.sys_role 结构
CREATE TABLE IF NOT EXISTS `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色信息表';

-- 正在导出表  college-course.sys_role 的数据：~2 rows (大约)
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-08-19 17:28:42', '', NULL, '超级管理员'),
	(2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-08-19 17:28:42', '', NULL, '普通角色');

-- 导出  表 college-course.sys_role_dept 结构
CREATE TABLE IF NOT EXISTS `sys_role_dept` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和部门关联表';

-- 正在导出表  college-course.sys_role_dept 的数据：~3 rows (大约)
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES
	(2, 100),
	(2, 101),
	(2, 105);

-- 导出  表 college-course.sys_role_menu 结构
CREATE TABLE IF NOT EXISTS `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和菜单关联表';

-- 正在导出表  college-course.sys_role_menu 的数据：~107 rows (大约)
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
	(1, 2051),
	(1, 2052),
	(1, 2053),
	(1, 2054),
	(1, 2055),
	(1, 2060),
	(1, 2061),
	(1, 2062),
	(1, 2063),
	(1, 2064),
	(1, 2065),
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 100),
	(2, 101),
	(2, 102),
	(2, 103),
	(2, 104),
	(2, 105),
	(2, 106),
	(2, 107),
	(2, 108),
	(2, 109),
	(2, 110),
	(2, 111),
	(2, 112),
	(2, 113),
	(2, 114),
	(2, 115),
	(2, 116),
	(2, 117),
	(2, 500),
	(2, 501),
	(2, 1000),
	(2, 1001),
	(2, 1002),
	(2, 1003),
	(2, 1004),
	(2, 1005),
	(2, 1006),
	(2, 1007),
	(2, 1008),
	(2, 1009),
	(2, 1010),
	(2, 1011),
	(2, 1012),
	(2, 1013),
	(2, 1014),
	(2, 1015),
	(2, 1016),
	(2, 1017),
	(2, 1018),
	(2, 1019),
	(2, 1020),
	(2, 1021),
	(2, 1022),
	(2, 1023),
	(2, 1024),
	(2, 1025),
	(2, 1026),
	(2, 1027),
	(2, 1028),
	(2, 1029),
	(2, 1030),
	(2, 1031),
	(2, 1032),
	(2, 1033),
	(2, 1034),
	(2, 1035),
	(2, 1036),
	(2, 1037),
	(2, 1038),
	(2, 1039),
	(2, 1040),
	(2, 1041),
	(2, 1042),
	(2, 1043),
	(2, 1044),
	(2, 1045),
	(2, 1046),
	(2, 1047),
	(2, 1048),
	(2, 1049),
	(2, 1050),
	(2, 1051),
	(2, 1052),
	(2, 1053),
	(2, 1054),
	(2, 1055),
	(2, 1056),
	(2, 1057),
	(2, 1058),
	(2, 1059),
	(2, 1060),
	(2, 2051),
	(2, 2052),
	(2, 2053),
	(2, 2054),
	(2, 2055),
	(2, 2060),
	(2, 2061),
	(2, 2062),
	(2, 2063),
	(2, 2064),
	(2, 2065);

-- 导出  表 college-course.sys_user 结构
CREATE TABLE IF NOT EXISTS `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';

-- 正在导出表  college-course.sys_user 的数据：~2 rows (大约)
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
	(1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-08-24 18:30:37', '2025-08-19 17:28:41', 'admin', '2025-08-19 17:28:41', '', '2025-08-24 18:30:37', '管理员'),
	(2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-08-19 17:28:41', '2025-08-19 17:28:41', 'admin', '2025-08-19 17:28:41', '', NULL, '测试员');

-- 导出  表 college-course.sys_user_post 结构
CREATE TABLE IF NOT EXISTS `sys_user_post` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户与岗位关联表';

-- 正在导出表  college-course.sys_user_post 的数据：~2 rows (大约)
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES
	(1, 1),
	(2, 2);

-- 导出  表 college-course.sys_user_role 结构
CREATE TABLE IF NOT EXISTS `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户和角色关联表';

-- 正在导出表  college-course.sys_user_role 的数据：~2 rows (大约)
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
	(1, 1),
	(2, 2);

-- 导出  表 college-course.teacher 结构
CREATE TABLE IF NOT EXISTS `teacher` (
  `teacher_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '教师ID，主键',
  `teacher_no` varchar(20) NOT NULL COMMENT '教师编号，唯一标识',
  `teacher_name` varchar(50) NOT NULL COMMENT '教师姓名',
  `gender` enum('男','女') NOT NULL COMMENT '性别',
  `department` varchar(100) NOT NULL COMMENT '所属部门',
  `title` varchar(50) DEFAULT NULL COMMENT '职称',
  `contact` varchar(20) DEFAULT NULL COMMENT '联系方式',
  `create_time` timestamp NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '更新时间，自动更新',
  `deleted` tinyint(4) DEFAULT 0 COMMENT '删除标记，0-未删除，1-已删除',
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `teacher_no` (`teacher_no`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='教师信息表';

-- 正在导出表  college-course.teacher 的数据：~5 rows (大约)
INSERT INTO `teacher` (`teacher_id`, `teacher_no`, `teacher_name`, `gender`, `department`, `title`, `contact`, `create_time`, `update_time`, `deleted`) VALUES
	(1, 'T001', '陈教授', '男', '商学院', '教授', '13512345678', '2025-08-19 09:27:41', '2025-08-19 09:27:41', 0),
	(2, 'T002', '林老师', '女', '计算机学院', '副教授', '13587654321', '2025-08-19 09:27:41', '2025-08-19 09:27:41', 0),
	(3, 'T003', '黄老师', '男', '计算机科学院', '讲师', '13611223344', '2025-08-19 09:27:41', '2025-08-19 09:27:41', 0),
	(4, 'T004', '吴教授', '女', '商学院', '教授', '13644332211', '2025-08-19 09:27:41', '2025-08-19 09:27:41', 0),
	(5, 'T005', '郑老师', '男', '商学院', '副教授', '13755667788', '2025-08-19 09:27:41', '2025-08-19 09:27:41', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
