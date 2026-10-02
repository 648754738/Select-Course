package com.course.college.controller;

import com.course.college.domain.Teacher;
import com.course.college.service.ITeacherService;
import com.course.common.annotation.Log;
import com.course.common.core.controller.BaseController;
import com.course.common.core.domain.AjaxResult;
import com.course.common.core.page.TableDataInfo;
import com.course.common.enums.BusinessType;
import com.course.common.utils.poi.ExcelUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 教师信息Controller
 * 
 * @author course
 * @date 2025-08-24
 */
@RestController
@RequestMapping("/college/teacher")
public class TeacherController extends BaseController
{
    @Autowired
    private ITeacherService teacherService;

    /**
     * 查询教师信息列表
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:list')")
    @GetMapping("/list")
    public TableDataInfo list(Teacher teacher)
    {
        startPage();
        List<Teacher> list = teacherService.selectTeacherList(teacher);
        return getDataTable(list);
    }

    /**
     * 导出教师信息列表
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:export')")
    @Log(title = "教师信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Teacher teacher)
    {
        List<Teacher> list = teacherService.selectTeacherList(teacher);
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        util.exportExcel(response, list, "教师信息数据");
    }

    /**
     * 获取教师信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:query')")
    @GetMapping(value = "/{teacherId}")
    public AjaxResult getInfo(@PathVariable("teacherId") Long teacherId)
    {
        return success(teacherService.selectTeacherByTeacherId(teacherId));
    }

    /**
     * 新增教师信息
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:add')")
    @Log(title = "教师信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Teacher teacher)
    {
        return toAjax(teacherService.insertTeacher(teacher));
    }

    /**
     * 修改教师信息
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:edit')")
    @Log(title = "教师信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Teacher teacher)
    {
        return toAjax(teacherService.updateTeacher(teacher));
    }

    /**
     * 删除教师信息
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:remove')")
    @Log(title = "教师信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{teacherIds}")
    public AjaxResult remove(@PathVariable Long[] teacherIds)
    {
        return toAjax(teacherService.deleteTeacherByTeacherIds(teacherIds));
    }

    /**
     * 获取所有教师列表（供下拉选择使用）
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:list')")
    @GetMapping("/listAll")
    public AjaxResult listAllTeacher()
    {
        List<Teacher> list = teacherService.list();
        return success(list);
    }

    /**
     * 验证教师姓名是否存在
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:list')")
    @GetMapping("/validate")
    public AjaxResult validateTeacherName(@RequestParam String teacherName)
    {
        boolean exists = teacherService.validateTeacherName(teacherName);
        return success(exists);
    }

    /**
     * 下载教师信息导入模板
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:import')")
    @Log(title = "教师信息", businessType = BusinessType.EXPORT)
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        util.importTemplateExcel(response, "教师信息");
    }

    /**
     * 导入教师信息数据
     */
    @PreAuthorize("@ss.hasPermi('college:teacher:import')")
    @Log(title = "教师信息", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception
    {
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        List<Teacher> teacherList = util.importExcel(file.getInputStream());
        String operName = getUsername();
        String message = teacherService.importTeacher(teacherList, updateSupport, operName);
        return success(message);
    }
}