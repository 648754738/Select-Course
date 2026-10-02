package com.course.college.controller;

import com.course.college.domain.CourseSelection;
import com.course.college.service.ICourseSelectionService;
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
 * 选课管理Controller
 * 
 * @author ruoyi
 * @date 2025-08-21
 */
@RestController
@RequestMapping("/selection/selection")
public class CourseSelectionController extends BaseController
{
    @Autowired
    private ICourseSelectionService courseSelectionService;

    /**
     * 查询选课管理列表
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:list')")
    @GetMapping("/list")
    public TableDataInfo list(CourseSelection courseSelection)
    {
        startPage();
        List<CourseSelection> list = courseSelectionService.selectCourseSelectionList(courseSelection);
        return getDataTable(list);
    }

    /**
     * 导出选课管理列表
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:export')")
    @Log(title = "选课管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CourseSelection courseSelection)
    {
        List<CourseSelection> list = courseSelectionService.selectCourseSelectionList(courseSelection);
        ExcelUtil<CourseSelection> util = new ExcelUtil<CourseSelection>(CourseSelection.class);
        util.exportExcel(response, list, "选课管理数据");
    }

    /**
     * 获取选课管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:query')")
    @GetMapping(value = "/{selectionId}")
    public AjaxResult getInfo(@PathVariable("selectionId") Long selectionId)
    {
        return success(courseSelectionService.selectCourseSelectionBySelectionId(selectionId));
    }

    /**
     * 新增选课管理
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:add')")
    @Log(title = "选课管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CourseSelection courseSelection)
    {
        return toAjax(courseSelectionService.insertCourseSelection(courseSelection));
    }

    /**
     * 修改选课管理
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:edit')")
    @Log(title = "选课管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CourseSelection courseSelection)
    {
        return toAjax(courseSelectionService.updateCourseSelection(courseSelection));
    }

    /**
     * 删除选课管理
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:remove')")
    @Log(title = "选课管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{selectionIds}")
    public AjaxResult remove(@PathVariable Long[] selectionIds)
    {
        return toAjax(courseSelectionService.deleteCourseSelectionBySelectionIds(selectionIds));
    }

    /**
     * 获取近一周选课统计数据
     */
    @PreAuthorize("@ss.hasPermi('selection:selection:list')")
    @GetMapping("/weeklyStats")
    public AjaxResult getWeeklySelectionStatistics()
    {
        try {
            java.util.Map<String, Integer> stats = courseSelectionService.getWeeklySelectionStatistics();
            return success(stats);
        } catch (Exception e) {
            return error("获取选课统计数据失败: " + e.getMessage());
        }
    }
}
