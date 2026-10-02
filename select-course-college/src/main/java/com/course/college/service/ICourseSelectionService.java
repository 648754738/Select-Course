package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.CourseSelection;

import java.util.List;


public interface ICourseSelectionService extends IService<CourseSelection> {

    List<CourseSelection> selectCourseSelectionList(CourseSelection courseSelection);

    CourseSelection selectCourseSelectionBySelectionId(Long selectionId);

    boolean insertCourseSelection(CourseSelection courseSelection);

    boolean updateCourseSelection(CourseSelection courseSelection);

    boolean deleteCourseSelectionBySelectionIds(Long[] selectionIds);

    /**
     * 获取近一周选课统计数据
     * @return Map<String, Integer> 键为日期，值为当天选课人数
     */
    java.util.Map<String, Integer> getWeeklySelectionStatistics();
}
