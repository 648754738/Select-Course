package com.course.college.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.course.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@Data
@AllArgsConstructor
@NoArgsConstructor

public class CourseSelection  implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long selectionId;
    @Excel(name = "学号")
    private String studentNo;
    @Excel(name = "学生姓名")
    private String studentName;
    @Excel(name = "课程名称")
    private String courseName;
    @Excel(name = "教师名称")
    private String teacherName;
    @Excel(name = "选课时间")
    private String selectTime;
    @Excel(name = "成绩")
    private String score;
    private String createTime;
    private String updateTime;

}
