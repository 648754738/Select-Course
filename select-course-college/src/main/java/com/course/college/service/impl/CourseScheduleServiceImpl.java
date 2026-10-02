package com.course.college.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.CourseSchedule;
import com.course.college.domain.CourseSelection;
import com.course.college.mapper.CourseScheduleMapper;
import com.course.college.service.ICourseScheduleService;
import com.course.college.service.ICourseSelectionService;
import com.course.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
public class CourseScheduleServiceImpl extends ServiceImpl<CourseScheduleMapper, CourseSchedule>
        implements ICourseScheduleService {

    @Autowired
    private ICourseSelectionService courseSelectionService;

    // 高校标准时间段
    private static final String[] TIME_SLOTS = {
        "周一1-2节", "周一3-4节", "周一5-6节", "周一7-8节", "周一9-10节",
        "周二1-2节", "周二3-4节", "周二5-6节", "周二7-8节", "周二9-10节",
        "周三1-2节", "周三3-4节", "周三5-6节", "周三7-8节", "周三9-10节",
        "周四1-2节", "周四3-4节", "周四5-6节", "周四7-8节", "周四9-10节",
        "周五1-2节", "周五3-4节", "周五5-6节", "周五7-8节", "周五9-10节"
    };

    // 教室列表
    private static final String[] CLASSROOMS = {
        "A101", "A102", "A103", "A104", "A105", "A106", "A107", "A108",
        "B101", "B102", "B103", "B104", "B105", "B106", "B107", "B108",
        "C101", "C102", "C103", "C104", "C105", "C106", "C107", "C108"
    };

    @Override
    public List<CourseSchedule> selectCourseScheduleByCourseNameAndTeacherName(String courseName, String teacherName) {
        // 参数校验
        if (courseName == null || teacherName == null) {
            return new ArrayList<>();
        }

        LambdaQueryWrapper<CourseSchedule> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(CourseSchedule::getCourseName, courseName);
        lambdaQueryWrapper.eq(CourseSchedule::getTeacherName, teacherName);

        try {
            return list(lambdaQueryWrapper);
        } catch (Exception e) {
            // 记录异常日志（实际项目中应该使用日志框架）
            return new ArrayList<>();
        }
    }

    @Override
    public CourseSchedule selectCourseScheduleByScheduleId(Long scheduleId) {
        return getById(scheduleId);
    }

    @Override
    public List<CourseSchedule> selectCourseScheduleList(CourseSchedule courseSchedule) {
        LambdaQueryWrapper<CourseSchedule> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(courseSchedule.getCourseName()),
                CourseSchedule::getCourseName, courseSchedule.getCourseName());
        queryWrapper.like(StringUtils.isNotEmpty(courseSchedule.getTeacherName()),
                CourseSchedule::getTeacherName, courseSchedule.getTeacherName());
        queryWrapper.like(StringUtils.isNotEmpty(courseSchedule.getClassroom()),
                CourseSchedule::getClassroom, courseSchedule.getClassroom());
        queryWrapper.eq(StringUtils.isNotEmpty(courseSchedule.getSemester()),
                CourseSchedule::getSemester, courseSchedule.getSemester());
        queryWrapper.eq(StringUtils.isNotEmpty(courseSchedule.getWeek()),
                CourseSchedule::getWeek, courseSchedule.getWeek());
        return list(queryWrapper);
    }

    @Override
    public boolean insertCourseSchedule(CourseSchedule courseSchedule) {
        // 可以添加业务逻辑验证，比如时间冲突检查、教室占用检查等
        if (courseSchedule.getCurrentStudents() == null) {
            courseSchedule.setCurrentStudents(0L);
        }
        return save(courseSchedule);
    }

    @Override
    public boolean updateCourseSchedule(CourseSchedule courseSchedule) {
        return updateById(courseSchedule);
    }

    @Override
    public boolean deleteCourseScheduleByScheduleIds(Long[] scheduleIds) {
        return removeBatchByIds(Arrays.asList(scheduleIds));
    }

    /**
     * 根据学生选课情况自动排课
     */
    @Override
    @Transactional
    public boolean generateScheduleFromSelections(String semester) {
        try {
            // 1. 获取所有选课记录
            List<CourseSelection> allSelections = courseSelectionService.list();
            if (allSelections == null || allSelections.isEmpty()) {
                throw new RuntimeException("暂无学生选课记录，无法进行自动排课。请确保学生已完成选课后再进行排课。");
            }

            // 2. 按课程名和教师分组统计需求
            Map<String, CourseRequirement> courseRequirements = analyzeCourseRequirements(allSelections);
            
            if (courseRequirements.isEmpty()) {
                throw new RuntimeException("选课数据分析失败，无有效的课程需求。");
            }

            // 3. 检查并清理指定学期的重复课表
            removeExistingSchedules(semester, courseRequirements.keySet());

            // 4. 使用贪心算法分配时间和教室
            List<CourseSchedule> generatedSchedules = allocateTimeAndClassroom(courseRequirements, semester);

            // 5. 保存生成的课表
            if (!generatedSchedules.isEmpty()) {
                boolean result = saveBatch(generatedSchedules);
                if (result) {
                    // 记录成功排课的信息
                    System.out.println("自动排课成功，共生成 " + generatedSchedules.size() + " 门课程的课表安排");
                }
                return result;
            } else {
                throw new RuntimeException("无法为任何课程分配合适的时间和教室，可能是时间冲突或教室不足。");
            }
        } catch (RuntimeException e) {
            // 重新抛出业务异常
            throw e;
        } catch (Exception e) {
            // 记录日志并抛出新的业务异常
            e.printStackTrace();
            throw new RuntimeException("自动排课过程中发生系统错误：" + e.getMessage());
        }
    }

    /**
     * 分析课程需求
     */
    private Map<String, CourseRequirement> analyzeCourseRequirements(List<CourseSelection> selections) {
        Map<String, CourseRequirement> requirements = new HashMap<>();

        for (CourseSelection selection : selections) {
            // 数据验证
            if (selection == null || 
                StringUtils.isEmpty(selection.getCourseName()) || 
                StringUtils.isEmpty(selection.getTeacherName())) {
                continue; // 跳过无效数据
            }

            String key = selection.getCourseName().trim() + "_" + selection.getTeacherName().trim();
            CourseRequirement requirement = requirements.getOrDefault(key, 
                new CourseRequirement(selection.getCourseName().trim(), selection.getTeacherName().trim()));
            
            requirement.addStudent();
            requirements.put(key, requirement);
        }

        return requirements;
    }

    /**
     * 分配时间和教室
     */
    private List<CourseSchedule> allocateTimeAndClassroom(Map<String, CourseRequirement> requirements, String semester) {
        List<CourseSchedule> schedules = new ArrayList<>();
        Set<String> usedTimeSlots = new HashSet<>();
        Set<String> usedClassrooms = new HashSet<>();
        Map<String, Set<String>> teacherTimeSlots = new HashMap<>();

        // 查询已存在的课表，避免时间和教室冲突
        initializeUsedResources(semester, usedTimeSlots, usedClassrooms, teacherTimeSlots);

        // 按需求人数降序排序，优先安排选课人数多的课程
        List<CourseRequirement> sortedRequirements = requirements.values().stream()
                .sorted((a, b) -> Integer.compare(b.getStudentCount(), a.getStudentCount()))
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);

        int successCount = 0;
        int failCount = 0;

        for (CourseRequirement requirement : sortedRequirements) {
            // 为每门课找合适的时间段
            String assignedTimeSlot = findAvailableTimeSlot(
                requirement.getTeacherName(), 
                usedTimeSlots, 
                teacherTimeSlots
            );

            if (assignedTimeSlot != null) {
                // 分配教室
                String assignedClassroom = findAvailableClassroom(assignedTimeSlot, usedClassrooms);
                
                if (assignedClassroom != null) {
                    // 创建课表记录
                    CourseSchedule schedule = createSchedule(
                        requirement, 
                        assignedTimeSlot, 
                        assignedClassroom, 
                        semester
                    );
                    
                    schedules.add(schedule);
                    successCount++;
                    
                    // 更新已使用资源
                    String timeClassroomKey = assignedTimeSlot + "_" + assignedClassroom;
                    usedTimeSlots.add(timeClassroomKey);
                    usedClassrooms.add(timeClassroomKey);
                    teacherTimeSlots.computeIfAbsent(requirement.getTeacherName(), k -> new HashSet<>())
                                   .add(assignedTimeSlot);
                } else {
                    failCount++;
                    System.err.println("无法为课程 " + requirement.getCourseName() + 
                        "(教师：" + requirement.getTeacherName() + ") 分配教室");
                }
            } else {
                failCount++;
                System.err.println("无法为教师 " + requirement.getTeacherName() + 
                    " 的课程 " + requirement.getCourseName() + " 分配时间段");
            }
        }

        System.out.println("排课结果：成功 " + successCount + " 门，失败 " + failCount + " 门");
        return schedules;
    }

    /**
     * 初始化已使用的资源
     */
    private void initializeUsedResources(String semester, Set<String> usedTimeSlots, 
                                        Set<String> usedClassrooms, Map<String, Set<String>> teacherTimeSlots) {
        try {
            // 查询已存在的课表
            LambdaQueryWrapper<CourseSchedule> queryWrapper = new LambdaQueryWrapper<>();
            if (StringUtils.isNotEmpty(semester)) {
                queryWrapper.eq(CourseSchedule::getSemester, semester);
            }
            List<CourseSchedule> existingSchedules = list(queryWrapper);

            for (CourseSchedule schedule : existingSchedules) {
                if (schedule.getClassTime() != null && schedule.getClassroom() != null) {
                    String timeClassroomKey = schedule.getClassTime() + "_" + schedule.getClassroom();
                    usedTimeSlots.add(timeClassroomKey);
                    usedClassrooms.add(timeClassroomKey);
                    
                    // 记录教师的时间占用
                    if (schedule.getTeacherName() != null) {
                        teacherTimeSlots.computeIfAbsent(schedule.getTeacherName(), k -> new HashSet<>())
                                       .add(schedule.getClassTime());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("初始化已使用资源失败：" + e.getMessage());
        }
    }

    /**
     * 寻找可用时间段
     */
    private String findAvailableTimeSlot(String teacherName, Set<String> usedTimeSlots, 
                                         Map<String, Set<String>> teacherTimeSlots) {
        Set<String> teacherUsedSlots = teacherTimeSlots.getOrDefault(teacherName, new HashSet<>());
        
        for (String timeSlot : TIME_SLOTS) {
            if (!teacherUsedSlots.contains(timeSlot)) {
                return timeSlot;
            }
        }
        
        return null;
    }

    /**
     * 寻找可用教室
     */
    private String findAvailableClassroom(String timeSlot, Set<String> usedClassrooms) {
        for (String classroom : CLASSROOMS) {
            String timeClassroomKey = timeSlot + "_" + classroom;
            if (!usedClassrooms.contains(timeClassroomKey)) {
                return classroom;
            }
        }
        
        return null;
    }

    /**
     * 创建课表记录
     */
    private CourseSchedule createSchedule(CourseRequirement requirement, String timeSlot, 
                                         String classroom, String semester) {
        CourseSchedule schedule = new CourseSchedule();
        schedule.setCourseName(requirement.getCourseName());
        schedule.setTeacherName(requirement.getTeacherName());
        schedule.setClassTime(timeSlot);
        schedule.setClassroom(classroom);
        schedule.setMaxStudents((long) Math.max(requirement.getStudentCount() + 5, 30)); // 预留5个名额
        schedule.setCurrentStudents((long) requirement.getStudentCount());
        schedule.setSemester(semester != null ? semester : "第一学期");
        
        // 从时间段中提取星期
        String week = extractWeekFromTimeSlot(timeSlot);
        schedule.setWeek(week);
        
        return schedule;
    }

    /**
     * 从时间段提取星期
     */
    private String extractWeekFromTimeSlot(String timeSlot) {
        if (timeSlot.startsWith("周一")) return "星期一";
        if (timeSlot.startsWith("周二")) return "星期二";
        if (timeSlot.startsWith("周三")) return "星期三";
        if (timeSlot.startsWith("周四")) return "星期四";
        if (timeSlot.startsWith("周五")) return "星期五";
        return "星期一"; // 默认值
    }

    /**
     * 清理指定学期的重复课表
     * @param semester 学期
     * @param courseKeys 课程键值集合（课程名_教师名）
     */
    private void removeExistingSchedules(String semester, Set<String> courseKeys) {
        if (semester == null || courseKeys == null || courseKeys.isEmpty()) {
            return;
        }

        try {
            // 查找已存在的课表记录
            LambdaQueryWrapper<CourseSchedule> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(CourseSchedule::getSemester, semester);
            
            List<CourseSchedule> existingSchedules = list(queryWrapper);
            
            if (!existingSchedules.isEmpty()) {
                // 筛选出需要删除的重复课表
                List<Long> scheduleIdsToDelete = new ArrayList<>();
                
                for (CourseSchedule schedule : existingSchedules) {
                    String courseKey = schedule.getCourseName() + "_" + schedule.getTeacherName();
                    if (courseKeys.contains(courseKey)) {
                        scheduleIdsToDelete.add(schedule.getScheduleId());
                    }
                }
                
                // 批量删除重复课表
                if (!scheduleIdsToDelete.isEmpty()) {
                    removeByIds(scheduleIdsToDelete);
                    System.out.println("已清理 " + scheduleIdsToDelete.size() + " 条重复课表记录");
                }
            }
        } catch (Exception e) {
            System.err.println("清理重复课表失败：" + e.getMessage());
            // 不抛出异常，继续执行排课逻辑
        }
    }

    /**
     * 课程需求内部类
     */
    private static class CourseRequirement {
        private String courseName;
        private String teacherName;
        private int studentCount;

        public CourseRequirement(String courseName, String teacherName) {
            this.courseName = courseName;
            this.teacherName = teacherName;
            this.studentCount = 0;
        }

        public void addStudent() {
            this.studentCount++;
        }

        // Getters
        public String getCourseName() { return courseName; }
        public String getTeacherName() { return teacherName; }
        public int getStudentCount() { return studentCount; }
    }
}
