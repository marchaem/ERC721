<template>
    <div class="row ml-1">
            <h2 class="">Tokens on sale</h2>
           <table class="table table-bordered table-striped ">
            <thead class="thead-dark">
                <tr>
                    <th scope="col" width="55">ID</th>
                    <th scope="col" width="65">Type</th>
                    <th scope="col" width="45">Seller</th>
                    <th scope="col">Past</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="token_telling in tokens_on_sale">
						<td>{{token_telling.id}}</td>
						<td><img v-bind:src="token_telling.type" height="25" width="25"></td>
						<td>{{token_telling.seller}}</td>
						<td>ID : {{token_telling.past}} from <img v-bind:src="token_telling.origin" height="25" width="25"></td>
					</tr>
            </tbody>
        </table>        
        </div>
</template>

<script>
  export default {
    name: 'Historique',
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
        fetch_data() {
        	this.tokens_on_sale = [];
        	this.ids_token_on_sale = [];
        	this.myContract.getTokensOnSale.call({from : this.userAddress}, this.update_token_ids);
        },
          getAuctionData(id) {
        	this.myContract.getAuction.call(id,{from: this.userAddress}, this.addToTokenList);
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
                var img_token;
                var img_origin;
                console.log("l'id vaut " + result[0].c[0]);
                var _type = this.myContract.getBarrelById.call(result[0].c[0]);
                console.log("_type vaut : "+ _type);
                var prevToken = Number(this.myContract.previousToken.call(result[0].c[0]));
                switch(Number(_type[2])) {
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
                        case 4:
                            img_token = "../../static/plastic.png"
                            break;
						default:
						break;
                    }
                switch(Number(_type[1]))  {
                        case 0:
                            img_origin = "../../static/france.png"
                            break;
						case 1:
                            img_origin = "../../static/saudi.png"
                            break;
                }  
                this.tokens_on_sale.push({
                id: result[0].c[0],
                type: img_token,
                seller: result[1], 
                past: prevToken,
                origin: img_origin
                })
            }
            else {
			console.error(error);
			}  
        },
        getType(id){
            this.myContract.getBarrelById.call(id,{from: this.userAddress},
            function(error,result){
                 if(!error){
                     console.log("type vaut : " + result);
                 }
                 else{
                     console.error(error);
                 }
            });
        },
        getPreviousToken(id){
            this.myContract.previousToken.call(id,{from: this.userAddress},
            function(error,result){
                 if(!error){
                     console.log("prevToken vaut : " + result);
                 }
                 else{
                     console.error(error);
                 }
            });
        }

    }
  }    
</script>