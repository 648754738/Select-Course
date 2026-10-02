package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.HistoryCourseSelection;
import com.course.college.domain.CourseSelection;

import java.util.List;

public interface IHistoryCourseSelectionService extends IService<HistoryCourseSelection> {
    
    /**
     * 查询选课历史记录列表
     */
    List<HistoryCourseSelection> selectHistoryCourseSelectionList(HistoryCourseSelection historyCourseSelection);

    /**
     * 根据ID查询选课历史记录
     */
    HistoryCourseSelection selectHistoryCourseSelectionById(Long selectionId);

    /**
     * 新增选课历史记录
     */
    boolean insertHistoryCourseSelection(HistoryCourseSelection historyCourseSelection);

    /**
     * 删除选课历史记录
     */
    boolean deleteHistoryCourseSelectionByIds(Long[] selectionIds);
    
    /**
     * 将取消的选课记录添加到历史记录中
     */
    boolean addCancelSelectionToHistory(CourseSelection courseSelection);
}