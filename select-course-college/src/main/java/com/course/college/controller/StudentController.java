package com.course.college.controller;

import com.course.college.domain.Student;
import com.course.college.service.IStudentService;
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
 * 学生管理Controller
 * 
 * @author 席老师
 * @date 2025-08-21
 */
@RestController
@RequestMapping("/student/student")
public class StudentController extends BaseController
{
    @Autowired
    private IStudentService studentService;

    /**
     * 查询学生管理列表
     */
    @PreAuthorize("@ss.hasPermi('student:student:list')")
    @GetMapping("/list")
    public TableDataInfo list(Student student)
    {
        startPage();
        List<Student> list = studentService.selectStudentList(student);
        return getDataTable(list);
    }

    /**
     * 导出学生管理列表
     */
    @PreAuthorize("@ss.hasPermi('student:student:export')")
    @Log(title = "学生管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Student student)
    {
        List<Student> list = studentService.selectStudentList(student);
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        util.exportExcel(response, list, "学生管理数据");
    }

    /**
     * 获取学生管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('student:student:query')")
    @GetMapping(value = "/{studentId}")
    public AjaxResult getInfo(@PathVariable("studentId") Long studentId)
    {
        return success(studentService.selectStudentByStudentId(studentId));
    }

    /**
     * 新增学生管理
     */
    @PreAuthorize("@ss.hasPermi('student:student:add')")
    @Log(title = "学生管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Student student)
    {
        return toAjax(studentService.insertStudent(student));
    }

    /**
     * 修改学生管理
     */
    @PreAuthorize("@ss.hasPermi('student:student:edit')")
    @Log(title = "学生管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Student student)
    {
        return toAjax(studentService.updateStudent(student));
    }

    /**
     * 删除学生管理
     */
    @PreAuthorize("@ss.hasPermi('student:student:remove')")
    @Log(title = "学生管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{studentIds}")
    public AjaxResult remove(@PathVariable Long[] studentIds)
    {
        return toAjax(studentService.deleteStudentByStudentIds(studentIds));
    }

    /**
     * 验证学生信息（学号和姓名是否匹配）
     */
    @GetMapping("/validate")
    public AjaxResult validateStudent(@RequestParam String studentNo, @RequestParam String studentName)
    {
        Student student = studentService.validateStudentInfo(studentNo, studentName);
        if (student != null) {
            return AjaxResult.success("学生信息验证成功", student);
        } else {
            return error("学生信息不存在或学号与姓名不匹配");
        }
    }

    /**
     * 批量导入学生数据
     */
    @PreAuthorize("@ss.hasPermi('student:student:import')")
    @Log(title = "学生管理", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception
    {
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        List<Student> studentList = util.importExcel(file.getInputStream());
        String operName = getUsername();
        String message = studentService.importStudent(studentList, updateSupport, operName);
        return success(message);
    }

    /**
     * 下载学生数据导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        util.importTemplateExcel(response, "学生数据");
    }
}
