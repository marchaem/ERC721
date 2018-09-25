# Tokenisation d'asset financier 

Ce projet rendre dans le cadre de la création de prototype du lab blockchain.

Le prototype ici correspond au cycle de vie de barile de pétrole au travers de l'utilisation du standard de token non-fongible ERC.

## Getting started in localhost

Download and install all dependencies 

    npm install 

This project use truffle as a development environement, testing framework and pipeline for ethereum

This project use ganache-cli to simulate ethereum blockchain

Before using truffle commands, launch ganache in another command line 

    ganache-cli 

Then go to the asset-tokenisation folder and to compile  and deploy your contracts at once with 

    truffle migrate

and test your contract (truffle is using mocha) with your tests with

    truffle test
    
Once your contract deployed, retrieve the contract address from the command line such as

    Deploying AssetTokenSale...
    AssetTokenSale: Ox567.... <= contract address
    
Paste this address in the APP.vue file in the src folder (cd ..) in the startApp() function at the contarctAddress variable

    contractAddress = 0x567... <= paste the contract address here
    
Finally launch the web application in the same folder where the package.json file is located and verify the "start" script in the package.json file line 6 is on dev mode

    "start": "npm run dev"

then launch the application    

    npm start
    
and view the application on port 8080 of your web browser    
    
## Deploying in real BlockChain

Next step is to deploy our application into a real online BlockChain, but in order to not pay with real money for our transactions

We will deploy on an online test Ethereum BlockChain called Ropsten

Step 1 : create an metamask account (only on google chrome) and select ropsten network on the top left

Step 2 : request free eth via this link : https://faucet.metamask.io/

Step 3 : deploy to ropsten network 

    truffle migrate --network ropsten
    
Step 4 : check on etherscan.com on ropsten network that our contract has been correctly deployed     

You won't need to use ganache-cli anymore, now metamask is your Ethereum wallet, you might face some problems with gas shortage. If so, modify gas cost in the truffle.js file

Step 5 : paste new address into APP.vue file at the contarctAddress variable

    contractAddress = 0x134... <= paste address here
    
Step 6 : In order to go from a local to an online deployment, we will use the express module from Node.js

Modify the package.json file, section scripts line 8

    "start": "node server.js"
    
If you want to go back to test mode 
    
    "start": "npm run dev"

Step 7 : run the web application 

    npm start
    
Step 8 : go to localhost port 5000 and test the creation of tokens, if you receive confirmation notifications on metamask the deployment and online transactions work

To go further : go on production wit the application on herokuapp.com for instance to not have to use any command lines
