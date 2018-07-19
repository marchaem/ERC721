<template>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	  <a class="navbar-brand" href="#">Asset Token</a>
	  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
	    <span class="navbar-toggler-icon"></span>
	  </button>
	  <div class="collapse navbar-collapse" id="navbarNavDropdown">
	    <ul class="navbar-nav  mr-auto">
	      <li class="nav-item">
	      	<router-link :to="{name: 'profile'}" class="nav-link"><span>Profile</span></router-link>
	      </li>
	      <li class="nav-item">
	      	<router-link :to="{name: 'vente'}" class="nav-link"><span>Vente</span></router-link>
	      </li>
	      <li class="nav-item">
	      	<router-link :to="{name: 'achat'}" class="nav-link"><span>Achat</span></router-link>
	      </li>
	    </ul>
			<button v-show="islogged == true" class="btn btn-danger my-2 my-sm-0" @click="disconnect()">Disconnect</button>
	  </div>
	</nav>
</template>

<script>
export default {

  name: 'Navbar',

  data () {
    return {

    }
	},

	methods: {
		disconnect() {
			location.reload();
		}
	},
	
	props: ['islogged']
}
</script>

<style lang="css" scoped>
</style>