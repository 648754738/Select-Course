package com.course.college.controller;

import com.course.college.domain.HistoryCourseSelection;
import com.course.college.service.IHistoryCourseSelectionService;
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
 * 选课历史记录Controller
 * 
 * @author 席老师
 * @date 2025-08-24
 */
@RestController
@RequestMapping("/history/selection")
public class HistoryCourseSelectionController extends BaseController {
    
    @Autowired
    private IHistoryCourseSelectionService historyCourseSelectionService;

    /**
     * 查询选课历史记录列表
     */
    @PreAuthorize("@ss.hasPermi('history:selection:list')")
    @GetMapping("/list")
    public TableDataInfo list(HistoryCourseSelection historyCourseSelection) {
        startPage();
        List<HistoryCourseSelection> list = historyCourseSelectionService.selectHistoryCourseSelectionList(historyCourseSelection);
        return getDataTable(list);
    }

    /**
     * 导出选课历史记录列表
     */
    @PreAuthorize("@ss.hasPermi('history:selection:export')")
    @Log(title = "选课历史记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, HistoryCourseSelection historyCourseSelection) {
        List<HistoryCourseSelection> list = historyCourseSelectionService.selectHistoryCourseSelectionList(historyCourseSelection);
        ExcelUtil<HistoryCourseSelection> util = new ExcelUtil<HistoryCourseSelection>(HistoryCourseSelection.class);
        util.exportExcel(response, list, "选课历史记录数据");
    }

    /**
     * 获取选课历史记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('history:selection:query')")
    @GetMapping(value = "/{selectionId}")
    public AjaxResult getInfo(@PathVariable("selectionId") Long selectionId) {
        return success(historyCourseSelectionService.selectHistoryCourseSelectionById(selectionId));
    }

    /**
     * 新增选课历史记录
     */
    @PreAuthorize("@ss.hasPermi('history:selection:add')")
    @Log(title = "选课历史记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody HistoryCourseSelection historyCourseSelection) {
        return toAjax(historyCourseSelectionService.insertHistoryCourseSelection(historyCourseSelection));
    }

    /**
     * 删除选课历史记录
     */
    @PreAuthorize("@ss.hasPermi('history:selection:remove')")
    @Log(title = "选课历史记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{selectionIds}")
    public AjaxResult remove(@PathVariable Long[] selectionIds) {
        return toAjax(historyCourseSelectionService.deleteHistoryCourseSelectionByIds(selectionIds));
    }
}