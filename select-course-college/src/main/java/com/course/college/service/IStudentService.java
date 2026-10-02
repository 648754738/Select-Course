package com.course.college.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.course.college.domain.Student;

import java.util.List;

public interface IStudentService extends IService<Student> {
    List<Student> selectStudentList(Student student);

    Student selectStudentByStudentId(Long studentId);

    boolean insertStudent(Student student);

    boolean updateStudent(Student student);

    boolean deleteStudentByStudentIds(Long[] studentIds);

    /**
     * 验证学生信息（学号和姓名是否匹配）
     * @param studentNo 学号
     * @param studentName 学生姓名
     * @return 匹配的学生信息，不存在或不匹配返回 null
     */
    Student validateStudentInfo(String studentNo, String studentName);

    /**
     * 批量导入学生数据
     * @param studentList 学生数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @param operName 操作用户
     * @return 结果信息
     */
    String importStudent(List<Student> studentList, Boolean isUpdateSupport, String operName);
}
