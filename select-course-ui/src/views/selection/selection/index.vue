<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学生姓名" prop="studentName">
        <el-input
          v-model="queryParams.studentName"
          placeholder="请输入学生姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['selection:selection:add']"
        >添加选课</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['selection:selection:edit']"
        >修改选课</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['selection:selection:remove']"
        >取消选课</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['selection:selection:export']"
        >导出选课数据</el-button>
      </el-col>


      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="selectionList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="学生姓名" align="center" prop="studentName" />
      <el-table-column label="课程名称" align="center" prop="courseName" />
      <el-table-column label="教师姓名" align="center" prop="teacherName" />
      <el-table-column label="选课时间" align="center" prop="selectTime" >
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.selectTime, '{y}-{m}-{d} {h}:{i}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="成绩" align="center" prop="score" >
        <template slot-scope="scope">
          <el-tag v-if="scope.row.score" type="success">{{ scope.row.score }}</el-tag>
          <el-tag v-else type="info">未录入</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" >
        <template slot-scope="scope">
          <el-tag type="success">正常</el-tag>
        </template>
      </el-table-column>
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
            v-hasPermi="['selection:selection:edit']"
          >修改选课</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit-outline"
            @click="handleInputScore(scope.row)"
            v-hasPermi="['selection:selection:edit']"
          >录入成绩</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['selection:selection:remove']"
          >取消选课</el-button>
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

    <!-- 添加或修改选课对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!-- 学生信息验证区域 -->
        <el-card class="student-info-card" shadow="never" style="margin-bottom: 20px;">
          <div slot="header" class="clearfix">
            <span>👨‍🎓 学生信息验证</span>
            <el-button
              v-if="form.studentNo && form.studentName"
              @click="validateStudentInfo"
              type="primary"
              size="mini"
              style="float: right;"
              :loading="validatingStudent"
            >
              验证学生信息
            </el-button>
          </div>
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="学生学号" prop="studentNo">
                <el-input
                  v-model="form.studentNo"
                  placeholder="请输入学生学号"
                  prefix-icon="el-icon-s-custom"
                  clearable
                  maxlength="20"
                  @blur="handleStudentInfoChange"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="学生姓名" prop="studentName">
                <el-input
                  v-model="form.studentName"
                  placeholder="请输入学生姓名"
                  prefix-icon="el-icon-user"
                  clearable
                  maxlength="20"
                  show-word-limit
                  @blur="handleStudentInfoChange"
                >
                  <template slot="suffix">
                    <i
                      v-if="studentValidationStatus === 'success'"
                      class="el-icon-circle-check"
                      style="color: #67C23A;"
                    ></i>
                    <i
                      v-else-if="studentValidationStatus === 'error'"
                      class="el-icon-circle-close"
                      style="color: #F56C6C;"
                    ></i>
                    <i
                      v-else-if="validatingStudent"
                      class="el-icon-loading"
                      style="color: #409EFF;"
                    ></i>
                  </template>
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <!-- 学生信息验证结果显示 -->
          <div v-if="validatedStudentInfo" class="student-info-display">
            <el-alert
              :title="`验证成功：${validatedStudentInfo.studentName}(${validatedStudentInfo.studentNo}) - ${validatedStudentInfo.major || '专业未知'}`"
              type="success"
              :closable="false"
              show-icon
            >
              <template slot="title">
                <span style="font-size: 14px;">
                  ✅ 学生信息验证成功：
                  <strong>{{ validatedStudentInfo.studentName }}</strong>
                  (学号：{{ validatedStudentInfo.studentNo }})
                  <span v-if="validatedStudentInfo.major"> - {{ validatedStudentInfo.major }}</span>
                </span>
              </template>
            </el-alert>
          </div>
        </el-card>

        <!-- 课程选择区域 -->
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="课程名称" prop="courseName">
              <el-select
                v-model="form.courseName"
                placeholder="请选择课程"
                @change="handleCourseChange"
                style="width: 100%"
                class="course-select"
                filterable
                :loading="courseLoading"
                loading-text="加载课程信息中..."
                :disabled="!isStudentValidated"
              >
                <el-option
                  v-for="schedule in availableSchedules"
                  :key="schedule.scheduleId"
                  :label="schedule.courseName"
                  :value="schedule.courseName"
                >
                  <span style="float: left">📚 {{ schedule.courseName }}</span>
                  <span style="float: right; color: #8492a6; font-size: 13px">
                    {{ schedule.teacherName }}
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
                style="width: 100%"
                class="teacher-select"
                :loading="teacherLoading"
                loading-text="加载教师信息中..."
                :disabled="!form.courseName || !isStudentValidated"
              >
                <el-option
                  v-for="schedule in filteredSchedules"
                  :key="schedule.scheduleId"
                  :label="schedule.teacherName"
                  :value="schedule.teacherName"
                >
                  <span style="float: left">👨‍🏫 {{ schedule.teacherName }}</span>
                  <span style="float: right; color: #8492a6; font-size: 13px">
                    {{ schedule.classroom || '教室待定' }}
                  </span>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="选课时间" prop="selectTime">
              <el-date-picker
                v-model="form.selectTime"
                type="datetime"
                placeholder="选择选课时间"
                format="yyyy-MM-dd HH:mm:ss"
                value-format="yyyy-MM-dd HH:mm:ss"
                style="width: 100%"
                prefix-icon="el-icon-time"
                :picker-options="pickerOptions"
                :clearable="false"
                :disabled="!isStudentValidated"
              >
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm" :disabled="!isStudentValidated">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 成绩录入对话框 -->
    <el-dialog title="录入成绩" :visible.sync="scoreDialogVisible" width="400px" append-to-body>
      <el-form ref="scoreForm" :model="scoreForm" :rules="scoreRules" label-width="80px">
        <el-form-item label="学生姓名">
          <el-input v-model="scoreForm.studentName" :disabled="true" />
        </el-form-item>
        <el-form-item label="课程名称">
          <el-input v-model="scoreForm.courseName" :disabled="true" />
        </el-form-item>
        <el-form-item label="成绩" prop="score">
          <el-input-number
            v-model="scoreForm.score"
            :min="0"
            :max="100"
            :precision="1"
            placeholder="请输入成绩(0-100)"
            style="width: 100%;"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitScore">确 定</el-button>
        <el-button @click="scoreDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSelection, getSelection, delSelection, addSelection, updateSelection } from "@/api/selection/selection";
