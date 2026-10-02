<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <el-card class="search-card mb-3" shadow="never">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="课程名称" prop="courseName">
          <el-input
            v-model="queryParams.courseName"
            placeholder="请输入课程名称"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="教师姓名" prop="teacherName">
          <el-input
            v-model="queryParams.teacherName"
            placeholder="请输入教师姓名"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="学期" prop="semester">
          <el-select v-model="queryParams.semester" placeholder="请选择学期" clearable>
            <el-option label="第一学期" value="第一学期" />
            <el-option label="第二学期" value="第二学期" />
            <el-option label="第三学期" value="第三学期" />
            <el-option label="第四学期" value="第四学期" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          <el-button type="info" icon="el-icon-switch-button" size="mini" @click="toggleViewMode">
            {{ viewMode === 'table' ? '课表视图' : '列表视图' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作区域 -->
    <el-card class="operation-card mb-3" shadow="never">
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            @click="handleExport"
            v-hasPermi="['schedule:schedule:export']"
          >导出课表</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>
    </el-card>

    <!-- 高校课表视图 -->
    <el-card v-if="viewMode === 'schedule'" class="schedule-card" shadow="never">
      <div slot="header" class="schedule-header">
        <span class="schedule-title">
          <i class="el-icon-date"></i>
          课表管理
        </span>
        <div class="schedule-info">
          <el-tag type="primary">总课程数: {{ total }}</el-tag>
          <el-tag type="success" style="margin-left: 10px;">可选课程: {{ availableCourses }}</el-tag>
        </div>
      </div>
      
      <div class="schedule-toolbar">
        <div class="schedule-filters">
          <el-button size="mini" type="primary" @click="refreshSchedule">
            <i class="el-icon-refresh"></i> 刷新课表
          </el-button>
          <el-button size="mini" type="success" @click="showAutoScheduleDialog">
            <i class="el-icon-magic-stick"></i> 自动排课
          </el-button>
        </div>
        
        <div class="schedule-legend">
          <div class="legend-item">
            <div class="legend-color legend-normal"></div>
            <span>正常课程</span>
          </div>
          <div class="legend-item">
            <div class="legend-color legend-full"></div>
            <span>已满员</span>
          </div>
          <div class="legend-item">
            <div class="legend-color legend-selected"></div>
            <span>已选中</span>
          </div>
        </div>
      </div>
      
      <div class="schedule-container" v-loading="loading" element-loading-text="课表加载中...">
        <div v-if="scheduleList.length === 0" class="schedule-empty">
          <i class="el-icon-warning"></i>
          <p>暂无课程数据</p>
          <el-button type="primary" size="small" @click="handleAdd">
            <i class="el-icon-plus"></i> 添加课程
          </el-button>
        </div>
        
        <table v-else class="schedule-table">
          <thead>
            <tr class="schedule-head">
              <th class="time-header">时间\星期</th>
              <th v-for="day in weekDays" :key="day" class="day-header">
                {{ day }}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(timeSlot, index) in timeSlots" :key="index" class="schedule-row">
              <td class="time-slot">
                <div class="time-period">第{{ timeSlot.period }}节</div>
                <div class="time-range">{{ timeSlot.time }}</div>
              </td>
              <td v-for="day in weekDays" :key="day" class="schedule-cell">
                <div 
                  v-for="course in getCoursesForSlot(day, timeSlot.period)" 
                  :key="course.scheduleId"
                  class="course-card"
                  :class="getCourseCardClass(course)"
                  @click="selectCourse(course)"
                >
                  <div class="course-name">{{ course.courseName }}</div>
                  <div class="course-teacher">{{ course.teacherName }}</div>
                  <div class="course-classroom">{{ course.classroom }}</div>
                  <div class="course-students">
                    <el-tag size="mini" :type="course.currentStudents >= course.maxStudents ? 'danger' : 'success'">
                      {{ course.currentStudents || 0 }}/{{ course.maxStudents }}
                    </el-tag>
                  </div>
                  <div class="course-actions">
                    <el-button 
                      size="mini" 
                      type="text" 
                      @click.stop="handleUpdate(course)"
                    >
                      编辑
                    </el-button>
                    <el-button 
                      size="mini" 
                      type="text" 
                      @click.stop="handleDelete(course)"
                      style="color: #f56c6c;"
                    >
                      删除
                    </el-button>
                  </div>
                </div>
                <div v-if="getCoursesForSlot(day, timeSlot.period).length === 0" class="empty-slot">
                  <i class="el-icon-plus add-course-icon" @click="addCourseToSlot(day, timeSlot.period)"></i>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </el-card>

    <!-- 列表视图 -->
    <el-card v-else class="table-card" shadow="never">
      <div slot="header" class="clearfix">
        <span>课表列表</span>
      </div>
      <el-table v-loading="loading" :data="scheduleList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="课程名称" align="center" prop="courseName" />
        <el-table-column label="教师姓名" align="center" prop="teacherName" />
        <el-table-column label="上课时间" align="center" prop="classTime" width="200" />
        <el-table-column label="教室" align="center" prop="classroom" />
        <el-table-column label="星期" align="center" prop="week" />
        <el-table-column label="最大人数" align="center" prop="maxStudents" />
        <el-table-column label="当前人数" align="center" prop="currentStudents">
          <template slot-scope="scope">
            <el-tag :type="scope.row.currentStudents >= scope.row.maxStudents ? 'danger' : 'success'">
              {{ scope.row.currentStudents || 0 }}/{{ scope.row.maxStudents }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="学期" align="center" prop="semester" />
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-edit"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['schedule:schedule:edit']"
            >修改课程</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['schedule:schedule:remove']"
            >删除课程</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 添加或修改课表管理对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="课程名称" prop="courseName">
              <el-select 
                v-model="form.courseName" 
                placeholder="请选择课程"
                filterable
                style="width: 100%"
                @change="handleCourseChange"
              >
                <el-option
                  v-for="course in courseOptions"
                  :key="course.courseId"
                  :label="`${course.courseName} (${course.department})`"
                  :value="course.courseName"
                >
                  <span style="float: left">
                    <strong>{{ course.courseName }}</strong>
                  </span>
                  <span style="float: right; color: #8492a6; font-size: 13px">
                    {{ course.department }} | {{ course.courseType }}
                  </span>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教师姓名" prop="teacherName">
              <el-select 
                v-model="form.teacherName" 
                placeholder="请选择教师"
                filterable
                style="width: 100%"
                @change="handleTeacherChange"
              >
                <el-option
                  v-for="teacher in teacherOptions"
                  :key="teacher.teacherId"
                  :label="`${teacher.teacherName} (${teacher.department})`"
                  :value="teacher.teacherName"
                >
                  <span style="float: left">
                    <strong>{{ teacher.teacherName }}</strong>
                  </span>
                  <span style="float: right; color: #8492a6; font-size: 13px">
                    {{ teacher.department }} | {{ teacher.title || '无职称' }}
                  </span>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="星期" prop="week">
              <el-select v-model="form.week" placeholder="请选择星期">
                <el-option label="星期一" value="星期一" />
                <el-option label="星期二" value="星期二" />
                <el-option label="星期三" value="星期三" />
                <el-option label="星期四" value="星期四" />
                <el-option label="星期五" value="星期五" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教室" prop="classroom">
              <el-input v-model="form.classroom" placeholder="请输入教室" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="上课时间" prop="classTime">
          <el-input v-model="form.classTime" placeholder="如：周一1-2节，周三3-4节" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="最大人数" prop="maxStudents">
              <el-input-number v-model="form.maxStudents" :min="1" :max="200" placeholder="请输入最大人数" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="学期" prop="semester">
              <el-select v-model="form.semester" placeholder="请选择学期">
                <el-option label="第一学期" value="第一学期" />
                <el-option label="第二学期" value="第二学期" />
                <el-option label="第三学期" value="第三学期" />
                <el-option label="第四学期" value="第四学期" />
                <el-option label="第五学期" value="第五学期" />
                <el-option label="第六学期" value="第六学期" />
                <el-option label="第七学期" value="第七学期" />
                <el-option label="第八学期" value="第八学期" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 自动排课对话框 -->
    <el-dialog title="自动排课设置" :visible.sync="autoScheduleDialog" width="400px" append-to-body>
      <el-form :model="autoScheduleForm" label-width="80px">
        <el-form-item label="目标学期">
          <el-select v-model="autoScheduleForm.semester" placeholder="请选择学期" style="width: 100%">
            <el-option label="第一学期" value="第一学期" />
            <el-option label="第二学期" value="第二学期" />
            <el-option label="第三学期" value="第三学期" />
            <el-option label="第四学期" value="第四学期" />
            <el-option label="第五学期" value="第五学期" />
            <el-option label="第六学期" value="第六学期" />
            <el-option label="第七学期" value="第七学期" />
            <el-option label="第八学期" value="第八学期" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-alert 
            title="自动排课说明" 
            type="info" 
            :closable="false"
            show-icon>
            <div slot="description">
              <p><strong>功能介绍：</strong></p>
              <p>• 系统将根据学生选课情况自动生成课表安排</p>
              <p>• 优先为选课人数多的课程安排时间</p>
              <p>• 自动避免教师时间冲突和教室占用</p>
              <p>• 适合高校标准5天×5时段课表模式</p>
              <p><strong>注意事项：</strong></p>
              <p>• 请确保学生已完成选课后再进行排课</p>
              <p>• 系统将清理已存在的重复课表</p>
              <p>• 无法分配的课程将跳过并提示</p>
            </div>
          </el-alert>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmAutoSchedule">开始排课</el-button>
        <el-button @click="autoScheduleDialog = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSchedule, getSchedule, delSchedule, addSchedule, updateSchedule, generateSchedule } from "@/api/schedule/schedule";
import { listAllCourse } from "@/api/course/course";
import { listAllTeacher } from "@/api/college/teacher";

export default {
  name: "Schedule",
  data() {
    return {
      // 视图模式：schedule(课表视图) 或 table(列表视图)
      viewMode: 'schedule',
      // 选中的课程
      selectedCourse: null,
      // 当前学期
      currentSemester: '第一学期',
      // 周次
      weekDays: ['星期一', '星期二', '星期三', '星期四', '星期五'],
      // 时间段
      timeSlots: [
        { period: '1', time: '08:00-09:40' },
        { period: '2', time: '10:00-11:40' },
        { period: '3', time: '14:00-15:40' },
        { period: '4', time: '16:00-17:40' },
        { period: '5', time: '19:00-20:40' }
      ],
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 课表管理表格数据
      scheduleList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 自动排课对话框
      autoScheduleDialog: false,
      // 自动排课表单
      autoScheduleForm: {
        semester: '第一学期'
      },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseName: null,
        teacherName: null,
        classroom: null,
        semester: null,
        week: null
      },
      // 课程和教师选项
      courseOptions: [], // 课程列表
      teacherOptions: [], // 教师列表
      // 加载状态
      courseLoading: false,
      teacherLoading: false,
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        courseName: [
          { required: true, message: "课程名称不能为空", trigger: "blur" }
        ],
        teacherName: [
          { required: true, message: "教师姓名不能为空", trigger: "blur" }
        ],
        classTime: [
          { required: true, message: "上课时间不能为空", trigger: "blur" }
        ],
        classroom: [
          { required: true, message: "教室不能为空", trigger: "blur" }
        ],
        maxStudents: [
          { required: true, message: "最大人数不能为空", trigger: "blur" }
        ],
        semester: [
          { required: true, message: "学期不能为空", trigger: "change" }
        ],
        week: [
          { required: true, message: "星期不能为空", trigger: "change" }
        ]
      }
    };
  },
  computed: {
    // 计算可选课程数量
    availableCourses() {
      return this.scheduleList.filter(item => (item.currentStudents || 0) < item.maxStudents).length;
    }
  },
  created() {
    this.getList();
    this.loadCourseOptions();
    this.loadTeacherOptions();
    
    // 监听全局数据更新事件
    this.$root.$on('courseDataUpdated', this.handleCourseDataUpdated);
  },
  
  beforeDestroy() {
    // 移除事件监听
    this.$root.$off('courseDataUpdated', this.handleCourseDataUpdated);
  },
  methods: {
    /** 切换视图模式 */
    toggleViewMode() {
      this.viewMode = this.viewMode === 'schedule' ? 'table' : 'schedule';
    },

    /** 获取指定时间段和星期的课程 */
    getCoursesForSlot(day, period) {
      return this.scheduleList.filter(course => {
        if (!course.week || !course.classTime) return false;
        
        // 匹配星期
        if (course.week !== day) return false;
        
        // 匹配时间段
        const classTime = course.classTime;
        if (classTime.includes(period) || classTime.includes(period.replace('-', '至'))) {
          return true;
        }
        
        return false;
      });
    },

    /** 获取课程卡片样式类 */
    getCourseCardClass(course) {
      const classes = ['course-item'];
      if ((course.currentStudents || 0) >= course.maxStudents) {
        classes.push('course-full');
      }
      if (this.selectedCourse && this.selectedCourse.scheduleId === course.scheduleId) {
        classes.push('selected');
      }
      return classes;
    },

    /** 选择课程 */
    selectCourse(course) {
      this.selectedCourse = course;
      this.ids = [course.scheduleId];
      this.single = false;
      this.multiple = true;
    },

    /** 在指定时间段添加课程 */
    addCourseToSlot(day, period) {
      this.handleAdd();
      // 预设时间信息
      this.$nextTick(() => {
        this.form.week = day;
        this.form.classTime = `${day}${period}节`;
      });
    },

    /** 刷新课表 */
    refreshSchedule() {
      this.$message.success('课表刷新中...');
      this.getList();
    },
    
    /** 处理课程数据更新事件 */
    handleCourseDataUpdated() {
      console.log('课表页面收到数据更新通知，开始刷新课表数据');
      // 延迟一点时间刷新，等待后端数据更新完成
      setTimeout(() => {
        this.getList();
      }, 1000);
    },

    /** 自动排课 */
    async generateSchedule() {
      // 首先检查是否有选课记录
      const confirmMessage = `是否确认根据学生选课情况进行自动排课？
      
      注意事项：
      • 系统将清理已存在的重复课表
      • 根据选课人数优先安排热门课程
      • 自动避免教师时间冲突和教室占用
      • 适合高校标准5天×5时段课表模式
      
      请确保学生已完成选课后再进行排课。`;
      
      try {
        await this.$confirm(confirmMessage, '确认自动排课', {
          confirmButtonText: '开始排课',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: false
        });
      } catch {
        this.$message({
          type: 'info',
          message: '已取消自动排课'
        });
        return;
      }

      // 显示加载状态
      this.loading = true;
      const loadingMessage = this.$message({
        message: '正在进行自动排课，请稍候...',
        type: 'info',
        duration: 0, // 不自动关闭
        showClose: false
      });

      try {
        // 调用自动排课API
        const response = await generateSchedule(this.currentSemester);
        
        // 关闭加载提示
        loadingMessage.close();
        this.loading = false;

        if (response.code === 200) {
          this.$modal.msgSuccess(response.msg || '自动排课成功！');
          // 刷新课表数据
          await this.getList();
          
          // 显示成功提示
          this.$notify({
            title: '排课成功',
            message: '已成功生成课表安排，请查看课表视图。',
            type: 'success',
            duration: 5000
          });
        } else {
          this.handleScheduleError(response.msg || '自动排课失败');
        }
      } catch (error) {
        // 关闭加载提示
        loadingMessage.close();
        this.loading = false;
        
        console.error('自动排课错误:', error);
        
        // 处理错误信息
        let errorMessage = '自动排课过程中发生错误，请稍后重试';
        
        if (error.response && error.response.data) {
          errorMessage = error.response.data.msg || errorMessage;
        } else if (error.message) {
          errorMessage = error.message;
        }
        
        this.handleScheduleError(errorMessage);
      }
    },

    /** 处理排课错误 */
    handleScheduleError(errorMessage) {
      // 显示错误提示
      this.$modal.msgError(errorMessage);
      
      // 根据错误类型给出建议
      if (errorMessage.includes('暂无学生选课记录')) {
        this.$notify({
          title: '排课提示',
          message: '请先让学生完成选课，然后再进行自动排课。您可以在选课管理中查看学生选课情况。',
          type: 'warning',
          duration: 8000
        });
      } else if (errorMessage.includes('无法分配')) {
        this.$notify({
          title: '资源不足',
          message: '教室或时间资源不足，请检查课程设置或联系管理员。',
          type: 'warning',
          duration: 8000
        });
      }
    },

    /** 显示自动排课对话框 */
    showAutoScheduleDialog() {
      this.autoScheduleForm.semester = this.currentSemester;
      this.autoScheduleDialog = true;
    },

    /** 确认自动排课 */
    confirmAutoSchedule() {
      this.autoScheduleDialog = false;
      this.currentSemester = this.autoScheduleForm.semester;
      this.generateSchedule();
    },
    /** 查询课表管理列表 */
    getList() {
      this.loading = true;
      listSchedule(this.queryParams).then(response => {
        this.scheduleList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    
    /** 加载课程选项 */
    loadCourseOptions() {
      this.courseLoading = true;
      listAllCourse().then(response => {
        this.courseOptions = response.data || [];
        this.courseLoading = false;
      }).catch(error => {
        console.error('获取课程列表失败:', error);
        this.$message.error('获取课程列表失败');
        this.courseLoading = false;
      });
    },
    
    /** 加载教师选项 */
    loadTeacherOptions() {
      this.teacherLoading = true;
      listAllTeacher().then(response => {
        this.teacherOptions = response.data || [];
        this.teacherLoading = false;
      }).catch(error => {
        console.error('获取教师列表失败:', error);
        this.$message.error('获取教师列表失败');
        this.teacherLoading = false;
      });
    },
    
    /** 课程选择变化处理 */
    handleCourseChange(courseName) {
      const selectedCourse = this.courseOptions.find(course => course.courseName === courseName);
      if (selectedCourse) {
        this.$message({
          message: `已选择课程：${selectedCourse.courseName} (学院：${selectedCourse.department})，请选择授课教师`,
          type: 'success',
          duration: 2000
        });
      }
    },
    
    /** 教师选择变化处理 */
    handleTeacherChange(teacherName) {
      const selectedTeacher = this.teacherOptions.find(teacher => teacher.teacherName === teacherName);
      if (selectedTeacher) {
        this.$message({
          message: `已选择教师：${selectedTeacher.teacherName} (部门：${selectedTeacher.department})，职称：${selectedTeacher.title || '无'}`,
          type: 'success',
          duration: 2000
        });
      }
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        scheduleId: null,
        courseName: null,
        teacherName: null,
        classTime: null,
        classroom: null,
        maxStudents: 30,
        currentStudents: 0,
        semester: null,
        week: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.scheduleId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加课表管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const scheduleId = row.scheduleId || this.ids
      getSchedule(scheduleId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改课表管理";
      });
    },
    /** 提交按钮 */
    async submitForm() {
      // 表单验证
      const valid = await this.$refs["form"].validate().catch(() => false);
      if (!valid) {
        return;
      }

      // 直接提交表单（下拉选择已确保数据有效性）
      if (this.form.scheduleId != null) {
        updateSchedule(this.form).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.open = false;
          this.getList();
        });
      } else {
        addSchedule(this.form).then(response => {
          this.$modal.msgSuccess("新增成功");
          this.open = false;
          this.getList();
        });
      }
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const scheduleIds = row.scheduleId || this.ids;
      this.$modal.confirm('是否确认删除课表编号为\"' + scheduleIds + '\"的数据项？').then(function() {
        return delSchedule(scheduleIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('schedule/schedule/export', {
        ...this.queryParams
      }, `schedule_${new Date().getTime()}.xlsx`)
    },


  }
};
</script>
<style scoped>
.app-container {
  background-color: #f5f7f9;
  padding: 20px;
}

.search-card,
.operation-card,
.table-card,
.schedule-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  margin-bottom: 1rem;
}

.mb8 {
  margin-bottom: 8px;
}

/* ==================== 高校课表样式 ==================== */

/* 课表卡片样式 */
.schedule-card {
  border-radius: 12px;
  overflow: hidden;
  background: #ffffff;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

/* 课表头部 */
.schedule-header {
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: -20px -20px 20px -20px;
  border-bottom: 1px solid #eee;
}

.schedule-title {
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.schedule-title i {
  font-size: 20px;
}

.schedule-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.schedule-info .el-tag {
  font-weight: 500;
}

/* 课表工具栏 */
.schedule-toolbar {
  background: white;
  padding: 16px 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: -20px -20px 20px -20px;
}

.schedule-filters {
  display: flex;
  gap: 12px;
  align-items: center;
}

.schedule-legend {
  display: flex;
  gap: 16px;
  align-items: center;
  font-size: 12px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 2px;
}

.legend-normal {
  background: linear-gradient(135deg, #E6F7FF 0%, #F6FFED 100%);
}

.legend-full {
  background: linear-gradient(135deg, #FFF2F0 0%, #FFEBE6 100%);
}

.legend-selected {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 课表容器 */
.schedule-container {
  padding: 0;
  overflow-x: auto;
  background: transparent;
}

/* 课表表格 */
.schedule-table {
  width: 100%;
  min-width: 800px;
  border-collapse: separate;
  border-spacing: 0;
  background: transparent;
}

/* 课表表头 */
.schedule-head {
  background: #ffffff;
}

.time-header,
.day-header {
  background: #F0F9FF;
  color: #1890FF;
  text-align: center;
  padding: 16px 8px;
  font-weight: 600;
  font-size: 14px;
  border: 1px solid #E8F4FD;
  position: relative;
  overflow: hidden;
}

.time-header {
  width: 100px;
  background: #F0F9FF;
}

/* 课表行 */
.schedule-row {
  height: 120px;
}

/* 时间槽 */
.time-slot {
  background: #F0F9FF;
  color: #1890FF;
  text-align: center;
  padding: 16px 8px;
  border: 1px solid #E8F4FD;
  width: 100px;
  position: relative;
  overflow: hidden;
}

.time-period {
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 4px;
}

.time-range {
  font-size: 11px;
  opacity: 0.8;
  color: #909399;
}

/* 课表单元格 */
.schedule-cell {
  background: #ffffff;
  border: 1px solid #E8F4FD;
  padding: 4px;
  vertical-align: top;
  position: relative;
  min-height: 120px;
  transition: all 0.3s ease;
}

.schedule-cell:hover {
  background: #FAFCFF;
}

/* 课程卡片 */
.course-card {
  background: linear-gradient(135deg, #E6F7FF 0%, #F6FFED 100%);
  border: 1px solid #D9F7BE;
  border-radius: 6px;
  padding: 8px;
  margin: 2px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  color: #262626;
}

.course-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.course-card.course-full {
  background: linear-gradient(135deg, #FFF2F0 0%, #FFEBE6 100%);
  border-color: #FFA39E;
}

.course-card.course-full .course-name {
  color: #CF1322;
}

.course-card.selected {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-color: #667eea;
  transform: scale(1.02);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.3);
}

/* 课程信息 */
.course-name {
  font-size: 13px;
  font-weight: 600;
  margin-bottom: 3px;
  line-height: 1.3;
  color: #262626;
}

.course-teacher {
  font-size: 11px;
  margin-bottom: 2px;
  color: #52C41A;
}

.course-classroom {
  font-size: 11px;
  margin-bottom: 4px;
  color: #1890FF;
}

.course-students {
  margin-bottom: 4px;
}

.course-students .el-tag {
  font-size: 10px;
  padding: 1px 4px;
  height: auto;
  line-height: 1.2;
}

/* 课程操作按钮 */
.course-actions {
  display: flex;
  gap: 4px;
  opacity: 0;
  transition: opacity 0.3s ease;
  position: absolute;
  bottom: 4px;
  right: 4px;
}

.course-card:hover .course-actions {
  opacity: 1;
}

.course-actions .el-button {
  padding: 2px 4px;
  font-size: 10px;
  min-height: auto;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.9);
  color: #409eff;
}

.course-actions .el-button:hover {
  background: #409eff;
  color: white;
  transform: scale(1.05);
}

/* 空白时间段 */
.empty-slot {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100px;
  border: 2px dashed #E8F4FD;
  border-radius: 6px;
  background: #FAFCFF;
  transition: all 0.3s ease;
}

.empty-slot:hover {
  border-color: #1890FF;
  background: #F0F9FF;
}

.add-course-icon {
  font-size: 20px;
  color: #1890FF;
  cursor: pointer;
  transition: all 0.3s ease;
}

.add-course-icon:hover {
  color: #096dd9;
  transform: scale(1.2) rotate(90deg);
}

/* 课表数据为空时的样式 */
.schedule-empty {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.schedule-empty i {
  font-size: 48px;
  margin-bottom: 16px;
  display: block;
  color: #ddd;
}

/* 验证错误提示样式 */
.validation-error {
  color: #f56c6c;
  font-size: 12px;
  line-height: 1;
  padding-top: 4px;
  position: absolute;
  top: 100%;
  left: 0;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .schedule-container {
    padding: 0;
  }
  
  .schedule-table {
    min-width: 700px;
  }
  
  .time-header,
  .day-header {
    padding: 12px 6px;
    font-size: 13px;
  }
  
  .time-slot {
    padding: 12px 6px;
    width: 90px;
  }
  
  .course-card {
    padding: 6px;
    margin: 1px;
  }
  
  .course-name {
    font-size: 12px;
  }
  
  .course-teacher,
  .course-classroom {
    font-size: 10px;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 10px;
  }
  
  .schedule-card {
    margin-bottom: 10px;
  }
  
  .schedule-table {
    min-width: 600px;
  }
  
  .time-header,
  .day-header {
    padding: 8px 4px;
    font-size: 12px;
  }
  
  .time-slot {
    padding: 8px 4px;
    width: 80px;
  }
  
  .time-period {
    font-size: 12px;
  }
  
  .time-range {
    font-size: 10px;
  }
  
  .course-card {
    padding: 4px;
  }
  
  .course-name {
    font-size: 11px;
    margin-bottom: 2px;
  }
  
  .course-teacher,
  .course-classroom {
    font-size: 9px;
    margin-bottom: 1px;
  }
  
  .course-actions .el-button {
    font-size: 9px;
    padding: 1px 3px;
  }
}
</style>
