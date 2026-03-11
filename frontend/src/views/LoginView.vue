<template>
  <div style="max-width: 680px; margin: 60px auto; font-family: Arial, sans-serif;">
    <h2>统一登录平台 Demo</h2>
    <p>后端认证中心：Spring Authorization Server，网关限流/风控/审计能力已接入。</p>

    <div style="display: flex; gap: 12px; margin: 20px 0;">
      <button @click="goLogin">跳转授权登录</button>
      <button @click="getMe">调用 /api/users/me</button>
      <button @click="$router.push('/tenant-register')">租户注册</button>
      <button @click="goSsoClient">SSO客户端验证</button>
    </div>

    <pre style="background: #f6f8fa; padding: 12px; border-radius: 8px;">{{ output }}</pre>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { http } from '../api/http'

const output = ref('等待操作...')

const goLogin = () => {
  const params = new URLSearchParams({
    response_type: 'code',
    client_id: 'vue-client',
    scope: 'openid profile',
    redirect_uri: 'http://localhost:5173/callback'
  })
  window.location.href = `http://localhost:8080/oauth2/authorize?${params.toString()}`
}

const goSsoClient = () => {
  window.open('http://localhost:9101/user', '_blank')
}

const getMe = async () => {
  try {
    const resp = await http.get('/api/users/me')
    output.value = JSON.stringify(resp.data, null, 2)
  } catch (err) {
    output.value = err?.response?.data
      ? JSON.stringify(err.response.data, null, 2)
      : String(err)
  }
}
</script>
