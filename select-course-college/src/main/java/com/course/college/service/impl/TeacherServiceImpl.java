package com.course.college.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.Teacher;
import com.course.college.mapper.TeacherMapper;
import com.course.college.service.ITeacherService;
import com.course.common.utils.DateUtils;
import com.course.common.utils.StringUtils;
import com.course.common.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 教师信息Service业务层处理
 * 
 * @author course
 * @date 2025-08-24
 */
@Service
public class TeacherServiceImpl extends ServiceImpl<TeacherMapper, Teacher> implements ITeacherService
{
    @Autowired
    private TeacherMapper teacherMapper;

    /**
     * 查询教师信息
     * 
     * @param teacherId 教师信息主键
     * @return 教师信息
     */
    @Override
    public Teacher selectTeacherByTeacherId(Long teacherId)
    {
        return teacherMapper.selectTeacherByTeacherId(teacherId);
    }

    /**
     * 查询教师信息列表
     * 
     * @param teacher 教师信息
     * @return 教师信息
     */
    @Override
    public List<Teacher> selectTeacherList(Teacher teacher)
    {
        return teacherMapper.selectTeacherList(teacher);
    }

    /**
     * 新增教师信息
     * 
     * @param teacher 教师信息
     * @return 结果
     */
    @Override
    public int insertTeacher(Teacher teacher)
    {
        return teacherMapper.insertTeacher(teacher);
    }

    /**
     * 修改教师信息
     * 
     * @param teacher 教师信息
     * @return 结果
     */
    @Override
    public int updateTeacher(Teacher teacher)
    {
        return teacherMapper.updateTeacher(teacher);
    }

    /**
     * 批量删除教师信息
     * 
     * @param teacherIds 需要删除的教师信息主键
     * @return 结果
     */
    @Override
    public int deleteTeacherByTeacherIds(Long[] teacherIds)
    {
        return teacherMapper.deleteTeacherByTeacherIds(teacherIds);
    }

    /**
     * 删除教师信息信息
     * 
     * @param teacherId 教师信息主键
     * @return 结果
     */
    @Override
    public int deleteTeacherByTeacherId(Long teacherId)
    {
        return teacherMapper.deleteTeacherByTeacherId(teacherId);
    }

    /**
     * 根据教师姓名查询教师信息
     * 
     * @param teacherName 教师姓名
     * @return 教师信息
     */
    @Override
    public Teacher selectTeacherByName(String teacherName)
    {
        if (StringUtils.isEmpty(teacherName))
        {
            return null;
        }
        return teacherMapper.selectTeacherByName(teacherName);
    }

    /**
     * 验证教师姓名是否存在
     * 
     * @param teacherName 教师姓名
     * @return 结果
     */
    @Override
    public boolean validateTeacherName(String teacherName)
    {
        Teacher teacher = selectTeacherByName(teacherName);
        return teacher != null;
    }

    /**
     * 导入教师数据
     *
     * @param teacherList 教师数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @param operName 操作用户
     * @return 结果
     */
    @Override
    public String importTeacher(List<Teacher> teacherList, Boolean isUpdateSupport, String operName)
    {
        if (StringUtils.isNull(teacherList) || teacherList.size() == 0)
        {
            throw new ServiceException("导入教师数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (Teacher teacher : teacherList)
        {
            try
            {
                // 验证是否存在这个教师
                Teacher t = teacherMapper.selectTeacherByNo(teacher.getTeacherNo());
                if (StringUtils.isNull(t))
                {
                    teacher.setCreateTime(DateUtils.getNowDate());
                    this.insertTeacher(teacher);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、教师 " + teacher.getTeacherName() + " 导入成功");
                }
                else if (isUpdateSupport)
                {
                    teacher.setTeacherId(t.getTeacherId());
                    teacher.setUpdateTime(DateUtils.getNowDate());
                    this.updateTeacher(teacher);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、教师 " + teacher.getTeacherName() + " 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、教师 " + teacher.getTeacherName() + " 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String msg = "<br/>" + failureNum + "、教师 " + teacher.getTeacherName() + " 导入失败：";
                failureMsg.append(msg + e.getMessage());
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        else
        {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        return successMsg.toString();
    }
}