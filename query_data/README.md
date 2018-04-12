# Querying External Data

In your past work as a developer, querying data from some external URL was as easy as importing a library and using the functions within that library to retrieve and parse the data at the URL. This is possible since the program you wrote is being executed by your computer, which can easily handle the processing/memory storage of a single program.

A smart contract is like a judge, it receives some information and based on that information it makes a decision. Since the code of a smart contract is executed by all the full nodes on the Ethereum network, it is incredibly taxing for the network to perform any computation or store any memory. Storing and parsing external data would slow the network. Therefore, Solidity smart contracts (often referred to as a “walled garden”) are unable to query/parse external data. To fix this you can use an [oracle](https://goo.gl/YzJKH9), which is a trusted third party you to talk to when you need data that you cannot get by yourself. The top oracle service for blockchains is [Oraclize](https://goo.gl/dsAQ9s) and in this tutorial I will explain how to use Oraclize to bring external data to your smart contract.

### Let’s get to it

Download the committed files in each folder to its corresponding folder in your truffle box.

Git clone the [ethereum-bridge repo](https://goo.gl/sz2Gxg) and open the repo as a folder in the terminal, don’t install the bridge yet. The bridge allows your blockchain node (e.g., Geth, Ganache) to communicate with the Oraclize service. Make sure you have an older version of Python (2.5 - 3.0) and Xcode command tools downloaded as this will help with future installations. If you want to write JavaScript tests to output the result of your contract, install [ethereumjs-abi](https://goo.gl/mghcRe) by doing `npm install ethereumjs-abi` on the ethereum-bridge-master folder. To avoid closed permission settings ensure node version manager is installed, then use nvm to install node.

Open another terminal window and install [Ganache CLI](https://goo.gl/HSJNn7) by typing `npm install -g ganache-cli` and run it by typing `ganache-cli`. This is our ethereum client, i.e., node on the blockchain (it's a rebranding of testrpc and is listening on port 8545). Don’t use the Ganache desktop app as it's not a node on the testnet, so the ethereum bridge won’t interact with accounts on the desktop app. 

Next, on the terminal window with the bridge directory open, install the bridge by typing `node bridge -a 1 dev`. This will generate a keys.json file (special configuration file for the ethereum-bridge) for account 1 (ganache generates 10 accounts, the one you use doesn't matter). The two terminal windows should start processing. The window containing the node will create 2 contracts and process 8 transactions. These are the resolver and connector contracts that Oraclize needs deployed on your network when you run your contracts with the oraclizeAPI.sol file. The bridge terminal window will output an OAR, add it to your constructor (adding this is the only change you’ll need to make to my code). Note: if your query stops working after running it once, remove the OAR (oraclizeAPI is a deterministic algorithm, so after it reads your OAR once it knows which state, i.e. address, to pass through, reading it again can produce an error).

Open a third terminal window and cd to the folder containing your smart contract. Compile the contract by running `truffle compile`. Once the 8 transactions on the ganache window have processed and it begins emitting “eth_getFilterChanges”, type `truffle migrate -reset` into the terminal window with the smart-contract folder. Wait a few seconds. The query should return on the window running the bridge under "results".

[usingOraclize.sol](https://goo.gl/7yCJei) was downloaded from oraclize. This is the oraclizeAPI. It compiles with your contracts and allows your contracts to make queries using oraclize.

Test your queries before you run your program [here](https://goo.gl/J2aSYZ).
