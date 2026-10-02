package com.course.college.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.course.college.domain.Student;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentMapper  extends BaseMapper<Student> {
}
