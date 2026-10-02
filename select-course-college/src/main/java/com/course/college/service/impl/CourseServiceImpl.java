package com.course.college.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.Course;
import com.course.college.mapper.CourseMapper;
import com.course.college.service.ICourseService;
import com.course.common.utils.StringUtils;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements ICourseService {

    @Override
    public List<Course> selectCourseList(Course course) {
        LambdaQueryWrapper<Course> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(course.getCourseName()),
                Course::getCourseName, course.getCourseName());
        queryWrapper.like(StringUtils.isNotEmpty(course.getCourseNo()),
                Course::getCourseNo, course.getCourseNo());
        queryWrapper.like(StringUtils.isNotEmpty(course.getDepartment()),
                Course::getDepartment, course.getDepartment());
        queryWrapper.eq(StringUtils.isNotEmpty(course.getCourseType()),
                Course::getCourseType, course.getCourseType());
        return list(queryWrapper);
    }

    @Override
    public boolean insertCourse(Course course) {
        // 可以在这里添加业务逻辑校验，比如课程编号唯一性检查
        return save(course);
    }

    @Override
    public boolean updateCourse(Course course) {
        return updateById(course);
    }

    @Override
    public boolean deleteCourseByCourseIds(Long[] courseIds) {
        return removeBatchByIds(Arrays.asList(courseIds));
    }

    @Override
    public String selectCourseByCourseId(Long courseId) {
        Course course = getById(courseId);
        return course != null ? course.getCourseName() : "";
    }

    @Override
    public boolean existsByCourseName(String courseName) {
        if (StringUtils.isEmpty(courseName)) {
            return false;
        }
        LambdaQueryWrapper<Course> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Course::getCourseName, courseName.trim());
        return count(queryWrapper) > 0;
    }
}
