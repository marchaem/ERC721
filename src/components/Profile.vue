<template>
    <div>
        <h2 class="pt-3 ml-5">Profile</h2>
        <div class="mt-3 ml-5">
            <strong>Address :</strong> {{ displayId }}
        </div>
        <div class="mt-3 ml-5">
             {{account_balance}}<img src="../../static/ether.png" height="25" width="25">
        </div>
        <div class="row mt-3">
            <div class="col-6 mt-5">
                <form v-on:submit.stop.prevent="createToken()" id="validation_creation" class="was-validated" novalidate>
                    <div class="form-group row mb-4">
                        <label for="public_key" class="col-sm-4 col-form-label">token</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="token_origin" v-model="origin" required>
                            <div class="invalid-feedback">Please enter a number</div>
                        </div>	
                    </div>
                    <button type="submit" class="btn btn-primary btn-wl btn-block">
                        Create a brut Token
                    </button>
                </form>
            </div>
            <div class="col-6 mt-5">
                <form v-on:submit.stop.prevent="refineToken()" id="validation_refine" class="was-validated" novalidate>
                    <div class="form-group row mb-4">
                        <label for="public_key" class="col-sm-4 col-form-label">Token's Id</label>
                        <div class="col-sm-8">
                            <select class="form-control" name="token_to_refine" v-model="token_to_refine" required>
                                <option v-for="id in ids_token_user" v-bind:value="id">
                                    {{id}}
                                </option>
                            </select>
                            <!-- <div class="invalid-feedback">Please select a token within the list</div> -->
                        </div>	
                    </div>
                    <button type="submit" class="btn btn-primary btn-wl btn-block">
                        Refine Token 
                    </button>
                </form>
            </div>
        </div>
        <div class="progress mt-5 ">
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

        <div class="row ml-1">
            <h2 class="">List of user's tokens</h2>
            <div class="offset-md-1 pt-2">
                <img src="../../static/token0.png" height="25" width="25">
                Brut
            </div>
            <div class="offset-md-1 pt-2">
                <img src="../../static/token1.png" height="25" width="25">
                Diesel
            </div>
            <div class="offset-md-1 pt-2">
                <img src="../../static/token2.png" height="25" width="25">
                Gasoline
            </div>
            <div class="offset-md-1 pt-2">
                <img src="../../static/token3.png" height="25" width="25">
                Plastic
            </div>
            
        </div>
        <table class="table table-bordered table-striped ">
            <thead class="thead-dark">
                <tr>
                <th scope="col">ID</th>
                <th scope="col">Type</th>         
                <th scope="col">Origin</th>
                <th scope="col">Refinable</th>
                <th scope="col">Price</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="token_user in tokens_user">
                    <th scope="row">{{token_user.id}}</th>
                    <td><img v-bind:src="token_user.type" height="25" width="25"></td>
                    <td><img v-bind:src="token_user.origin" height="25" width="25"></td>
                    <td><img v-bind:src="token_user.refinable" height="25" width="25"></td>
                    <td>{{token_user.quality}}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>


<script>
  export default {
    name: 'Profile',
    data () {
      return {
        account_balance : 10,

        tokens_user: [],
        ids_token_user : [],

        origin : 0,
        token_to_refine : null,

        custom_width: 0
      }
    },
    props: ['myContract','address','balance','web3'],

    mounted: function () {
        this.account_balance = web3.fromWei(this.balance.toNumber(),'ether');
        console.log(web3.fromWei(this.balance.toNumber(),'ether'))
        this.fetch_data();
    },

    methods: {
      createToken() {
        this.myContract.mintBrut.sendTransaction(this.origin, { from: this.userAddress, gas: 200000}, 
          function(error, result) {
            if(!error){
              console.log(result);
            }
            else{
              alert("Token creation failed, you might no be authorized");
            }        
          });
        this.custom_width = 25
        this.fetch_data();
      },

      refineToken() {
        console.log("to refine "+this.token_to_refine)
          this.myContract.refineToken.sendTransaction(this.token_to_refine, {from: this.userAddress, gas: 600000}, 
          function(error, result) {
            if(!error){
              console.log(result);     
            }
            else{
              alert("Token refining failed, the token might no be refinable");
            }        
          });
        this.custom_width = 50
        this.fetch_data();
        
      },


      getBarrelById(fn) {
        this.myContract.getOwnedBarrels.call({from : this.userAddress}, 
          function(error, result){
            if(!error) {
              console.log("Token's id : " + result)   
              fn(result[0])
            } else {
              console.error(error);
            }      
          });      
      },

      getData(id) {
        this.myContract.getBarrelById.call(id,{from: this.userAddress}, this.addToTokenList)
      },

      fetch_data() {
        this.tokens_user = []
        this.ids_token_user = []
        this.myContract.getOwnedBarrels.call({from : this.userAddress}, this.update_token_ids);
      },

      update_token_ids(error, result) {
        if(!error) {
          console.log("Token's id : " + result);
          for(var i = 0; i < result.length; i++){
            this.ids_token_user.push(result[i].c[0])
            this.getData(result[i].c[0]);
          }
        } else {
          console.error(error);
        }  
      },

      addToTokenList(error, result) {
        if(!error) {
          var img_refinable;
          var img_token;
          var img_origin  = "../../static/france.png";
          if(result[4]) {
            img_refinable = "../../static/002-success.png";
          } else {
            img_refinable = "../../static/001-error.png";
          }
          switch(result[2].c[0]) {
            case 0:
              img_token = "../../static/token0.png";
              break;
            case 1:
              img_token = "../../static/token1.png";
              break;
            case 2:
              img_token = "../../static/token2.png";
              break;
            case 3:
              img_token = "../../static/token3.png";
              break;
            case 4:
              img_token = "../../static/plastic.png";
              break;  
            default:
              break;
          }
          this.tokens_user.push({id: result[0].c[0], type: img_token, 
          quality: result[3].c[0], origin: img_origin, refinable: img_refinable})
        } else {
          console.error(error);
        }  
      }   
    },

    computed: {
        displayId() {
            console.log(this._id, this.address);
            if (this.address == undefined || this.address.length <= 0)
                return "UNKNOWN"
            return this.address;
        }
    }
  }

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
table {
    text-align: center;
}
</style>
