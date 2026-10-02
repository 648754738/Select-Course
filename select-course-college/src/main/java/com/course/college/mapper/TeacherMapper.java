package com.course.college.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.course.college.domain.Teacher;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 教师信息Mapper接口
 * 
 * @author course
 * @date 2025-08-24
 */
@Mapper
public interface TeacherMapper extends BaseMapper<Teacher>
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
     * 删除教师信息
     * 
     * @param teacherId 教师信息主键
     * @return 结果
     */
    public int deleteTeacherByTeacherId(Long teacherId);

    /**
     * 批量删除教师信息
     * 
     * @param teacherIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTeacherByTeacherIds(Long[] teacherIds);

    /**
     * 根据教师姓名查询教师信息
     * 
     * @param teacherName 教师姓名
     * @return 教师信息
     */
    public Teacher selectTeacherByName(String teacherName);

    /**
     * 根据教师编号查询教师信息
     * 
     * @param teacherNo 教师编号
     * @return 教师信息
     */
    public Teacher selectTeacherByNo(String teacherNo);
}