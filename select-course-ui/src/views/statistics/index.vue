<template>
  <div class="app-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2><i class="el-icon-pie-chart"></i> 数据统计分析</h2>
      <p>课程与学生选课的详细统计信息</p>
    </div>

    <!-- 课程详细统计 -->
    <el-card class="table-card" shadow="never">
      <div slot="header" class="card-header">
        <div class="header-left">
          <i class="el-icon-notebook-2"></i>
          <span>课程详细统计</span>
        </div>
        <div class="header-right">
          <el-tag type="info" size="small">共 {{ courseStatsList.length }} 门课程</el-tag>
          <el-button size="mini" type="primary" icon="el-icon-refresh" @click="refreshData" style="margin-left: 8px;">
            刷新数据
          </el-button>
        </div>
      </div>
      
      <el-table 
        v-loading="loading" 
        :data="courseStatsList" 
        style="width: 100%"
        :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
        stripe
        border
      >
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="课程名称" align="center" prop="courseName" min-width="150">
          <template slot-scope="scope">
            <el-tag type="primary" effect="plain">{{ scope.row.courseName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="授课教师" align="center" prop="teacherName" width="120" />
        <el-table-column label="课程类型" align="center" prop="courseType" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.courseType === '必修课' ? 'danger' : 'success'" size="small">
              {{ scope.row.courseType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="选课人数" align="center" prop="currentStudents" width="100">
          <template slot-scope="scope">
            <span class="number-highlight">{{ scope.row.currentStudents || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="课程容量" align="center" prop="maxStudents" width="100">
          <template slot-scope="scope">
            <span class="number-highlight">{{ scope.row.maxStudents || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="选课率" align="center" width="200">
          <template slot-scope="scope">
            <el-progress 
              :percentage="Math.round((scope.row.currentStudents / scope.row.maxStudents) * 100)"
              :color="getProgressColor(scope.row.currentStudents / scope.row.maxStudents)"
              :stroke-width="8"
              :show-text="true"
            ></el-progress>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" width="120">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.currentStudents >= scope.row.maxStudents" type="danger" size="small">
              <i class="el-icon-warning"></i> 已满
            </el-tag>
            <el-tag v-else-if="scope.row.currentStudents / scope.row.maxStudents > 0.8" type="warning" size="small">
              <i class="el-icon-warning-outline"></i> 即将满员
            </el-tag>
            <el-tag v-else type="success" size="small">
              <i class="el-icon-circle-check"></i> 有余位
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 学生选课统计 -->
    <el-card class="table-card" shadow="never" style="margin-top: 20px;">
      <div slot="header" class="card-header">
        <div class="header-left">
          <i class="el-icon-user"></i>
          <span>学生选课统计</span>
        </div>
        <div class="header-right">
          <el-tag type="info" size="small">共 {{ studentStatsList.length }} 名学生</el-tag>
          <el-button size="mini" type="success" icon="el-icon-download" @click="exportStudentData" style="margin-left: 8px;">
            导出数据
          </el-button>
        </div>
      </div>
      
      <el-table 
        v-loading="studentLoading" 
        :data="studentStatsList" 
        style="width: 100%"
        :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
        stripe
        border
      >
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="学生姓名" align="center" prop="studentName" width="120">
          <template slot-scope="scope">
            <el-tag type="primary" effect="plain">{{ scope.row.studentName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="学号" align="center" prop="studentNo" width="150" />
        <el-table-column label="专业" align="center" prop="major" min-width="120" />
        <el-table-column label="年级" align="center" prop="grade" width="80" />
        <el-table-column label="已选课程数" align="center" prop="selectionCount" width="120">
          <template slot-scope="scope">
            <span class="number-highlight">{{ scope.row.selectionCount || 0 }}</span> 门
          </template>
        </el-table-column>
        <el-table-column label="必修课数" align="center" prop="requiredCount" width="100">
          <template slot-scope="scope">
            <el-tag type="danger" size="small">{{ scope.row.requiredCount || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="选修课数" align="center" prop="electiveCount" width="100">
          <template slot-scope="scope">
            <el-tag type="success" size="small">{{ scope.row.electiveCount || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="总学分" align="center" prop="totalCredits" width="100">
          <template slot-scope="scope">
            <span class="credit-highlight">{{ scope.row.totalCredits || 0 }}</span> 分
          </template>
        </el-table-column>
        <el-table-column label="选课状态" align="center" width="120">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.selectionCount >= 8" type="success" size="small">
              <i class="el-icon-circle-check"></i> 已足够
            </el-tag>
            <el-tag v-else-if="scope.row.selectionCount >= 5" type="warning" size="small">
              <i class="el-icon-warning-outline"></i> 适中
            </el-tag>
            <el-tag v-else type="info" size="small">
              <i class="el-icon-info"></i> 较少
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { listCourse } from "@/api/course/course";
import { listSchedule } from "@/api/schedule/schedule";
import { listSelection } from "@/api/selection/selection";
import { listStudent } from "@/api/student/student";

export default {
  name: "Statistics",
  data() {
    return {
      loading: false,
      studentLoading: false,
      courseStatsList: [],
      studentStatsList: []
    };
  },
  mounted() {
    this.loadStatistics();
    
    // 监听全局数据更新事件
    this.$root.$on('courseDataUpdated', this.handleCourseDataUpdated);
  },
  
  beforeDestroy() {
    // 移除事件监听
    this.$root.$off('courseDataUpdated', this.handleCourseDataUpdated);
  },
  methods: {
    
    /** 加载统计数据 */
    async loadStatistics() {
      this.loading = true;
      this.studentLoading = true;
      
      try {
        // 并行加载各种数据
        const [courseRes, scheduleRes, selectionRes, studentRes] = await Promise.all([
          listCourse({ pageNum: 1, pageSize: 1000 }),
          listSchedule({ pageNum: 1, pageSize: 1000 }),
          listSelection({ pageNum: 1, pageSize: 1000 }),
          listStudent({ pageNum: 1, pageSize: 1000 })
        ]);
        
        // 处理课程统计数据
        this.processCourseStats(scheduleRes.rows || [], selectionRes.rows || []);
        
        // 处理学生统计数据
        this.processStudentStats(studentRes.rows || [], selectionRes.rows || []);
        
      } catch (error) {
        console.error('加载统计数据失败:', error);
        this.$message.error('加载统计数据失败');
      } finally {
        this.loading = false;
        this.studentLoading = false;
      }
    },
    
    /** 处理课程统计数据 */
    processCourseStats(schedules, selections) {
      const courseMap = new Map();
      
      // 统计每个课程的选课人数
      schedules.forEach(schedule => {
        const key = `${schedule.courseName}-${schedule.teacherName}`;
        if (!courseMap.has(key)) {
          courseMap.set(key, {
            courseName: schedule.courseName,
            teacherName: schedule.teacherName,
            courseType: '选修课', // 默认值，实际应该从课程表获取
            maxStudents: schedule.maxStudents || 0,
            currentStudents: schedule.currentStudents || 0
          });
        }
      });
      
      this.courseStatsList = Array.from(courseMap.values());
    },
    
    /** 处理学生统计数据 */
    processStudentStats(students, selections) {
      const studentMap = new Map();
      
      // 初始化学生数据
      students.forEach(student => {
        studentMap.set(student.studentName, {
          studentName: student.studentName,
          studentNo: student.studentNo,
          major: student.major,
          grade: student.grade,
          selectionCount: 0,
          requiredCount: 0,
          electiveCount: 0,
          totalCredits: 0
        });
      });
      
      // 统计选课数据
      selections.forEach(selection => {
        const studentData = studentMap.get(selection.studentName);
        if (studentData) {
          studentData.selectionCount++;
          // 这里应该根据实际课程类型来统计
          studentData.electiveCount++;
          studentData.totalCredits += 3; // 假设每门课3学分
        }
      });
      
      this.studentStatsList = Array.from(studentMap.values());
    },
    
    /** 获取进度条颜色 */
    getProgressColor(percentage) {
      if (percentage >= 1) return '#F56C6C';
      if (percentage >= 0.8) return '#E6A23C';
      return '#67C23A';
    },
    
    /** 刷新数据 */
    refreshData() {
      this.$message.info('正在刷新数据...');
      this.loadStatistics();
    },
    
    /** 处理课程数据更新事件 */
    handleCourseDataUpdated() {
      console.log('统计页面收到数据更新通知，开始刷新统计数据');
      // 延迟一点时间刷新，等待后端数据更新完成
      setTimeout(() => {
        this.loadStatistics();
      }, 1000);
    },
    
    /** 导出学生数据 */
    exportStudentData() {
      // 这里可以实现导出功能
      this.$message.success('导出功能待实现');
    }
  }
};
</script>

<style scoped>
.app-container {
  background: #f5f5f5;
  min-height: 100vh;
  padding: 20px;
}

.page-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 30px;
  border-radius: 12px;
  margin-bottom: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.page-header h2 {
  margin: 0 0 8px 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
}

.page-header h2 i {
  margin-right: 10px;
  font-size: 26px;
}

.page-header p {
  margin: 0;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.table-card {
  border-radius: 8px;
  overflow: hidden;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0;
}

.header-left {
  display: flex;
  align-items: center;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.header-left i {
  margin-right: 8px;
  font-size: 18px;
  color: #409EFF;
}

.header-right {
  display: flex;
  align-items: center;
}

.number-highlight {
  font-weight: bold;
  color: #409EFF;
  font-size: 16px;
}

.credit-highlight {
  font-weight: bold;
  color: #67C23A;
  font-size: 14px;
}

/* 表格样式优化 */
.el-table {
  border-radius: 4px;
  overflow: hidden;
}

.el-table th {
  font-weight: 600;
}

.el-table .el-table__row:hover > td {
  background-color: #f5f7fa !important;
}

/* 进度条样式 */
.el-progress {
  display: flex;
  align-items: center;
}

.el-progress-bar {
  padding-right: 50px;
  margin-right: -50px;
}

.el-progress__text {
  font-weight: 600;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .app-container {
    padding: 10px;
  }
  
  .page-header {
    padding: 20px;
    text-align: center;
  }
  
  .page-header h2 {
    font-size: 20px;
  }
  
  .card-header {
    flex-direction: column;
    gap: 10px;
  }
  
  .header-left,
  .header-right {
    justify-content: center;
  }
}
</style>