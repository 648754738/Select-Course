<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <el-card class="search-card mb-3" shadow="never">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="学号" prop="studentNo">
          <el-input
            v-model="queryParams.studentNo"
            placeholder="请输入学号"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
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
        <el-form-item label="操作类型" prop="operationType">
          <el-select
            v-model="queryParams.operationType"
            placeholder="请选择操作类型"
            clearable
            style="width: 150px"
          >
            <el-option label="取消选课" value="取消选课" />
            <el-option label="选课" value="选课" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作按钮 -->
    <el-card class="operation-card mb-3" shadow="never">
      <el-row :gutter="10" class="mb8">

        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="el-icon-delete"
            size="mini"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['history:selection:remove']"
          >删除记录</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            @click="handleExport"
            v-hasPermi="['history:selection:export']"
          >导出数据</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="info"
            plain
            icon="el-icon-refresh"
            size="mini"
            @click="handleRefresh"
          >刷新数据</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card" shadow="never">
      <div slot="header" class="clearfix">
        <span>选课历史记录</span>
        <div style="float: right;">
          <el-tag type="info" size="small">共 {{ total }} 条记录</el-tag>
        </div>
      </div>

      <el-table v-loading="loading" :data="historyList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="学号" align="center" prop="studentNo" />
        <el-table-column label="学生姓名" align="center" prop="studentName" />
        <el-table-column label="课程名称" align="center" prop="courseName"  show-overflow-tooltip />
        <el-table-column label="教师姓名" align="center" prop="teacherName" />
        <el-table-column label="操作类型" align="center" prop="operationType" >
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.operationType === '取消选课' ? 'danger' : 'success'"
              size="small"
            >
              {{ scope.row.operationType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="原选课时间" align="center" prop="selectTime" width="150">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.selectTime, '{y}-{m}-{d} {h}:{i}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="取消时间" align="center" prop="cancelTime" width="150">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.cancelTime, '{y}-{m}-{d} {h}:{i}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="成绩" align="center" prop="score" width="80">
          <template slot-scope="scope">
            <span v-if="scope.row.score">{{ scope.row.score }}</span>
            <el-tag v-else type="info" size="mini">未录入</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-view"
              @click="handleView(scope.row)"
              v-hasPermi="['history:selection:query']"
            >查看</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['history:selection:remove']"
              style="color: #F56C6C;"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 查看详情对话框 -->
    <el-dialog title="选课历史详情" :visible.sync="viewDialogVisible" width="600px" append-to-body>
      <el-descriptions :column="2" border v-if="currentRecord">
        <el-descriptions-item label="学号">
          <el-tag type="primary" size="small">{{ currentRecord.studentNo }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="学生姓名">{{ currentRecord.studentName }}</el-descriptions-item>
        <el-descriptions-item label="课程名称">{{ currentRecord.courseName }}</el-descriptions-item>
        <el-descriptions-item label="教师姓名">{{ currentRecord.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag :type="currentRecord.operationType === '取消选课' ? 'danger' : 'success'">
            {{ currentRecord.operationType }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="成绩">
          <span v-if="currentRecord.score">{{ currentRecord.score }}</span>
          <el-tag v-else type="info" size="mini">未录入</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="原选课时间">
          {{ parseTime(currentRecord.selectTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
        </el-descriptions-item>
        <el-descriptions-item label="取消时间">
          {{ parseTime(currentRecord.cancelTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">
          {{ parseTime(currentRecord.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="viewDialogVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listHistorySelection, getHistorySelection, delHistorySelection } from "@/api/history/selection";

export default {
  name: "HistorySelection",
  data() {
    return {
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
      // 历史记录表格数据
      historyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查看详情对话框
      viewDialogVisible: false,
      // 当前查看的记录
      currentRecord: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentNo: null,
        studentName: null,
        courseName: null,
        teacherName: null,
        operationType: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询选课历史记录列表 */
    getList() {
      this.loading = true;
      listHistorySelection(this.queryParams).then(response => {
        this.historyList = response.rows;
        this.total = response.total;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
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
      this.ids = selection.map(item => item.selectionId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 查看详情操作 */
    handleView(row) {
      // 如果直接传入了行数据，直接显示详情
      if (row) {
        this.currentRecord = row;
        this.viewDialogVisible = true;
        return;
      }

      // 如果是从操作栏按钮触发，需要检查是否选中了记录
      if (this.ids.length === 0) {
        this.$modal.msgError("请先选择一条记录进行查看");
        return;
      }

      if (this.ids.length > 1) {
        this.$modal.msgError("请只选择一条记录进行查看");
        return;
      }

      // 从选中的记录中找到对应的记录
      const record = this.historyList.find(item => item.selectionId === this.ids[0]);
      if (!record) {
        this.$modal.msgError("未找到选中的记录");
        return;
      }

      this.currentRecord = record;
      this.viewDialogVisible = true;
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const selectionIds = row.selectionId || this.ids;
      this.$modal.confirm('是否确认删除选课历史记录编号为"' + selectionIds + '"的数据项？此操作不可恢复！').then(function() {
        return delHistorySelection(selectionIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('history/selection/export', {
        ...this.queryParams
      }, `history_selection_${new Date().getTime()}.xlsx`);
    },
    /** 刷新数据 */
    handleRefresh() {
      this.getList();
      this.$modal.msgSuccess("数据刷新成功");
    }
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

/* 镂空按钮悬停效果 */
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

/* 按钮按下效果 */
.el-button--primary.is-plain:active,
.el-button--success.is-plain:active,
.el-button--danger.is-plain:active,
.el-button--warning.is-plain:active {
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
  color: #606266;
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

/* 标签样式优化 */
.el-tag {
  font-weight: 500;
}

/* 详情描述样式 */
.el-descriptions ::v-deep .el-descriptions__label {
  font-weight: 600;
  color: #606266;
}
</style>
