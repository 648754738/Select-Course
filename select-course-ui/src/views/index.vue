<template>
  <div class="dashboard-container">
    <!-- 欢迎区域 -->
    <el-card class="welcome-card" shadow="hover">
      <div class="welcome-header">
        <div class="welcome-info">
          <h2><i class="el-icon-star-off"></i> 智能选课系统</h2>
          <p>高校课程管理与选课一体化平台</p>
        </div>
        <div class="welcome-stats">
          <div class="stat-item">
            <div class="stat-number">{{ stats.totalCourses }}</div>
            <div class="stat-label">总课程数</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ stats.totalStudents }}</div>
            <div class="stat-label">在校学生</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ stats.totalSelections }}</div>
            <div class="stat-label">选课记录</div>
          </div>
        </div>
        <div class="welcome-actions">
          <el-button type="primary" @click="refreshData">
            <i class="el-icon-refresh"></i> 刷新数据
          </el-button>
          <el-dropdown @command="handleScheduleAction">
            <el-button type="success">
              <i class="el-icon-download"></i> 完整课表 <i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="export">
                <i class="el-icon-download"></i> 导出课表数据
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>
    </el-card>

    <el-row :gutter="20">
      <!-- 课表区域 -->
      <el-col :span="16">
        <el-card class="schedule-card" shadow="hover">
          <div slot="header" class="card-header">
            <span>本周课程安排</span>
            <div>
              <el-tag type="primary">{{ total }}门课程</el-tag>
              <el-tag type="success" style="margin-left: 8px;">{{ availableCourses }}门可选</el-tag>
              <el-button size="mini" type="primary" @click="refreshSchedule" style="margin-left: 8px;">
                刷新
              </el-button>
            </div>
          </div>
          
          <div v-loading="scheduleLoading">
            <div v-if="scheduleList.length === 0" class="empty-schedule">
              <i class="el-icon-warning"></i>
              <p>暂无课程数据</p>
            </div>
            
            <div v-else class="schedule-table-wrapper">
              <table class="schedule-table">
                <thead>
                  <tr>
                    <th>时间</th>
                    <th v-for="day in weekDays" :key="day">{{ day }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(slot, index) in timeSlots" :key="index">
                    <td class="time-cell">
                      <div>第{{ slot.period }}节</div>
                      <small>{{ slot.time }}</small>
                    </td>
                    <td v-for="day in weekDays" :key="day" class="course-cell">
                      <div 
                        v-for="course in getCoursesForSlot(day, slot.period)" 
                        :key="course.scheduleId"
                        class="course-item"
                        :class="{ 'course-full': (course.currentStudents || 0) >= course.maxStudents }"
                        @click="viewCourseDetail(course)"
                      >
                        <div class="course-name">{{ course.courseName }}</div>
                        <div class="course-teacher">{{ course.teacherName }}</div>
                        <div class="course-room">{{ course.classroom }}</div>
                        <div class="course-count">{{ course.currentStudents || 0 }}/{{ course.maxStudents }}</div>
                      </div>
                      <div v-if="getCoursesForSlot(day, slot.period).length === 0" class="empty-cell">
                        <span>空闲</span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 统计区域 -->
      <el-col :span="8">
        <!-- 数据统计 -->
        <el-card class="stats-card" shadow="hover">
          <div slot="header">数据概览</div>
          <div class="stats-grid">
            <div class="stat-box" v-for="(item, key) in statsConfig" :key="key">
              <div class="stat-icon" :style="{ backgroundColor: item.color }">
                <i :class="item.icon"></i>
              </div>
              <div class="stat-content">
                <div class="stat-value">{{ stats[key] }}</div>
                <div class="stat-title">{{ item.title }}</div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 热门课程与选课统计 -->
        <el-card class="popular-card" shadow="hover" style="margin-top: 20px;">
          <div slot="header">
            <span>热门课程 Top5</span>
            <el-tag size="mini" type="info" style="margin-left: 8px;">
              总选课: {{ stats.totalSelections }}人次
            </el-tag>
          </div>
          <div class="popular-list">
            <div 
              v-for="(course, index) in popularCourses.slice(0, 5)" 
              :key="index"
              class="popular-item"
            >
              <div class="rank">{{ index + 1 }}</div>
              <div class="course-info">
                <div class="name">{{ course.courseName }}</div>
                <div class="teacher">{{ course.teacherName }}</div>
                <div class="rate">
                  选课率: {{ Math.round((course.currentStudents / course.maxStudents) * 100) }}%
                </div>
              </div>
              <div class="count-info">
                <div class="count">{{ course.currentStudents }}/{{ course.maxStudents }}</div>
                <el-tag 
                  size="mini" 
                  :type="(course.currentStudents / course.maxStudents) >= 1 ? 'danger' : 
                         (course.currentStudents / course.maxStudents) >= 0.8 ? 'warning' : 'success'"
                >
                  {{ (course.currentStudents / course.maxStudents) >= 1 ? '已满' : 
                     (course.currentStudents / course.maxStudents) >= 0.8 ? '火爆' : '有余位' }}
                </el-tag>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 选课数据分析行 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <!-- 选课数据分析 -->
        <el-card class="chart-card" shadow="hover">
          <div slot="header">选课数据分析</div>
          <div id="selectionChart" style="height: 280px;"></div>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <!-- 课程选课状态分析 -->
        <el-card class="status-card" shadow="hover">
          <div slot="header">课程选课状态</div>
          <div id="statusChart" style="height: 280px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 课程详情对话框 -->
    <el-dialog 
      title="课程详情"
      :visible.sync="courseDetailVisible"
      width="500px"
    >
      <div v-if="selectedCourse">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="课程名称">{{ selectedCourse.courseName }}</el-descriptions-item>
          <el-descriptions-item label="授课教师">{{ selectedCourse.teacherName }}</el-descriptions-item>
          <el-descriptions-item label="上课时间">{{ selectedCourse.classTime }}</el-descriptions-item>
          <el-descriptions-item label="教室">{{ selectedCourse.classroom }}</el-descriptions-item>
          <el-descriptions-item label="选课人数">
            {{ selectedCourse.currentStudents || 0 }}/{{ selectedCourse.maxStudents }}
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag v-if="selectedCourse.currentStudents >= selectedCourse.maxStudents" type="danger">已满员</el-tag>
            <el-tag v-else type="success">有余位</el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { listCourse } from "@/api/course/course"
import { listSchedule, exportSchedule } from "@/api/schedule/schedule"
import { listSelection, getWeeklySelectionStats } from "@/api/selection/selection"
import { listStudent } from "@/api/student/student"

export default {
  name: "Dashboard",
  data() {
    return {
      scheduleLoading: false,
      scheduleList: [],
      total: 0,
      
      stats: {
        totalCourses: 0,
        totalStudents: 0,
        totalSelections: 0,
        totalSchedules: 0
      },
      
      statsConfig: {
        totalCourses: { title: '开设课程', icon: 'el-icon-notebook-2', color: '#e6f7ff' },
        totalStudents: { title: '在校学生', icon: 'el-icon-user', color: '#f6ffed' },
        totalSelections: { title: '选课记录', icon: 'el-icon-tickets', color: '#fff2e8' },
        totalSchedules: { title: '课表安排', icon: 'el-icon-time', color: '#fff0f6' }
      },
      
      weekDays: ['星期一', '星期二', '星期三', '星期四', '星期五'],
      timeSlots: [
        { period: '1', time: '08:00-09:40' },
        { period: '2', time: '10:00-11:40' },
        { period: '3', time: '14:00-15:40' },
        { period: '4', time: '16:00-17:40' },
        { period: '5', time: '19:00-20:40' }
      ],
      
      popularCourses: [],
      selectionData: [], // 选课数据
      weeklySelectionStats: {}, // 近一周选课统计数据
      courseDetailVisible: false,
      selectedCourse: null,
      selectionChart: null,
      statusChart: null // 新增状态图表
    }
  },
  
  computed: {
    availableCourses() {
      return this.scheduleList.filter(item => (item.currentStudents || 0) < item.maxStudents).length
    }
  },
  
  mounted() {
    this.loadAllData()
    this.initChart()
    
    // 监听全局数据更新事件
    this.$root.$on('courseDataUpdated', this.handleCourseDataUpdated)
  },
  
  beforeDestroy() {
    if (this.selectionChart) {
      this.selectionChart.dispose()
    }
    if (this.statusChart) {
      this.statusChart.dispose()
    }
    
    // 移除事件监听
    this.$root.$off('courseDataUpdated', this.handleCourseDataUpdated)
  },
  
  methods: {
    async loadAllData() {
      try {
        const [courseRes, scheduleRes, selectionRes, studentRes, weeklyStatsRes] = await Promise.all([
          listCourse({ pageNum: 1, pageSize: 1000 }),
          listSchedule({ pageNum: 1, pageSize: 1000 }),
          listSelection({ pageNum: 1, pageSize: 1000 }),
          listStudent({ pageNum: 1, pageSize: 1000 }),
          getWeeklySelectionStats()
        ])
        
        this.stats = {
          totalCourses: courseRes.total || 0,
          totalStudents: studentRes.total || 0,
          totalSelections: selectionRes.total || 0,
          totalSchedules: scheduleRes.total || 0
        }
        
        this.scheduleList = scheduleRes.rows || []
        this.total = scheduleRes.total || 0
        this.selectionData = selectionRes.rows || [] // 保存选课数据
        this.weeklySelectionStats = weeklyStatsRes.data || {} // 保存近一周选课统计数据
        
        this.popularCourses = (scheduleRes.rows || [])
          .filter(course => course.currentStudents > 0)
          .sort((a, b) => (b.currentStudents || 0) - (a.currentStudents || 0))
        
        this.updateChart()
        this.updateStatusChart()
      } catch (error) {
        console.error('数据加载失败:', error)
        this.$message.error('数据加载失败')
      }
    },
    
    initChart() {
      this.$nextTick(() => {
        this.selectionChart = echarts.init(document.getElementById('selectionChart'))
        this.statusChart = echarts.init(document.getElementById('statusChart'))
      })
    },
    
    updateChart() {
      if (!this.selectionChart) return
      
      // 使用真实的近一周选课统计数据
      const weeklyStats = this.weeklySelectionStats || {}
      const dates = Object.keys(weeklyStats).sort() // 按日期排序
      const counts = dates.map(date => weeklyStats[date] || 0)
      
      // 将日期转换为星期显示
      const dayLabels = dates.map(date => {
        try {
          const dateObj = new Date(date)
          const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
          const dayOfWeek = weekdays[dateObj.getDay()]
          const monthDay = `${dateObj.getMonth() + 1}/${dateObj.getDate()}`
          return `${dayOfWeek}(${monthDay})`
        } catch (e) {
          return date // 如果日期解析失败，直接返回原日期
        }
      })
      
      // 如果没有数据，显示默认的空数据
      if (dates.length === 0) {
        const today = new Date()
        for (let i = 6; i >= 0; i--) {
          const date = new Date(today.getTime() - i * 24 * 60 * 60 * 1000)
          const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
          const dayOfWeek = weekdays[date.getDay()]
          const monthDay = `${date.getMonth() + 1}/${date.getDate()}`
          dayLabels.push(`${dayOfWeek}(${monthDay})`)
          counts.push(0)
        }
      }
      
      const option = {
        title: {
          text: '近一周选课趋势',
          left: 'center',
          textStyle: {
            fontSize: 14,
            fontWeight: 'normal'
          }
        },
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(50, 50, 50, 0.8)',
          textStyle: {
            color: '#fff'
          },
          formatter: function(params) {
            const param = params[0]
            return `${param.name}<br/>选课人数: ${param.value}人`
          }
        },
        xAxis: {
          type: 'category',
          data: dayLabels,
          axisLabel: {
            fontSize: 12,
            color: '#606266',
            rotate: 20 // 旋转角度，防止标签重叠
          },
          axisLine: {
            lineStyle: {
              color: '#E4E7ED'
            }
          }
        },
        yAxis: {
          type: 'value',
          name: '选课人数',
          axisLabel: {
            fontSize: 11,
            color: '#909399'
          },
          axisLine: {
            lineStyle: {
              color: '#E4E7ED'
            }
          },
          splitLine: {
            lineStyle: {
              color: '#F5F7FA'
            }
          }
        },
        grid: {
          left: '12%',
          right: '8%',
          bottom: '20%',
          top: '20%'
        },
        series: [{
          name: '选课人数',
          type: 'line',
          smooth: true,
          data: counts,
          itemStyle: {
            color: '#409EFF'
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(64, 158, 255, 0.3)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
            ])
          },
          lineStyle: {
            width: 3
          },
          symbol: 'circle',
          symbolSize: 8
        }]
      }
      
      this.selectionChart.setOption(option)
    },
    
    updateStatusChart() {
      if (!this.statusChart) return
      
      // 计算课程选课状态
      const fullCourses = this.scheduleList.filter(course => 
        (course.currentStudents || 0) >= course.maxStudents
      ).length
      
      const nearFullCourses = this.scheduleList.filter(course => {
        const rate = (course.currentStudents || 0) / course.maxStudents
        return rate >= 0.8 && rate < 1
      }).length
      
      const availableCourses = this.scheduleList.filter(course => {
        const rate = (course.currentStudents || 0) / course.maxStudents
        return rate < 0.8
      }).length
      
      const data = [
        { name: '已满员', value: fullCourses, itemStyle: { color: '#F56C6C' } },
        { name: '即将满员', value: nearFullCourses, itemStyle: { color: '#E6A23C' } },
        { name: '有余位', value: availableCourses, itemStyle: { color: '#67C23A' } }
      ]
      
      const option = {
        title: {
          text: '课程状态分布',
          left: 'center',
          textStyle: {
            fontSize: 14,
            fontWeight: 'normal'
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c}门课程 ({d}%)',
          backgroundColor: 'rgba(50, 50, 50, 0.8)',
          textStyle: {
            color: '#fff'
          }
        },
        legend: {
          orient: 'horizontal',
          bottom: '8%',
          itemGap: 20,
          textStyle: {
            fontSize: 12,
            color: '#606266'
          }
        },
        series: [{
          name: '课程状态',
          type: 'pie',
          radius: ['35%', '65%'],
          center: ['50%', '45%'],
          data: data,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          label: {
            fontSize: 12,
            color: '#606266'
          },
          labelLine: {
            lineStyle: {
              color: '#C0C4CC'
            }
          }
        }]
      }
      
      this.statusChart.setOption(option)
    },
    
    getCoursesForSlot(day, period) {
      return this.scheduleList.filter(course => {
        return course.week === day && course.classTime && course.classTime.includes(period)
      })
    },
    
    viewCourseDetail(course) {
      this.selectedCourse = course
      this.courseDetailVisible = true
    },
    
    refreshSchedule() {
      this.scheduleLoading = true
      listSchedule({ pageNum: 1, pageSize: 1000 }).then(response => {
        this.scheduleList = response.rows || []
        this.total = response.total || 0
        // 同时更新热门课程数据
        this.popularCourses = (response.rows || [])
          .filter(course => course.currentStudents > 0)
          .sort((a, b) => (b.currentStudents || 0) - (a.currentStudents || 0))
        // 更新图表
        this.updateStatusChart()
        this.$message.success('课表已刷新')
      }).finally(() => {
        this.scheduleLoading = false
      })
    },
    
    refreshData() {
      this.$message.info('正在刷新数据...')
      this.loadAllData()
    },
    
    /** 处理课程数据更新事件 */
    handleCourseDataUpdated() {
      console.log('收到课程数据更新通知，开始刷新页面数据')
      // 延迟一点时间刷新，等待后端数据更新完成
      setTimeout(() => {
        this.loadAllData()
      }, 1000)
    },
    
    /** 处理课表操作 */
    handleScheduleAction(command) {
      if (command === 'export') {
        this.exportScheduleData()
      }
    },
    
    /** 导出课表数据 */
    exportScheduleData() {
      this.$modal.confirm('是否确认导出所有课表数据项？').then(() => {
        this.download('schedule/schedule/export', {
          pageNum: 1,
          pageSize: 10000
        }, `课表数据_${new Date().getTime()}.xlsx`)
      }).catch(() => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background: #f5f5f5;
  min-height: 100vh;
}

.welcome-card {
  margin-bottom: 20px;
  
  .welcome-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .welcome-info h2 {
      margin: 0 0 8px 0;
      color: #303133;
      i {
        color: #409EFF;
        margin-right: 8px;
      }
    }
    
    .welcome-info p {
      margin: 0;
      color: #606266;
    }
    
    .welcome-stats {
      display: flex;
      gap: 40px;
      
      .stat-item {
        text-align: center;
        
        .stat-number {
          font-size: 28px;
          font-weight: bold;
          color: #409EFF;
          line-height: 1;
        }
        
        .stat-label {
          font-size: 14px;
          color: #909399;
          margin-top: 4px;
        }
      }
    }
    
    .welcome-actions {
      display: flex;
      gap: 12px;
    }
  }
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.schedule-card {
  .empty-schedule {
    text-align: center;
    padding: 60px 20px;
    color: #909399;
    
    i {
      font-size: 48px;
      margin-bottom: 16px;
    }
  }
  
  .schedule-table-wrapper {
    overflow-x: auto;
  }
  
  .schedule-table {
    width: 100%;
    border-collapse: collapse;
    
    th, td {
      border: 1px solid #EBEEF5;
      text-align: center;
      vertical-align: top;
    }
    
    th {
      background: #F5F7FA;
      padding: 12px 8px;
      font-weight: 600;
      color: #606266;
    }
    
    .time-cell {
      background: #F0F9FF;
      padding: 16px 8px;
      width: 100px;
      
      div {
        font-weight: 600;
        color: #1890FF;
      }
      
      small {
        color: #909399;
        font-size: 12px;
      }
    }
    
    .course-cell {
      padding: 4px;
      min-height: 80px;
      width: 140px;
      
      .course-item {
        background: linear-gradient(135deg, #E6F7FF 0%, #F6FFED 100%);
        border: 1px solid #D9F7BE;
        border-radius: 6px;
        padding: 8px;
        margin: 2px;
        cursor: pointer;
        transition: all 0.3s;
        
        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        &.course-full {
          background: linear-gradient(135deg, #FFF2F0 0%, #FFEBE6 100%);
          border-color: #FFA39E;
          
          .course-name {
            color: #CF1322;
          }
        }
        
        .course-name {
          font-size: 13px;
          font-weight: 600;
          margin-bottom: 3px;
          color: #262626;
        }
        
        .course-teacher {
          font-size: 11px;
          color: #52C41A;
          margin-bottom: 2px;
        }
        
        .course-room {
          font-size: 11px;
          color: #1890FF;
          margin-bottom: 2px;
        }
        
        .course-count {
          font-size: 10px;
          color: #8C8C8C;
        }
      }
      
      .empty-cell {
        padding: 30px 0;
        color: #D9D9D9;
        font-size: 14px;
      }
    }
  }
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  
  .stat-box {
    display: flex;
    align-items: center;
    padding: 16px;
    background: #FAFAFA;
    border-radius: 8px;
    
    .stat-icon {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
      
      i {
        font-size: 20px;
      }
    }
    
    .stat-content {
      .stat-value {
        font-size: 20px;
        font-weight: bold;
        color: #303133;
      }
      
      .stat-title {
        font-size: 12px;
        color: #606266;
      }
    }
  }
}

.popular-list {
  .popular-item {
    display: flex;
    align-items: center;
    padding: 12px 0;
    border-bottom: 1px solid #F0F0F0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .rank {
      width: 24px;
      height: 24px;
      border-radius: 50%;
      background: #409EFF;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: bold;
      margin-right: 12px;
      flex-shrink: 0;
    }
    
    .course-info {
      flex: 1;
      min-width: 0;
      
      .name {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 4px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      
      .teacher {
        font-size: 12px;
        color: #909399;
        margin-bottom: 2px;
      }
      
      .rate {
        font-size: 11px;
        color: #67C23A;
        font-weight: 500;
      }
    }
    
    .count-info {
      text-align: right;
      flex-shrink: 0;
      
      .count {
        font-size: 13px;
        color: #606266;
        font-weight: 600;
        margin-bottom: 4px;
      }
    }
  }
}

@media (max-width: 768px) {
  .welcome-header {
    flex-direction: column;
    gap: 20px;
    
    .welcome-stats {
      gap: 20px;
    }
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>