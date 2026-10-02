package com.course.college.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.course.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Course implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long courseId;
    
    @Excel(name = "课程编号")
    private String courseNo;
    
    @Excel(name = "课程名称")
    private String courseName;
    
    @Excel(name = "学分")
    private String credit;
    
    @Excel(name = "学时")
    private String hours;
    
    @Excel(name = "开课学院")
    private String department;
    
    @Excel(name = "课程类型")
    private String courseType;
    
    private String createTime;
    private String updateTime;
    
    @TableLogic
    private Long deleted;
}
