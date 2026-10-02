import request from '@/utils/request'

// 查询课表管理列表
export function listSchedule(query) {
  return request({
    url: '/schedule/schedule/list',
    method: 'get',
    params: query
  })
}

// 查询课表管理详细
export function getSchedule(scheduleId) {
  return request({
    url: '/schedule/schedule/' + scheduleId,
    method: 'get'
  })
}
export function getCourseScheduleTeacherName() {
  return request({
    url: '/schedule/schedule/getCourseScheduleTeacherName',
    method: 'get'
  })
}
// 新增课表管理
export function addSchedule(data) {
  return request({
    url: '/schedule/schedule',
    method: 'post',
    data: data
  })
}

// 修改课表管理
export function updateSchedule(data) {
  return request({
    url: '/schedule/schedule',
    method: 'put',
    data: data
  })
}

// 删除课表管理
export function delSchedule(scheduleId) {
  return request({
    url: '/schedule/schedule/' + scheduleId,
    method: 'delete'
  })
}

// 自动排课
export function generateSchedule(semester) {
  return request({
    url: '/schedule/schedule/generateSchedule',
    method: 'post',
    params: { semester }
  })
}

// 导出课表
export function exportSchedule(query) {
  return request({
    url: '/schedule/schedule/export',
    method: 'post',
    params: query,
    responseType: 'blob'
  })
}
