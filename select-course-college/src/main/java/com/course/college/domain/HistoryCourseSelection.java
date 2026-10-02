package com.course.college.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.course.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 选课历史记录对象 history_course_selection
 *
 * @author 席老师
 * @date 2025-08-24
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class HistoryCourseSelection implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long selectionId;
    
    @Excel(name = "学号")
    private String studentNo;
    
    @Excel(name = "学生姓名")
    private String studentName;
    
    @Excel(name = "课程名称")
    private String courseName;
    
    @Excel(name = "选课时间")
    private String selectTime;
    
    @Excel(name = "教师姓名")
    private String teacherName;
    
    @Excel(name = "成绩")
    private String score;
    
    private String createTime;
    
    private String updateTime;
    
    @Excel(name = "取消时间")
    private String cancelTime;
    
    @Excel(name = "操作类型")
    private String operationType;
}