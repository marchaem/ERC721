<template>
	<div>
		<div v-if="logged">
         <router-view :tokensOnSale="tokens_on_sale" />
      </div>
		<div class="row no-gutters ">
			<div class="row ml-1 mt-3">
				<h2 class="">List of user's tokens</h2>
				<div class="offset-md-1">
					<!-- <button type="button" class="btn loading" @click="fetch_data()">
						<img src="../../static/refresh-button.png" height="25" width="25">
					</button> -->
				</div>
        	</div>
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th scope="col">Date</th>
						<th scope="col">Id</th>
						<th scope="col">Seller</th>
						<th scope="col">End at</th>
						<th scope="col">Price</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="token_telling in tokens_on_sale">
						<th scope="row">{{token_telling.started}}</th>
						<td>{{token_telling.id}}</td>
						<td>{{token_telling.seller}}</td>
						<td>{{token_telling.ended}}</td>
						<td>{{token_telling.price}}</td>
					</tr>
				</tbody>
			</table>
			<div class="col-5 mt-3">
				<form v-on:submit.stop.prevent="buyToken()" id="validation_creation" class="was-validated" novalidate>
					<div class="form-group row mb-4">
						<label for="public_key" class="col-sm-4 col-form-label">Token's Id</label>
						<div class="col-sm-8">
							<select class="form-control" name="token_to_refine" v-model="token_to_buy" @change="getData()" required>
								<option v-for="id in ids_token_on_sale" v-bind:value="id">
									{{id}}
								</option>
							</select>
						</div>	
					</div>
					<div class="form-group row mb-4">
						<label for="price" class="col-sm-4 col-form-label">Price</label>
						<div class="col-sm-8">
							<input type="number" min="1" step="any" class="form-control" id="price" v-model.number="price" required>
							<div class="invalid-feedback">
								Please type a price the token.
							</div>
						</div>
					</div>
					<button type="submit" class="btn btn-primary btn-wl btn-block">Buy</button>
				</form>
			</div>
			<div class="col-6 mt-3">
				<div class="row align-test-left">
					<div class="offset-md-2 col-10 pb-2">Type : <img v-bind:src="token.type" height="25" width="25"></div>
					<div class="offset-md-2 col-10 pb-2">Origin : {{token.origin}}</div>
					<div class="offset-md-2 col-10 pb-2">Refinable : <img v-bind:src="token.refinable" height="25" width="25"></div>

				</div>
			</div>
		</div>	
		<div class="progress mt-5">
      		<div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" v-bind:style="{width: custom_width + '%'}" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>
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

	name: 'Achat',

	data () {
		return {
			tokens_on_sale: [],
			ids_token_on_sale : [],

			token_to_buy : null,
			price: null,
			
			custom_width: 75,

			token : {id: 2, type: "../../static/refresh-button.png", 
				quality: 0, origin: 0, refinable: "../../static/refresh-button.png"}
		}
	},

	props: ['myContract'],

	created: function () { 
		this.fetch_data();
    },

	methods: {
		buyToken() {
			console.log(this.token_to_buy,this.price)
			this.myContract.bid.sendTransaction(this.token_to_buy,{gas :2000000, value : this.price }),
			function(error,result){
				if(!error){
            		console.log(result);
          		}
				else{
					console.log(error);
				}        
			}
			this.fetch_data();
			this.custom_width = 100
		},

		getAuctionData(id) {
        	this.myContract.getAuction.call(id,{from: this.userAddress}, this.addToTokenList)
		},
		
		getData(){
			if(this.token_to_buy != null) {
				this.myContract.getBarrelById.call(this.token_to_buy,{from: this.userAddress}, this.updateInfo)
			}
			
		},

		updateInfo(error, result){
			if(!error) {
				console.log("lol")
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
				this.token = {id: result[0].c[0], type: img_token, 
				quality: result[3].c[0], origin: result[1].c[0], refinable: img_refinable}
				} else {
				console.error(error);
			}
		},

		fetch_data() {
        	this.tokens_on_sale = []
        	this.ids_token_on_sale = []
        	this.myContract.getTokensOnSale.call({from : this.userAddress}, this.update_token_ids);
      	},

		update_token_ids(error, result) {
			if(!error) {
			console.log("Token's id : " + result);
				for(var i = 0; i < result.length; i++){
					this.ids_token_on_sale.push(result[i].c[0])
					this.getAuctionData(result[i].c[0]);
				}
			} else {
				console.error(error);
			}  
		},

		addToTokenList(error, result) {
			if(!error) {
				console.log(result)
				this.tokens_on_sale.push({id: result[0].c[0], seller: result[1], 
										price: result[2].c[0], ended: this.timeStampToDate(result[4].c[0]+result[3].c[0]),
										started: this.timeStampToDate(result[4].c[0])})
			} else {
			console.error(error);
			}  
		},
		
		timeStampToDate(unix_timeStamp){
			var date = new Date(unix_timeStamp*1000);
			// Hours part from the timestamp
			var hours = date.getHours();
			// Minutes part from the timestamp
			var minutes = "0" + date.getMinutes();
			// Seconds part from the timestamp
			var seconds = "0" + date.getSeconds();
			var formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
			return formattedTime;
		}
	}
}
</script>

<style lang="css" scoped>
.align-text-left {
	text-align: left;
}

table {
    text-align: center;
}
</style>