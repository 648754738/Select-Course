package com.course.college.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.course.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 学生管理对象 student
 *
 * @author 席老师
 * @date 2025-08-21
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long studentId;
    @Excel(name = "学号")
    private String studentNo;
    @Excel(name = "学生姓名")
    private String studentName;
    @Excel(name = "性别")
    private String gender;
    @Excel(name = "专业")
    private String major;
    @Excel(name = "年级")
    private String grade;
    @Excel(name = "联系方式")
    private String contact;
    @Excel(name = "学院名称")
    private String collegeName;
    @TableField(exist = false)
    private Long deptId;
    private String createTime;
    private String updateTime;
    @TableLogic
    private Long deleted;

}
