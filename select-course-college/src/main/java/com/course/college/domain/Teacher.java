package com.course.college.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.course.common.annotation.Excel;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

/**
 * 教师信息对象 teacher
 * 
 * @author course
 * @date 2025-08-24
 */
@TableName("teacher")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Teacher implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 教师ID，主键 */
    @TableId(value = "teacher_id", type = IdType.AUTO)
    private Long teacherId;

    /** 教师编号，唯一标识 */
    @Excel(name = "教师编号")
    private String teacherNo;

    /** 教师姓名 */
    @Excel(name = "教师姓名")
    private String teacherName;

    /** 性别 */
    @Excel(name = "性别")
    private String gender;

    /** 所属部门 */
    @Excel(name = "所属部门")
    private String department;

    /** 职称 */
    @Excel(name = "职称")
    private String title;

    /** 联系方式 */
    @Excel(name = "联系方式")
    private String contact;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
    /** 删除标记，0-未删除，1-已删除 */
    @TableLogic
    private Integer deleted;


}