<template>
  <div style="max-width: 760px; margin: 40px auto; font-family: Arial, sans-serif;">
    <h2>租户入驻申请</h2>
    <p>提交后进入工作流审批，需完成企业资质信息校验。</p>

    <div style="display: grid; gap: 12px; margin-top: 16px;">
      <input v-model="form.tenantCode" placeholder="租户编码（唯一）" />
      <input v-model="form.tenantName" placeholder="租户名称" />
      <input v-model="form.adminUsername" placeholder="管理员账号" />
      <input v-model="form.adminEmail" placeholder="管理员邮箱" />
      <input v-model="form.companyName" placeholder="企业名称" />
      <input v-model="form.unifiedSocialCreditCode" placeholder="统一社会信用代码（18位）" />
      <input v-model="form.businessLicenseNo" placeholder="营业执照编号" />
      <input v-model="form.contactPhone" placeholder="联系电话" />
    </div>

    <div style="display: flex; gap: 10px; margin-top: 16px;">
      <button @click="submit">提交申请</button>
      <button @click="queryTenant">查询申请</button>
      <button @click="$router.push('/')">返回首页</button>
    </div>

    <pre style="background: #f6f8fa; padding: 12px; border-radius: 8px; margin-top: 16px;">{{ output }}</pre>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { http } from '../api/http'

const output = ref('等待提交...')

const form = reactive({
  tenantCode: '',
  tenantName: '',
  adminUsername: '',
  adminEmail: '',
  companyName: '',
  unifiedSocialCreditCode: '',
  businessLicenseNo: '',
  contactPhone: ''
})

const submit = async () => {
  try {
    const resp = await http.post('/api/tenant-applications', form)
    output.value = `提交成功:\n${JSON.stringify(resp.data, null, 2)}`
  } catch (err) {
    output.value = err?.response?.data ? JSON.stringify(err.response.data, null, 2) : String(err)
  }
}

const queryTenant = async () => {
  if (!form.tenantCode) {
    output.value = '请先输入 tenantCode'
    return
  }
  try {
    const resp = await http.get(`/api/tenant-applications/${form.tenantCode}`)
    output.value = `查询结果:\n${JSON.stringify(resp.data, null, 2)}`
  } catch (err) {
    output.value = err?.response?.data ? JSON.stringify(err.response.data, null, 2) : String(err)
  }
}
</script>
