package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.Course;

import java.util.List;

public interface ICourseService extends IService<Course> {
    List<Course> selectCourseList(Course course);

    String selectCourseByCourseId(Long courseId);

    boolean deleteCourseByCourseIds(Long[] courseIds);

    boolean updateCourse(Course course);

    boolean insertCourse(Course course);

    /**
     * 验证课程名称是否存在
     * @param courseName 课程名称
     * @return true-存在, false-不存在
     */
    boolean existsByCourseName(String courseName);
}
