package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.Teacher;

import java.util.List;

/**
 * 教师信息Service接口
 * 
 * @author course
 * @date 2025-08-24
 */
public interface ITeacherService extends IService<Teacher>
{
    /**
     * 查询教师信息
     * 
     * @param teacherId 教师信息主键
     * @return 教师信息
     */
    public Teacher selectTeacherByTeacherId(Long teacherId);

    /**
     * 查询教师信息列表
     * 
     * @param teacher 教师信息
     * @return 教师信息集合
     */
    public List<Teacher> selectTeacherList(Teacher teacher);

    /**
     * 新增教师信息
     * 
     * @param teacher 教师信息
     * @return 结果
     */
    public int insertTeacher(Teacher teacher);

    /**
     * 修改教师信息
     * 
     * @param teacher 教师信息
     * @return 结果
     */
    public int updateTeacher(Teacher teacher);

    /**
     * 批量删除教师信息
     * 
     * @param teacherIds 需要删除的教师信息主键集合
     * @return 结果
     */
    public int deleteTeacherByTeacherIds(Long[] teacherIds);

    /**
     * 删除教师信息信息
     * 
     * @param teacherId 教师信息主键
     * @return 结果
     */
    public int deleteTeacherByTeacherId(Long teacherId);

    /**
     * 根据教师姓名查询教师信息
     * 
     * @param teacherName 教师姓名
     * @return 教师信息
     */
    public Teacher selectTeacherByName(String teacherName);

    /**
     * 验证教师姓名是否存在
     * 
     * @param teacherName 教师姓名
     * @return 结果
     */
    public boolean validateTeacherName(String teacherName);

    /**
     * 导入教师数据
     *
     * @param teacherList 教师数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @param operName 操作用户
     * @return 结果
     */
    public String importTeacher(List<Teacher> teacherList, Boolean isUpdateSupport, String operName);
}