import { getCourseScheduleTeacherName } from "@/api/schedule/schedule";
import { validateStudent } from "@/api/student/student";

export default {
  name: "Selection",
  data() {
    return {
      loading: true,
      courseLoading: false,
      teacherLoading: false,
      validatingStudent: false,  // 学生验证加载状态
      studentValidationStatus: null,  // 学生验证状态：'success', 'error', null
      validatedStudentInfo: null,  // 验证成功的学生信息
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      selectionList: [],
      title: "",
      open: false,
      scoreDialogVisible: false,
      availableSchedules: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentName: null,
        courseName: null,
        teacherName: null
      },
      form: {},
      scoreForm: {},
      rules: {
        studentNo: [
          { required: true, message: "学号不能为空", trigger: "blur" },
          { pattern: /^[0-9a-zA-Z]+$/, message: "学号只能包含数字和字母", trigger: "blur" }
        ],
        studentName: [
          { required: true, message: "学生姓名不能为空", trigger: "blur" },
          { min: 2, max: 20, message: "姓名长度在 2 到 20 个字符", trigger: "blur" }
        ],
        courseName: [
          { required: true, message: "课程名称不能为空", trigger: "change" }
        ],
        teacherName: [
          { required: true, message: "教师姓名不能为空", trigger: "change" }
        ],
        selectTime: [
          { required: true, message: "选课时间不能为空", trigger: "change" }
        ]
      },
      scoreRules: {
        score: [
          { required: true, message: "成绩不能为空", trigger: "blur" },
          { type: 'number', min: 0, max: 100, message: "成绩必须在0-100之间", trigger: "blur" }
        ]
      },
      // 时间选择器配置
      pickerOptions: {
        shortcuts: [{
          text: '现在',
          onClick(picker) {
            picker.$emit('pick', new Date());
          }
        }, {
          text: '一小时后',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() + 3600 * 1000);
            picker.$emit('pick', date);
          }
        }, {
          text: '明天同一时间',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() + 24 * 3600 * 1000);
            picker.$emit('pick', date);
          }
        }],
        disabledDate(date) {
          // 禁止选择过去的日期
          return date.getTime() < Date.now() - 8.64e7;
        }
      }
    };
  },
  computed: {
    filteredSchedules() {
      if (!this.form.courseName) {
        return [];
      }
      return this.availableSchedules.filter(schedule =>
        schedule.courseName === this.form.courseName
      );
    },
    // 判断学生是否已验证
    isStudentValidated() {
      return this.studentValidationStatus === 'success' && this.validatedStudentInfo;
    }
  },
  created() {
    this.getList();
    this.getAvailableSchedules();
  },
  methods: {
    getList() {
      this.loading = true;
      listSelection(this.queryParams).then(response => {
        this.selectionList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 获取可选课程列表 */
    getAvailableSchedules() {
      this.courseLoading = true;
      getCourseScheduleTeacherName().then(response => {
        this.availableSchedules = response.data || [];
        if (this.availableSchedules.length === 0) {
          this.$message({
            message: '暂无可选课程，请联系管理员',
            type: 'warning'
          });
        }
      }).catch(error => {
        console.error('获取课程信息失败:', error);
        this.$message({
          message: '获取课程信息失败，请稍后重试',
          type: 'error'
        });
      }).finally(() => {
        this.courseLoading = false;
      });
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    reset() {
      this.form = {
        selectionId: null,
        studentNo: null,
        studentName: null,
        courseName: null,
        teacherName: null,
        selectTime: null,
        score: null
      };
      // 重置加载状态
      this.courseLoading = false;
      this.teacherLoading = false;
      this.validatingStudent = false;
      // 重置学生验证状态
      this.studentValidationStatus = null;
      this.validatedStudentInfo = null;
      this.resetForm("form");
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.selectionId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 添加选课操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加选课";
    },
    /** 修改选课操作 */
    handleUpdate(row) {
      this.reset();
      const selectionId = row.selectionId || this.ids
      getSelection(selectionId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改选课";
      });
    },
    /** 课程变化处理 - 优化用户体验 */
    handleCourseChange() {
      // 清空教师选择
      this.form.teacherName = null;

      // 获取当前课程对应的教师列表
      const currentCourseTeachers = this.filteredSchedules;

      // 如果只有一个教师，自动选中
      if (currentCourseTeachers.length === 1) {
        this.form.teacherName = currentCourseTeachers[0].teacherName;
        this.$message({
          message: `已自动选择教师：${currentCourseTeachers[0].teacherName}`,
          type: 'success',
          duration: 2000
        });
      } else if (currentCourseTeachers.length > 1) {
        // 多个教师时给出提示
        this.$message({
          message: `该课程有 ${currentCourseTeachers.length} 位教师可选，请选择其中一位`,
          type: 'info',
          duration: 3000
        });

        // 自动聚焦到教师选择框
        this.$nextTick(() => {
          const teacherSelect = this.$el.querySelector('.teacher-select');
          if (teacherSelect) {
            teacherSelect.focus();
          }
        });
      } else if (currentCourseTeachers.length === 0) {
        // 没有可选教师时的提示
        this.$message({
          message: '该课程暂无可选教师，请选择其他课程',
          type: 'warning',
          duration: 3000
        });
      }
    },
    /** 学生信息变化处理 */
    handleStudentInfoChange() {
      // 学生信息变化时重置验证状态
      if (this.studentValidationStatus === 'success') {
        this.studentValidationStatus = null;
        this.validatedStudentInfo = null;
      }

      // 如果学号和姓名都不为空，自动触发验证
      if (this.form.studentNo && this.form.studentNo.trim() &&
          this.form.studentName && this.form.studentName.trim()) {
        // 防抖处理，避免频繁请求
        clearTimeout(this.validateTimer);
        this.validateTimer = setTimeout(() => {
          this.validateStudentInfo();
        }, 500);
      }
    },
    /** 验证学生信息 */
    async validateStudentInfo() {
      const studentNo = this.form.studentNo?.trim();
      const studentName = this.form.studentName?.trim();

      if (!studentNo || !studentName) {
        this.$message({
          message: '请先输入学号和姓名',
          type: 'warning'
        });
        return;
      }

      this.validatingStudent = true;
      this.studentValidationStatus = null;
      this.validatedStudentInfo = null;

      try {
        const response = await validateStudent(studentNo, studentName);

        if (response.code === 200) {
          // 验证成功
          this.studentValidationStatus = 'success';
          this.validatedStudentInfo = response.data;

          this.$message({
            message: `学生信息验证成功：${response.data.studentName}`,
            type: 'success',
            duration: 3000
          });

          // 验证成功后可以选择课程
          this.$nextTick(() => {
            const courseSelect = this.$el.querySelector('.course-select');
            if (courseSelect) {
              courseSelect.focus();
            }
          });
        } else {
          // 验证失败
          this.studentValidationStatus = 'error';
          this.$message({
            message: response.msg || '学生信息不存在或学号与姓名不匹配',
            type: 'error',
            duration: 4000
          });
        }
      } catch (error) {
        console.error('学生信息验证失败:', error);
        this.studentValidationStatus = 'error';
        this.$message({
          message: '验证失败，请稍后重试',
          type: 'error'
        });
      } finally {
        this.validatingStudent = false;
      }
    },
    /** 提交按钮 */
    submitForm() {
      // 首先检查学生是否已验证
      if (!this.isStudentValidated) {
        this.$message({
          message: '请先验证学生信息后再进行选课',
          type: 'warning'
        });
        return;
      }

      this.$refs["form"].validate(valid => {
        if (valid) {
          // 确保提交的数据包含学号
          const submitData = {
            ...this.form,
            studentNo: this.validatedStudentInfo.studentNo,
            studentName: this.validatedStudentInfo.studentName
          };

          if (this.form.selectionId != null) {
            updateSelection(submitData).then(response => {
              this.$modal.msgSuccess("修改选课成功");
              this.open = false;
              this.getList();
              // 通知其他页面数据已更新
              this.$nextTick(() => {
                this.$message({
                  message: '课程状态已更新，相关页面数据将自动刷新',
                  type: 'info',
                  duration: 2000
                });
                // 触发全局数据更新事件
                this.$root.$emit('courseDataUpdated');
              });
            }).catch(error => {
              this.$modal.msgError(error.message || "修改选课失败");
            });
          } else {
            addSelection(submitData).then(response => {
              this.$modal.msgSuccess("添加选课成功");
              this.open = false;
              this.getList();
              // 通知其他页面数据已更新
              this.$nextTick(() => {
                this.$message({
                  message: '课程状态已更新，相关页面数据将自动刷新',
                  type: 'info',
                  duration: 2000
                });
                // 触发全局数据更新事件
                this.$root.$emit('courseDataUpdated');
              });
            }).catch(error => {
              this.$modal.msgError(error.message || "选课失败");
            });
          }
        }
      });
    },
    /** 取消选课操作 */
    handleDelete(row) {
      const selectionIds = row.selectionId || this.ids;
      this.$modal.confirm('是否确认取消选课记录编号为"' + selectionIds + '"的数据项？').then(function() {
        return delSelection(selectionIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("取消选课成功");
        // 通知其他页面数据已更新
        this.$nextTick(() => {
          this.$message({
            message: '课程状态已更新，相关页面数据将自动刷新',
            type: 'info',
            duration: 2000
          });
          // 触发全局数据更新事件
          this.$root.$emit('courseDataUpdated');
        });
      }).catch(() => {});
    },
    handleInputScore(row) {
      const selection = row || this.selectionList.find(item => item.selectionId === this.ids[0]);
      this.scoreForm = {
        selectionId: selection.selectionId,
        studentName: selection.studentName,
        courseName: selection.courseName,
        score: selection.score || null
      };
      this.scoreDialogVisible = true;
    },
    /** 提交成绩 */
    submitScore() {
      this.$refs["scoreForm"].validate(valid => {
        if (valid) {
          const updateData = {
            selectionId: this.scoreForm.selectionId,
            score: this.scoreForm.score
          };
          updateSelection(updateData).then(response => {
            this.$modal.msgSuccess("成绩录入成功");
            this.scoreDialogVisible = false;
            this.getList();
          });
        }
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('selection/selection/export', {
        ...this.queryParams
      }, `selection_${new Date().getTime()}.xlsx`)
    },
    /** 查看选课历史 */
    handleViewHistory() {
      this.$router.push('/history/selection');
    }
  }
};
</script>

<style scoped>
.app-container {
  background-color: #f5f7f9;
  padding: 20px;
}

/* 学生信息验证区域样式 */
.student-info-card {
  border: 2px solid #e4e7ed;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.student-info-card:hover {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.15);
}

.student-info-card ::v-deep .el-card__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 6px 6px 0 0;
  font-weight: 600;
}

.student-info-display {
  margin-top: 15px;
}

.student-info-display .el-alert {
  border-radius: 6px;
}

/* 输入框验证状态样式 */
.el-input.is-success .el-input__inner {
  border-color: #67c23a;
}

.el-input.is-error .el-input__inner {
  border-color: #f56c6c;
}

/* 加载动画 */
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.el-icon-loading {
  animation: spin 1s linear infinite;
}

.search-card,
.operation-card,
.table-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.search-card ::v-deep .el-card__header,
.operation-card ::v-deep .el-card__header,
.table-card ::v-deep .el-card__header {
  background-color: #f8f9fa;
  border-bottom: 1px solid #e9ecef;
  padding: 12px 20px;
  font-weight: 600;
  color: #495057;
}

.search-card ::v-deep .el-form-item {
  margin-bottom: 10px;
}

.mb-3 {
  margin-bottom: 1rem;
}

/* 按钮悬停效果 */
.el-button--primary.is-plain:hover {
  background-color: #409eff;
  border-color: #409eff;
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(64, 158, 255, 0.3);
  transition: all 0.3s ease;
}

.el-button--success.is-plain:hover {
  background-color: #67c23a;
  border-color: #67c23a;
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(103, 194, 58, 0.3);
  transition: all 0.3s ease;
}

.el-button--danger.is-plain:hover {
  background-color: #f56c6c;
  border-color: #f56c6c;
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(245, 108, 108, 0.3);
  transition: all 0.3s ease;
}

.el-button--warning.is-plain:hover {
  background-color: #e6a23c;
  border-color: #e6a23c;
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(230, 162, 60, 0.3);
  transition: all 0.3s ease;
}

.el-button--info.is-plain:hover {
  background-color: #909399;
  border-color: #909399;
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(144, 147, 153, 0.3);
  transition: all 0.3s ease;
}

/* 按钮按下效果 */
.el-button--primary.is-plain:active,
.el-button--success.is-plain:active,
.el-button--danger.is-plain:active,
.el-button--warning.is-plain:active,
.el-button--info.is-plain:active {
  transform: translateY(0);
}

.operation-card ::v-deep .el-button {
  border-radius: 4px;
}

/* 表格样式优化 */
.table-card ::v-deep .el-table {
  border-radius: 4px;
}

.table-card ::v-deep .el-table th {
  background-color: #f8f9fa;
  font-weight: 600;
}

/* 对话框样式优化 */
.el-dialog ::v-deep .el-dialog__header {
  background-color: #f8f9fa;
  border-bottom: 1px solid #e9ecef;
  padding: 15px 20px;
  font-weight: 600;
}

.el-dialog ::v-deep .el-dialog__body {
  padding: 20px;
}

.el-dialog ::v-deep .el-dialog__footer {
  border-top: 1px solid #e9ecef;
  padding: 15px 20px;
}

/* 表单行间距优化 */
.el-row {
  margin-bottom: 15px;
}

/* 操作按钮样式 */
.el-button--primary.is-plain {
  background-color: transparent;
  border-color: #409eff;
  color: #409eff;
}

.el-button--success.is-plain {
  background-color: transparent;
  border-color: #67c23a;
  color: #67c23a;
}

.el-button--danger.is-plain {
  background-color: transparent;
  border-color: #f56c6c;
  color: #f56c6c;
}

.el-button--warning.is-plain {
  background-color: transparent;
  border-color: #e6a23c;
  color: #e6a23c;
}

.el-button--info.is-plain {
  background-color: transparent;
  border-color: #909399;
  color: #909399;
}

/* 成绩标签样式优化 */
.el-tag {
  border-radius: 12px;
  padding: 0 10px;
  font-weight: 500;
}

/* 表格行悬停效果 */
.el-table ::v-deep .el-table__row:hover {
  background-color: #f5f7fa;
}

/* 搜索按钮特效 */
.el-button--primary:not(.is-plain) {
  background: linear-gradient(135deg, #409eff 0%, #36a3ff 100%);
  border: none;
  box-shadow: 0 2px 4px rgba(64, 158, 255, 0.3);
}

.el-button--primary:not(.is-plain):hover {
  background: linear-gradient(135deg, #36a3ff 0%, #2d8cf0 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(64, 158, 255, 0.4);
}

/* 选择框优化样式 */
.course-select ::v-deep .el-input__inner,
.teacher-select ::v-deep .el-input__inner {
  border-radius: 6px;
  transition: all 0.3s ease;
}

.course-select ::v-deep .el-input__inner:focus,
.teacher-select ::v-deep .el-input__inner:focus {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

/* 下拉选项美化 */
.el-select-dropdown ::v-deep .el-select-dropdown__item {
  padding: 12px 20px;
  transition: background-color 0.2s ease;
}

.el-select-dropdown ::v-deep .el-select-dropdown__item:hover {
  background-color: #f5f7fa;
  color: #409eff;
}

.el-select-dropdown ::v-deep .el-select-dropdown__item.selected {
  background-color: #409eff;
  color: white;
  font-weight: 600;
}

/* 加载状态优化 */
.el-loading-spinner .el-loading-text {
  color: #409eff;
  font-weight: 500;
}

/* 表单项间距优化 */
.el-form-item {
  margin-bottom: 22px;
}

.el-form-item__label {
  font-weight: 600;
  color: #303133;
}

/* 输入框聚焦效果 */
.el-input__inner:focus {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

/* 日期选择器优化 */
.el-date-editor ::v-deep .el-input__inner {
  border-radius: 6px;
}

.el-date-editor ::v-deep .el-input__prefix {
  color: #409eff;
}</style>
