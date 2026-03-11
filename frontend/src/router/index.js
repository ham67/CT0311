import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import TenantRegisterView from '../views/TenantRegisterView.vue'

const routes = [
  { path: '/', component: LoginView },
  { path: '/callback', component: LoginView },
  { path: '/tenant-register', component: TenantRegisterView }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
