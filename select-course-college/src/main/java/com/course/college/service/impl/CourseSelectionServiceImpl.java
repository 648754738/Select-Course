package com.course.college.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.CourseSchedule;
import com.course.college.domain.CourseSelection;
import com.course.college.mapper.CourseSelectionMapper;
import com.course.college.service.ICourseScheduleService;
import com.course.college.service.ICourseSelectionService;
import com.course.college.service.IHistoryCourseSelectionService;
import com.course.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

@Service
public class CourseSelectionServiceImpl extends ServiceImpl<CourseSelectionMapper, CourseSelection>
        implements ICourseSelectionService {

    @Autowired
    private IHistoryCourseSelectionService historyCourseSelectionService;
    @Autowired
    private ICourseScheduleService courseScheduleService;

    @Override
    public CourseSelection selectCourseSelectionBySelectionId(Long selectionId) {
        return getById(selectionId);
    }

    @Override
    public List<CourseSelection> selectCourseSelectionList(CourseSelection courseSelection) {
        LambdaQueryWrapper<CourseSelection> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(courseSelection.getCourseName()),
                CourseSelection::getCourseName, courseSelection.getCourseName());
        queryWrapper.like(StringUtils.isNotEmpty(courseSelection.getStudentName()),
                CourseSelection::getStudentName, courseSelection.getStudentName());
        return list(queryWrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insertCourseSelection(CourseSelection courseSelection) {
        // 1. 验证学生是否已经选过该课程
        LambdaQueryWrapper<CourseSelection> existQuery = new LambdaQueryWrapper<>();
        existQuery.eq(CourseSelection::getStudentName, courseSelection.getStudentName());
        existQuery.eq(CourseSelection::getCourseName, courseSelection.getCourseName());
        long existCount = count(existQuery);
        if (existCount > 0) {
            throw new RuntimeException("该学生已经选过此课程，不能重复选课");
        }

        // 2. 根据选课课程名称和老师获得课表对象
        List<CourseSchedule> scheduleList = courseScheduleService.selectCourseScheduleByCourseNameAndTeacherName(
                courseSelection.getCourseName(), courseSelection.getTeacherName());
        
        if (scheduleList == null || scheduleList.isEmpty()) {
            throw new RuntimeException("未找到对应的课程安排信息");
        }

        // 3. 检查时间冲突
        if (hasTimeConflict(courseSelection.getStudentName(), scheduleList)) {
            throw new RuntimeException("选课时间与已选课程存在冲突");
        }

        // 4. 检查选课人数限制并更新
        boolean courseUpdated = false;
        for (CourseSchedule courseSchedule : scheduleList) {
            if (courseSchedule.getCurrentStudents() < courseSchedule.getMaxStudents()) {
                courseSchedule.setCurrentStudents(courseSchedule.getCurrentStudents() + 1);
                courseScheduleService.updateById(courseSchedule);
                courseUpdated = true;
                break; // 找到第一个可选的课表后就跳出循环
            }
        }
        
        if (!courseUpdated) {
            throw new RuntimeException("该课程选课人数已满，无法选课");
        }

        // 5. 设置创建时间并保存选课记录
        if (courseSelection.getCreateTime() == null || courseSelection.getCreateTime().trim().isEmpty()) {
            // 使用当前时间作为创建时间
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            courseSelection.setCreateTime(sdf.format(new java.util.Date()));
        }
        return save(courseSelection);
    }

    /**
     * 检查时间冲突
     * @param studentName 学生姓名
     * @param newScheduleList 新选课程的课表列表
     * @return 是否存在时间冲突
     */
    private boolean hasTimeConflict(String studentName, List<CourseSchedule> newScheduleList) {
        // 获取该学生已选的所有课程
        LambdaQueryWrapper<CourseSelection> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(CourseSelection::getStudentName, studentName);
        List<CourseSelection> existingSelections = list(queryWrapper);

        // 如果没有已选课程，不会有冲突
        if (existingSelections.isEmpty()) {
            return false;
        }

        // 获取已选课程的所有课表
        for (CourseSelection existingSelection : existingSelections) {
            List<CourseSchedule> existingSchedules = courseScheduleService
                    .selectCourseScheduleByCourseNameAndTeacherName(
                            existingSelection.getCourseName(), 
                            existingSelection.getTeacherName());
            
            // 检查新课表与已有课表的时间冲突
            for (CourseSchedule newSchedule : newScheduleList) {
                for (CourseSchedule existingSchedule : existingSchedules) {
                    if (isTimeConflict(newSchedule, existingSchedule)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * 检查两个课表是否存在时间冲突
     * @param schedule1 课表1
     * @param schedule2 课表2
     * @return 是否冲突
     */
    private boolean isTimeConflict(CourseSchedule schedule1, CourseSchedule schedule2) {
        // 简化的时间冲突检测：同一星期、同一学期的课程认为可能冲突
        // 实际项目中应该解析classTime字段进行更精确的时间比较
        return schedule1.getWeek().equals(schedule2.getWeek()) && 
               schedule1.getSemester().equals(schedule2.getSemester()) &&
               schedule1.getClassTime().equals(schedule2.getClassTime());
    }


    @Override
    public boolean updateCourseSelection(CourseSelection courseSelection) {
        return updateById(courseSelection);
    }


    /**
     * 取消选课让课表人数减一
     *
     * @param selectionIds
     * @return
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteCourseSelectionBySelectionIds(Long[] selectionIds) {
        // 1. 获取要删除的选课记录
        LambdaQueryWrapper<CourseSelection> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(CourseSelection::getSelectionId, selectionIds);
        List<CourseSelection> courseSelections = list(queryWrapper);
        
        if (courseSelections.isEmpty()) {
            return false;
        }
        
        // 2. 为每个选课记录执行取消操作
        for (CourseSelection courseSelection : courseSelections) {
            try {
                // 2.1 将取消的选课记录添加到历史记录中
                historyCourseSelectionService.addCancelSelectionToHistory(courseSelection);
                
                // 2.2 更新课表人数（减1）
                updateCourseScheduleStudentCount(courseSelection, -1);
                
            } catch (Exception e) {
                throw new RuntimeException("取消选课失败：" + e.getMessage(), e);
            }
        }
        
        // 3. 删除原始选课记录
        return removeBatchByIds(Arrays.asList(selectionIds));
    }

    @Override
    public java.util.Map<String, Integer> getWeeklySelectionStatistics() {
        java.util.Map<String, Integer> weeklyStats = new java.util.LinkedHashMap<>();
        
        // 计算近7天的日期范围
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        // 初始化近7天的统计数据
        for (int i = 6; i >= 0; i--) {
            java.time.LocalDate date = today.minusDays(i);
            String dateStr = date.format(formatter);
            weeklyStats.put(dateStr, 0);
        }
        
        try {
            // 查询所有选课记录
            List<CourseSelection> allSelections = list();
            
            // 统计每天的选课数量
            for (CourseSelection selection : allSelections) {
                if (selection.getCreateTime() != null && !selection.getCreateTime().trim().isEmpty()) {
                    try {
                        // 处理createTime，可能是完整的日期时间格式
                        String createTime = selection.getCreateTime().trim();
                        String dateOnly;
                        
                        // 如果包含空格，取空格前的日期部分
                        if (createTime.contains(" ")) {
                            dateOnly = createTime.split(" ")[0];
                        } else if (createTime.length() >= 10) {
                            // 如果长度足够，取前10位作为日期
                            dateOnly = createTime.substring(0, 10);
                        } else {
                            dateOnly = createTime;
                        }
                        
                        // 检查日期是否在近7天范围内
                        if (weeklyStats.containsKey(dateOnly)) {
                            weeklyStats.put(dateOnly, weeklyStats.get(dateOnly) + 1);
                        }
                    } catch (Exception e) {
                        // 如果日期解析失败，跳过该记录
                        System.err.println("日期解析失败: " + selection.getCreateTime() + ", 错误: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("获取选课统计数据失败: " + e.getMessage());
        }
        
        return weeklyStats;
    }
    
    /**
     * 更新课表中的学生人数
     * @param courseSelection 选课记录
     * @param countChange 人数变化量（+1或-1）
     */
    private void updateCourseScheduleStudentCount(CourseSelection courseSelection, int countChange) {
        List<CourseSchedule> scheduleList = courseScheduleService.selectCourseScheduleByCourseNameAndTeacherName(
                courseSelection.getCourseName(), courseSelection.getTeacherName());
        
        if (scheduleList != null && !scheduleList.isEmpty()) {
            for (CourseSchedule courseSchedule : scheduleList) {
                Long newCount = courseSchedule.getCurrentStudents() + countChange;
                // 确保人数不为负数
                if (newCount >= 0) {
                    courseSchedule.setCurrentStudents(newCount);
                    courseScheduleService.updateById(courseSchedule);
                }
            }
        }
    }


}
