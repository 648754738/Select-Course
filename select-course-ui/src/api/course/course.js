import request from '@/utils/request'

// 查询课程管理列表
export function listCourse(query) {
  return request({
    url: '/course/course/list',
    method: 'get',
    params: query
  })
}

// 查询所有课程列表（供选课使用）
export function listAllCourse() {
  return request({
    url: '/course/course/listAll',
    method: 'get'
  })
}

// 查询课程管理详细
export function getCourse(courseId) {
  return request({
    url: '/course/course/' + courseId,
    method: 'get'
  })
}

// 新增课程管理
export function addCourse(data) {
  return request({
    url: '/course/course',
    method: 'post',
    data: data
  })
}

// 修改课程管理
export function updateCourse(data) {
  return request({
    url: '/course/course',
    method: 'put',
    data: data
  })
}

// 删除课程管理
export function delCourse(courseId) {
  return request({
    url: '/course/course/' + courseId,
    method: 'delete'
  })
}

// 验证课程名称是否存在
export function validateCourseName(courseName) {
  return request({
    url: '/course/course/validate',
    method: 'get',
    params: {
      courseName: courseName
    }
  })
}