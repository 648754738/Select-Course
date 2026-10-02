import request from '@/utils/request'

// 查询教师信息列表
export function listTeacher(query) {
  return request({
    url: '/college/teacher/list',
    method: 'get',
    params: query
  })
}

// 查询教师信息详细
export function getTeacher(teacherId) {
  return request({
    url: '/college/teacher/' + teacherId,
    method: 'get'
  })
}

// 新增教师信息
export function addTeacher(data) {
  return request({
    url: '/college/teacher',
    method: 'post',
    data: data
  })
}

// 修改教师信息
export function updateTeacher(data) {
  return request({
    url: '/college/teacher',
    method: 'put',
    data: data
  })
}

// 删除教师信息
export function delTeacher(teacherId) {
  return request({
    url: '/college/teacher/' + teacherId,
    method: 'delete'
  })
}

// 获取所有教师列表（供下拉选择使用）
export function listAllTeacher() {
  return request({
    url: '/college/teacher/listAll',
    method: 'get'
  })
}

// 验证教师姓名是否存在
export function validateTeacherName(teacherName) {
  return request({
    url: '/college/teacher/validate',
    method: 'get',
    params: {
      teacherName: teacherName
    }
  })
}