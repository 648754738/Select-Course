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
public class CourseSchedule implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long scheduleId;
    
    @Excel(name = "课程名称")
    private String courseName;
    
    @Excel(name = "教师姓名")
    private String teacherName;
    
    @Excel(name = "上课时间")
    private String classTime;
    
    @Excel(name = "教室")
    private String classroom;
    
    @Excel(name = "最大人数")
    private Long maxStudents;
    
    @Excel(name = "当前人数")
    private Long currentStudents;
    
    @Excel(name = "学期")
    private String semester;
    
    private String createTime;
    private String updateTime;
    
    @TableLogic
    private Long deleted;
    
    @Excel(name = "星期")
    private String week;
}
