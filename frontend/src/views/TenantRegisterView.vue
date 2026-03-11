<template>
  <div style="max-width: 720px; margin: 40px auto; font-family: Arial, sans-serif;">
    <h2>租户注册</h2>
    <p>用于企业/组织入驻统一登录平台，提交后状态默认为待审核。</p>

    <div style="display: grid; gap: 12px; margin-top: 16px;">
      <input v-model="form.tenantCode" placeholder="租户编码（唯一）" />
      <input v-model="form.tenantName" placeholder="租户名称" />
      <input v-model="form.adminUsername" placeholder="管理员账号" />
      <input v-model="form.adminEmail" placeholder="管理员邮箱" />
      <input v-model="form.contactPhone" placeholder="联系电话（可选）" />
    </div>

    <div style="display: flex; gap: 10px; margin-top: 16px;">
      <button @click="submit">提交注册</button>
      <button @click="queryTenant">按租户编码查询</button>
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
  contactPhone: ''
})

const submit = async () => {
  try {
    const resp = await http.post('/api/tenants/register', form)
    output.value = `注册成功:\n${JSON.stringify(resp.data, null, 2)}`
  } catch (err) {
    output.value = err?.response?.data
      ? JSON.stringify(err.response.data, null, 2)
      : String(err)
  }
}

const queryTenant = async () => {
  if (!form.tenantCode) {
    output.value = '请先输入 tenantCode'
    return
  }

  try {
    const resp = await http.get(`/api/tenants/${form.tenantCode}`)
    output.value = `查询结果:\n${JSON.stringify(resp.data, null, 2)}`
  } catch (err) {
    output.value = err?.response?.data
      ? JSON.stringify(err.response.data, null, 2)
      : String(err)
  }
}
</script>
