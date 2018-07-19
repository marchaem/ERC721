<template>
	<div>
		<div class="row no-gutters pt-4"> 
			<div class="col-5">
				<form v-on:submit.stop.prevent="sell" id="validation_vente" class="was-validated" novalidate>
					<div class="form-group row mb-4 pb-3">
						<label for="token" class="col-sm-4 col-form-label">Token</label>
						<div class="col-sm-8">
							<select class="form-control" name="token_to_refine" v-model="token_to_sell" required>
								<option v-for="id in ids_token_user" v-bind:value="id">
									{{id}}
								</option>
							</select>
							<div class="invalid-feedback">
								Please select a token to sell.
							</div>
						</div>
					</div>
					<div class="form-group row mb-4">
						<label for="price" class="col-sm-4 col-form-label">Price</label>
						<div class="col-sm-8">
							<input type="number" min="1" step="any" class="form-control" id="price" v-model.number="price" required>
							<div class="invalid-feedback">
								Please type a price for your token.
							</div>
						</div>
					</div>
					<div class="form-group row mb-4">
						<label for="end_date" class="col-sm-4 col-form-label">Duration (mn)</label>
						<div class="col-sm-8">
							<input type="number" min="1" step="any" class="form-control" id="end_date"  v-model.number="duration" required>
							<div class="invalid-feedback">
								Please type a duration.
							</div>
						</div>
					</div>
					<button type="submit" class="btn btn-primary btn-wl btn-block">Sell</button>
				</form>
			</div>
			<div class="offset-sm-1"></div>
			<div class="col-5">
				<h2 class="mb-5">List of user's token active selling</h2>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th scope="col">ID</th>
							<th scope="col">Type</th>
							<th scope="col">Quality</th>
							<th scope="col">Origin</th>
							<th scope="col">Refinable</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="token_user in tokens_user_on_sale">
							<th scope="row">{{token_user.id}}</th>
							<td><img v-bind:src="token_user.type" height="25" width="25"></td>
							<td>{{token_user.quality}}</td>
							<td>{{token_user.origin}}</td>
							<td><img v-bind:src="token_user.refinable" height="25" width="25"></td>
						</tr>
					</tbody>
				</table>
				<div class="row float-right mr-1">
					<button type="button" class="btn btn-primary loading" @click="fetch_data">Refresh</button>
				</div>
			</div>
		</div>
		<div class="progress mt-5">
  			<div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" v-bind:style="{width: custom_width + '%'}"></div>
		</div>
		<table class="table table-bordered mb-5" style="table-layout:fixed">
                <thead class="">
                    <tr>
                    <th scope="col">Token Creation</th>
                    <th scope="col">Token refining</th>
                    <th scope="col">Token on sale</th>
                    <th scope="col">Token Sold</th>
                    </tr>
                </thead>
        </table>
	</div>
</template>

<script>
	export default {

		name: 'Vente',

		data () {
			return {
				tokens_user_on_sale: [],
				ids_token_user : [],
				ids_token_user_on_sale : [],

				price: 0,
				duration: null,
				token_to_sell : null,

        		custom_width: 50

			}
		},
		props: ['myContract'],

		created: function () { 
			this.fetch_data();
			this.custom_width= 50
    	},

		methods: {
			sell() {
				console.log("sell :" + this.token_to_sell + this.price + this.duration)
				if (document.getElementById("validation_vente").checkValidity()) {
					this.myContract.createSale.sendTransaction(parseInt(this.token_to_sell),
					 parseInt(this.price), parseInt(this.duration)*60,
						{from : this.userAddress, gas: 2000000},
						function(error, result) {
							if(!error){
								console.log(result);
							} else {
								console.log(error);
							}        
						});
						this.custom_width= 75
						this.fetch_data();
				} else
				alert("Form is not valid");
			},
			fetch_data() {
				this.ids_token_user = []
				this.ids_token_user_on_sale = []
				this.tokens_user_on_sale = []
				this.myContract.getOwnedBarrels.call({from : this.userAddress}, this.update_token_ids);
				this.myContract.getMyTokenOnSale.call({from : this.userAddress},this.update_my_token_ids);

			},

			getData(id) {
        		this.myContract.getBarrelById.call(id,{from: this.userAddress}, this.addToTokenList)
      		},

			update_token_ids(error, result) {
				if(!error) {
				console.log("Token's id : " + result);
					for(var i = 0; i < result.length; i++){
						this.ids_token_user.push(result[i].c[0])
					}
				} else {
				console.error(error);
				}  
			},

			update_my_token_ids(error, result) {
				if(!error) {
				console.log("Token's id : " + result);
					for(var i = 0; i < result.length; i++){
						this.ids_token_user_on_sale.push(result[i].c[0])
						this.getData(result[i].c[0])
					}
				} else {
				console.error(error);
				}  
			},

			addToTokenList(error, result) {
				if(!error) {
					var img_refinable;
					var img_token;
					if(result[4]) {
						img_refinable = "../../static/002-success.png"
					} else {
						img_refinable = "../../static/001-error.png"
					}
					switch(result[2].c[0]) {
						case 0:
						img_token = "../../static/token0.png"
						break;
						case 1:
						img_token = "../../static/token1.png"
						break;
						case 2:
						img_token = "../../static/token2.png"
						break;
						case 3:
						img_token = "../../static/token3.png"
						break;
						default:
						break;
					}
					this.tokens_user_on_sale.push({id: result[0].c[0], type: img_token, 
					quality: result[3].c[0], origin: result[1].c[0], refinable: img_refinable})
				} else {
					console.error(error);
				}  
			}
        }
    }
</script>

<style lang="css" scoped>

table {
    text-align: center;
}

</style>