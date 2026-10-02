<template>
  <div class="app-container">
    <el-card class="search-card mb-3" shadow="never">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="教师编号" prop="teacherNo">
          <el-input
            v-model="queryParams.teacherNo"
            placeholder="请输入教师编号"
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
        <el-form-item label="性别" prop="gender">
          <el-select v-model="queryParams.gender" placeholder="请选择性别" clearable>
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属部门" prop="department">
          <el-input
            v-model="queryParams.department"
            placeholder="请输入所属部门"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="operation-card mb-3" shadow="never">
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="primary"
            plain
            icon="el-icon-plus"
            size="mini"
            @click="handleAdd"
            v-hasPermi="['college:teacher:add']"
          >添加教师</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="el-icon-edit"
            size="mini"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['college:teacher:edit']"
          >修改教师</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="el-icon-delete"
            size="mini"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['college:teacher:remove']"
          >删除教师</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            @click="handleExport"
            v-hasPermi="['college:teacher:export']"
          >导出教师</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="info"
            plain
            icon="el-icon-upload2"
            size="mini"
            @click="handleImport"
            v-hasPermi="['college:teacher:import']"
          >导入教师</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>
    </el-card>

    <el-card class="table-card" shadow="never">
      <div slot="header" class="clearfix">
        <span>教师列表</span>
      </div>
      <el-table v-loading="loading" :data="teacherList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="教师ID" align="center" prop="teacherId" v-if="false" />
      <el-table-column label="教师编号" align="center" prop="teacherNo" />
      <el-table-column label="教师姓名" align="center" prop="teacherName" />
      <el-table-column label="性别" align="center" prop="gender">
        <template slot-scope="scope">
          <el-tag :type="scope.row.gender === '男' ? 'primary' : 'success'">
            {{ scope.row.gender }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="所属部门" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.department || '未分配部门' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="职称" align="center" prop="title" />
      <el-table-column label="联系方式" align="center" prop="contact" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['college:teacher:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['college:teacher:remove']"
          >删除</el-button>
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

    <!-- 添加或修改教师信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="教师编号" prop="teacherNo">
              <el-input v-model="form.teacherNo" placeholder="请输入教师编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教师姓名" prop="teacherName">
              <el-input v-model="form.teacherName" placeholder="请输入教师姓名" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择性别" style="width: 100%">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="职称" prop="title">
              <el-select v-model="form.title" placeholder="请选择职称" clearable style="width: 100%">
                <el-option label="教授" value="教授" />
                <el-option label="副教授" value="副教授" />
                <el-option label="讲师" value="讲师" />
                <el-option label="助教" value="助教" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="所属部门" prop="department">
              <treeselect v-model="form.tempDeptId" :options="enabledDeptOptions" :show-count="true" placeholder="请选择归属部门" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系方式" prop="contact">
              <el-input v-model="form.contact" placeholder="请输入联系方式" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <!-- 空列保持布局对齐 -->
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
    
    <!-- 教师数据导入对话框 -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        :headers="upload.headers"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :auto-upload="false"
        drag
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <div class="el-upload__tip" slot="tip">
            <el-checkbox v-model="upload.updateSupport" />是否更新已经存在的教师数据
          </div>
          <span>仅允许导入xls、xlsx格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;" @click="importTemplate">下载模板</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTeacher, getTeacher, delTeacher, addTeacher, updateTeacher } from "@/api/college/teacher";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import {deptTreeSelect} from "@/api/system/user";

export default {
  name: "Teacher",
  components: {Treeselect},
  data() {
    return {
      enabledDeptOptions:[],
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
      // 教师信息表格数据
      teacherList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        teacherNo: null,
        teacherName: null,
        gender: null,
        department: null,
        title: null,
        contact: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        teacherNo: [
          { required: true, message: "教师编号不能为空", trigger: "blur" },
          { pattern: /^T\d{3}$/, message: "教师编号格式为T + 3位数字（如：T001）", trigger: "blur" }
        ],
        teacherName: [
          { required: true, message: "教师姓名不能为空", trigger: "blur" }
        ],
        gender: [
          { required: true, message: "性别不能为空", trigger: "change" }
        ],
        department: [
          { required: true, message: "所属部门不能为空", trigger: "change" }
        ],
        contact: [
          { pattern: /^1[3-9]\d{9}$/, message: "联系方式格式不正确", trigger: "blur" }
        ]
      },
      // 教师导入参数
      upload: {
        // 是否显示弹出层（教师导入）
        open: false,
        // 弹出层标题（教师导入）
        title: "",
        // 是否禁用上传
        isUploading: false,
        // 是否更新已经存在的教师数据
        updateSupport: 0,
        // 设置上传的请求头部
        headers: { Authorization: "Bearer " + this.$store.getters.token },
        // 上传的地址
        url: process.env.VUE_APP_BASE_API + "/college/teacher/importData"
      }
    };
  },
  created() {
    this.getList();
    this.getDeptTree();
  },
  methods: {
    /** 查询部门下拉树结构 */
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = response.data
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(response.data)))
      })
    },
    // 过滤禁用的部门
    filterDisabledDept(deptList) {
      return deptList.filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    // 根据部门ID获取部门名称
    getDeptName(deptId) {
      if (!deptId || !this.deptOptions) return '未分配部门';
      
      const findDept = (depts, id) => {
        for (let dept of depts) {
          if (dept.id === id) {
            return dept.label;
          }
          if (dept.children && dept.children.length) {
            const found = findDept(dept.children, id);
            if (found) return found;
          }
        }
        return null;
      };
      
      return findDept(this.deptOptions, deptId) || '未分配部门';
    },
    /** 查询教师信息列表 */
    getList() {
      this.loading = true;
      listTeacher(this.queryParams).then(response => {
        this.teacherList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        teacherId: null,
        teacherNo: null,
        teacherName: null,
        gender: null,
        department: null,
        tempDeptId: null,
        title: null,
        contact: null,
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
      this.ids = selection.map(item => item.teacherId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加教师管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const teacherId = row.teacherId || this.ids
      getTeacher(teacherId).then(response => {
        this.form = response.data;
        // 根据部门名称找到对应的部门ID用于选择器展示
        if (this.form.department && this.deptOptions) {
          const findDeptId = (depts, deptName) => {
            for (let dept of depts) {
              if (dept.label === deptName) {
                return dept.id;
              }
              if (dept.children && dept.children.length) {
                const found = findDeptId(dept.children, deptName);
                if (found) return found;
              }
            }
            return null;
          };
          this.form.tempDeptId = findDeptId(this.deptOptions, this.form.department);
        }
        this.open = true;
        this.title = "修改教师管理";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 将临时部门ID转换为部门名称
          if (this.form.tempDeptId) {
            this.form.department = this.getDeptName(this.form.tempDeptId);
          }
          
          if (this.form.teacherId != null) {
            updateTeacher(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTeacher(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const teacherIds = row.teacherId || this.ids;
      this.$modal.confirm('是否确认删除教师编号为"' + teacherIds + '"的数据项？').then(function() {
        return delTeacher(teacherIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('college/teacher/export', {
        ...this.queryParams
      }, `teacher_${new Date().getTime()}.xlsx`)
    },
    /** 导入按钮操作 */
    handleImport() {
      this.upload.title = "教师数据导入"
      this.upload.open = true
    },
    /** 下载模板操作 */
    importTemplate() {
      this.download('college/teacher/importTemplate', {}, `teacher_template_${new Date().getTime()}.xlsx`)
    },
    // 文件上传中处理
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true
    },
    // 文件上传成功处理
    handleFileSuccess(response, file, fileList) {
      this.upload.open = false
      this.upload.isUploading = false
      this.$refs.upload.clearFiles()
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", { dangerouslyUseHTMLString: true })
      this.getList()
    },
    // 提交上传文件
    submitFileForm() {
      this.$refs.upload.submit()
    }
  }
};
</script>

<style>
.mb-3 {
  margin-bottom: 1rem;
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
.el-button--primary {
  background-color: #409eff;
  border-color: #409eff;
}

.el-button--success {
  background-color: #67c23a;
  border-color: #67c23a;
}

.el-button--danger {
  background-color: #f56c6c;
  border-color: #f56c6c;
}

.el-button--warning {
  background-color: #e6a23c;
  border-color: #e6a23c;
}
</style>

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
</style>