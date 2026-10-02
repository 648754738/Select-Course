package com.course.college.controller;

import com.course.college.domain.CourseSchedule;
import com.course.college.service.ICourseScheduleService;
import com.course.common.annotation.Log;
import com.course.common.core.controller.BaseController;
import com.course.common.core.domain.AjaxResult;
import com.course.common.core.page.TableDataInfo;
import com.course.common.enums.BusinessType;
import com.course.common.utils.poi.ExcelUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 课表管理Controller
 *
 * @author 席老师
 * @date 2025-08-22
 */
@RestController
@RequestMapping("/schedule/schedule")
public class CourseScheduleController extends BaseController {
    @Autowired
    private ICourseScheduleService courseScheduleService;

    /**
     * 查询老师课表排课信息
     *
     * @return
     */
    @GetMapping("/getCourseScheduleTeacherName")

    public AjaxResult getCourseScheduleTeacherName() {
        return success(courseScheduleService.list());
    }

    /**
     * 查询课表管理列表
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:list')")
    @GetMapping("/list")
    public TableDataInfo list(CourseSchedule courseSchedule) {
        startPage();
        List<CourseSchedule> list = courseScheduleService.selectCourseScheduleList(courseSchedule);
        return getDataTable(list);
    }

    /**
     * 导出课表管理列表
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:export')")
    @Log(title = "课表管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CourseSchedule courseSchedule) {
        List<CourseSchedule> list = courseScheduleService.selectCourseScheduleList(courseSchedule);
        ExcelUtil<CourseSchedule> util = new ExcelUtil<CourseSchedule>(CourseSchedule.class);
        util.exportExcel(response, list, "课表管理数据");
    }

    /**
     * 获取课表管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:query')")
    @GetMapping(value = "/{scheduleId}")
    public AjaxResult getInfo(@PathVariable("scheduleId") Long scheduleId) {
        return success(courseScheduleService.selectCourseScheduleByScheduleId(scheduleId));
    }

    /**
     * 新增课表管理
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:add')")
    @Log(title = "课表管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CourseSchedule courseSchedule) {
        return toAjax(courseScheduleService.insertCourseSchedule(courseSchedule));
    }

    /**
     * 修改课表管理
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:edit')")
    @Log(title = "课表管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CourseSchedule courseSchedule) {
        return toAjax(courseScheduleService.updateCourseSchedule(courseSchedule));
    }

    /**
     * 删除课表管理
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:remove')")
    @Log(title = "课表管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{scheduleIds}")
    public AjaxResult remove(@PathVariable Long[] scheduleIds) {
        return toAjax(courseScheduleService.deleteCourseScheduleByScheduleIds(scheduleIds));
    }

    /**
     * 根据学生选课情况自动排课
     */
    @PreAuthorize("@ss.hasPermi('schedule:schedule:add')")
    @Log(title = "自动排课", businessType = BusinessType.INSERT)
    @PostMapping("/generateSchedule")
    public AjaxResult generateSchedule(@RequestParam(value = "semester", required = false) String semester) {
        try {
            // 参数验证
            if (semester == null || semester.trim().isEmpty()) {
                semester = "第一学期"; // 默认学期
            }
            
            boolean result = courseScheduleService.generateScheduleFromSelections(semester.trim());
            if (result) {
                return success("自动排课成功！已根据学生选课情况生成 " + semester + " 的课表安排。请刷新页面查看最新课表。");
            } else {
                return error("自动排课失败，未知错误。");
            }
        } catch (RuntimeException e) {
            // 业务异常，返回用户友好的错误信息
            return error(e.getMessage());
        } catch (Exception e) {
            // 系统异常，记录日志并返回通用错误信息
            e.printStackTrace();
            return error("自动排课过程中发生系统错误，请稍后重试或联系管理员。");
        }
    }
}
