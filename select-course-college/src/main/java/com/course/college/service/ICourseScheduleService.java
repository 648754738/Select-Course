package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.CourseSchedule;

import java.util.List;

public interface ICourseScheduleService extends IService<CourseSchedule> {
    List<CourseSchedule> selectCourseScheduleList(CourseSchedule courseSchedule);

    CourseSchedule selectCourseScheduleByScheduleId(Long scheduleId);

    boolean insertCourseSchedule(CourseSchedule courseSchedule);

    boolean updateCourseSchedule(CourseSchedule courseSchedule);

    boolean deleteCourseScheduleByScheduleIds(Long[] scheduleIds);

    List<CourseSchedule>  selectCourseScheduleByCourseNameAndTeacherName(String courseName, String teacherName);

    /**
     * 根据学生选课情况自动排课
     * @param semester 学期
     * @return 排课结果
     */
    boolean generateScheduleFromSelections(String semester);
}
