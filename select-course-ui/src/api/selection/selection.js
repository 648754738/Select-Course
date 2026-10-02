import request from '@/utils/request'

// 查询选课管理列表
export function listSelection(query) {
  return request({
    url: '/selection/selection/list',
    method: 'get',
    params: query
  })
}

// 查询选课管理详细
export function getSelection(selectionId) {
  return request({
    url: '/selection/selection/' + selectionId,
    method: 'get'
  })
}

// 新增选课管理
export function addSelection(data) {
  return request({
    url: '/selection/selection',
    method: 'post',
    data: data
  })
}

// 修改选课管理
export function updateSelection(data) {
  return request({
    url: '/selection/selection',
    method: 'put',
    data: data
  })
}

// 删除选课管理
export function delSelection(selectionId) {
  return request({
    url: '/selection/selection/' + selectionId,
    method: 'delete'
  })
}

// 获取近一周选课统计数据
export function getWeeklySelectionStats() {
  return request({
    url: '/selection/selection/weeklyStats',
    method: 'get'
  })
}
