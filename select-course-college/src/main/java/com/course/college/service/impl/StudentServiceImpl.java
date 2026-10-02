package com.course.college.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.course.college.domain.Student;
import com.course.college.mapper.StudentMapper;
import com.course.college.service.IStudentService;
import com.course.common.core.domain.entity.SysDept;
import com.course.common.exception.ServiceException;
import com.course.common.utils.StringUtils;
import com.course.system.service.ISysDeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;


@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements IStudentService {

    @Autowired
    private ISysDeptService sysDeptService;

    @Override
    public List<Student> selectStudentList(Student student) {
        LambdaQueryWrapper<Student> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(student.getStudentName()),
                Student::getStudentName,
                student.getStudentName());
        queryWrapper.like(StringUtils.isNotEmpty(student.getStudentNo()),
                Student::getStudentNo, student.getStudentNo());
        queryWrapper.like(StringUtils.isNotEmpty(student.getMajor()),
                Student::getMajor, student.getMajor());
        return list(queryWrapper);
    }

    @Override
    public Student selectStudentByStudentId(Long studentId) {
        return getById(studentId);
    }

    @Override
    public boolean insertStudent(Student student) {
        //查询院系
        SysDept sysDept = sysDeptService.selectDeptById(student.getDeptId());
        student.setCollegeName(sysDept.getDeptName());
        return super.save(student);
    }

    @Override
    public boolean updateStudent(Student student) {
        return super.updateById(student);
    }

    @Override
    public boolean deleteStudentByStudentIds(Long[] studentIds) {
        return super.removeBatchByIds(Arrays.asList(studentIds));
    }

    @Override
    public Student validateStudentInfo(String studentNo, String studentName) {
        LambdaQueryWrapper<Student> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Student::getStudentNo, studentNo)
                   .eq(Student::getStudentName, studentName);
        return getOne(queryWrapper);
    }

    @Override
    public String importStudent(List<Student> studentList, Boolean isUpdateSupport, String operName) {
        if (StringUtils.isNull(studentList) || studentList.size() == 0) {
            throw new ServiceException("导入学生数据不能为空！");
        }
        
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        
        for (Student student : studentList) {
            try {
                // 验证学号是否已存在
                Student existStudent = this.getStudentByStudentNo(student.getStudentNo());
                
                if (StringUtils.isNull(existStudent)) {
                    // 新增学生
                    this.validateStudentData(student);
                    this.insertStudent(student);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、学号 ").append(student.getStudentNo()).append("导入成功");
                } else if (isUpdateSupport) {
                    // 更新学生
                    this.validateStudentData(student);
                    student.setStudentId(existStudent.getStudentId());
                    this.updateStudent(student);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、学号 ").append(student.getStudentNo()).append("更新成功");
                } else {
                    // 不允许更新
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、学号 ").append(student.getStudentNo()).append("已存在");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + "、学号 " + student.getStudentNo() + " 导入失败：";
                failureMsg.append(msg).append(e.getMessage());
            }
        }
        
        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        
        return successMsg.toString();
    }
    
    /**
     * 根据学号查询学生信息
     */
    private Student getStudentByStudentNo(String studentNo) {
        LambdaQueryWrapper<Student> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Student::getStudentNo, studentNo);
        return getOne(queryWrapper);
    }
    
    /**
     * 验证学生数据
     */
    private void validateStudentData(Student student) {
        if (StringUtils.isEmpty(student.getStudentNo())) {
            throw new ServiceException("学号不能为空");
        }
        if (StringUtils.isEmpty(student.getStudentName())) {
            throw new ServiceException("学生姓名不能为空");
        }
        if (StringUtils.isEmpty(student.getGender())) {
            throw new ServiceException("性别不能为空");
        }
        if (StringUtils.isEmpty(student.getMajor())) {
            throw new ServiceException("专业不能为空");
        }
        if (StringUtils.isEmpty(student.getGrade())) {
            throw new ServiceException("年级不能为空");
        }
        
        // 验证性别格式
        if (!"男".equals(student.getGender()) && !"女".equals(student.getGender())) {
            throw new ServiceException("性别格式不正确，只能为男或女");
        }
        
        // 验证学号格式（只能包含数字和字母）
        if (!student.getStudentNo().matches("^[0-9a-zA-Z]+$")) {
            throw new ServiceException("学号格式不正确，只能包含数字和字母");
        }
        
        // 验证联系方式格式
        if (StringUtils.isNotEmpty(student.getContact()) && !student.getContact().matches("^[0-9-]+$")) {
            throw new ServiceException("联系方式格式不正确，只能包含数字和短横线");
        }
    }
}
