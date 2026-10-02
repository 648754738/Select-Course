import request from '@/utils/request'

// 查询选课历史记录列表
export function listHistorySelection(query) {
  return request({
    url: '/history/selection/list',
    method: 'get',
    params: query
  })
}

// 查询选课历史记录详细
export function getHistorySelection(selectionId) {
  return request({
    url: '/history/selection/' + selectionId,
    method: 'get'
  })
}

// 新增选课历史记录
export function addHistorySelection(data) {
  return request({
    url: '/history/selection',
    method: 'post',
    data: data
  })
}

// 删除选课历史记录
export function delHistorySelection(selectionId) {
  return request({
    url: '/history/selection/' + selectionId,
    method: 'delete'
  })
}