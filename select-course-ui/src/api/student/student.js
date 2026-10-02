import request from '@/utils/request'

// 查询学生管理列表
export function listStudent(query) {
  return request({
    url: '/student/student/list',
    method: 'get',
    params: query
  })
}

// 查询学生管理详细
export function getStudent(studentId) {
  return request({
    url: '/student/student/' + studentId,
    method: 'get'
  })
}

// 新增学生管理
export function addStudent(data) {
  return request({
    url: '/student/student',
    method: 'post',
    data: data
  })
}

// 修改学生管理
export function updateStudent(data) {
  return request({
    url: '/student/student',
    method: 'put',
    data: data
  })
}

// 删除学生管理
export function delStudent(studentId) {
  return request({
    url: '/student/student/' + studentId,
    method: 'delete'
  })
}

// 验证学生信息（学号和姓名是否匹配）
export function validateStudent(studentNo, studentName) {
  return request({
    url: '/student/student/validate',
    method: 'get',
    params: {
      studentNo: studentNo,
      studentName: studentName
    }
  })
}
