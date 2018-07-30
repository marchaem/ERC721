import Vue from 'vue'
import Router from 'vue-router'
import Profile from '@/components/Profile'
import Vente from '@/components/Vente/Vente'
import Achat from '@/components/Achat/Achat'
import Historique from '@/components/Historique/Historique'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'profile',
      component: Profile
    },
    {
      path: '/vente',
      name: 'vente',
      component: Vente
    },
    {
      path: '/achat',
      name: 'achat',
      component: Achat
    },{
      path: '/historique',
      name: 'historique',
      component: Historique
    }
    
  ],
  linkExactActiveClass: "active"
})
