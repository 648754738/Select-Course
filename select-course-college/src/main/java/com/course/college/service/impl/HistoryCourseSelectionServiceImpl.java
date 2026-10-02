package com.course.college.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.CourseSelection;
import com.course.college.domain.HistoryCourseSelection;
import com.course.college.mapper.HistoryCourseSelectionMapper;
import com.course.college.service.IHistoryCourseSelectionService;
import com.course.common.utils.DateUtils;
import com.course.common.utils.StringUtils;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class HistoryCourseSelectionServiceImpl extends ServiceImpl<HistoryCourseSelectionMapper, HistoryCourseSelection> 
        implements IHistoryCourseSelectionService {

    @Override
    public List<HistoryCourseSelection> selectHistoryCourseSelectionList(HistoryCourseSelection historyCourseSelection) {
        LambdaQueryWrapper<HistoryCourseSelection> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(historyCourseSelection.getStudentName()),
                HistoryCourseSelection::getStudentName, historyCourseSelection.getStudentName());
        queryWrapper.like(StringUtils.isNotEmpty(historyCourseSelection.getStudentNo()),
                HistoryCourseSelection::getStudentNo, historyCourseSelection.getStudentNo());
        queryWrapper.like(StringUtils.isNotEmpty(historyCourseSelection.getCourseName()),
                HistoryCourseSelection::getCourseName, historyCourseSelection.getCourseName());
        queryWrapper.like(StringUtils.isNotEmpty(historyCourseSelection.getTeacherName()),
                HistoryCourseSelection::getTeacherName, historyCourseSelection.getTeacherName());
        queryWrapper.eq(StringUtils.isNotEmpty(historyCourseSelection.getOperationType()),
                HistoryCourseSelection::getOperationType, historyCourseSelection.getOperationType());
        
        // 按取消时间降序排序
        queryWrapper.orderByDesc(HistoryCourseSelection::getCancelTime);
        
        return list(queryWrapper);
    }

    @Override
    public HistoryCourseSelection selectHistoryCourseSelectionById(Long selectionId) {
        return getById(selectionId);
    }

    @Override
    public boolean insertHistoryCourseSelection(HistoryCourseSelection historyCourseSelection) {
        return save(historyCourseSelection);
    }

    @Override
    public boolean deleteHistoryCourseSelectionByIds(Long[] selectionIds) {
        return removeBatchByIds(Arrays.asList(selectionIds));
    }
    
    @Override
    public boolean addCancelSelectionToHistory(CourseSelection courseSelection) {
        HistoryCourseSelection historyRecord = new HistoryCourseSelection();
        
        // 复制原选课记录的数据
        historyRecord.setStudentNo(courseSelection.getStudentNo());
        historyRecord.setStudentName(courseSelection.getStudentName());
        historyRecord.setCourseName(courseSelection.getCourseName());
        historyRecord.setTeacherName(courseSelection.getTeacherName());
        historyRecord.setSelectTime(courseSelection.getSelectTime());
        historyRecord.setScore(courseSelection.getScore());
        
        // 确保时间字段为正确的字符串格式
        String currentTime = DateUtils.getTime();
        historyRecord.setCreateTime(currentTime);
        historyRecord.setUpdateTime(currentTime);
        
        // 设置取消相关字段
        historyRecord.setCancelTime(currentTime);
        historyRecord.setOperationType("取消选课");
        
        return insertHistoryCourseSelection(historyRecord);
    }
}