#Learnings from Programming on Ethereum

Over the past few months I've been building a smart contract on Ethereum for crop insurance startup, [WorldCover] (https://www.worldcovr.com/), to simulate their insurance contracts for farmers in Africa. In this repo I'll share some of my biggest takeaways and ones that I believe aren't well covered online.

### Computing Data Off-Chain

The Ethereum blockchain isn't meant to execute much computation, so write the parts of your program that require intense processing off the blockchain in your favorite programming language. Visit the committed "off-chain_computation" folder to learn how to do so.

### Querying External Data

Smart contracts are referred to as a "walled garden", meaning they need help communicating with the outside world. Visit the committed "query_data" folder see how to use an oracle to fix this.

### General Learnings

I'll try to cover what's not already widely covered online.

##### No hardcoding, loops or memory storage

When you run a program on your computer, you're only having that program run on a single computer that's running a single program. Conversely, the code of a smart contract is executed by all the full nodes on the Ethereum network, thus making it is incredibly taxing for the network to perform any computation or store any memory. You will find that many practices you use to test programs like hardcoding arrays or storing data values are not possible when writing a Solidity smart contract. Similarly, all loops that you rely on to execute programs or compute values are too computationally intense to be executed on the Ethereum blockchain. Look at a smart contract like a judge, it receives some information and based on that information it makes a decision. This means you should do most of your program's computation off-chain and just use your smart contract to make a decision based on the information you computed. Store larger pieces of data on IPFS and store the hash of this data file in your smart contract.

##### Asynchronous execution

Given that your Solidity smart contract won't be running all of your program's logic (it'll use off-chain sources to lighten the work), if you're writing JavaScript calls to test your program, you'll need these calls to return asynchronously. This allows parts of your program to run independently and when specified, requires certain parts to execute only after another part has finished executing. For instance, if you’re making an external query and need to wait a few seconds for the query to be returned, write a callback that only runs part of your program after the query is successfully returned. The calls that promises create aren’t mined on the blockchain and therefore, don’t cost gas.

##### Truffle & Ganache > Remix

If you're testing your smart contract and don't require interaction with third-party tools like Oraclize or IPFS, use the Ganache desktop app (truffleframework.com/ganache/) in conjunction with Truffle. Developed by ConsenSys, this desktop app is "a personal Ethereum blockchain" meaning it'll execute your smart contract code the same way the testnet would. I found this to be much better than using Remix (a browser-based IDE for Solidity smart contracts, remix.ethereum.org) since Remix was often prone to bugs that prevented it from working without you realizing it wasn't working (leaving you to believe your correct code is incorrect) and the Truffle + Ganache combo closely mirrors the actions you'll take via the terminal to execute your contract down the road, so it's best to start now.

##### bytes32 > string or bytes

When you're using a string that has a length of 32 bytes or less, use `bytes32` to identify it as opposed to `string` or `bytes`. This is because the Ethereum virtual machine is optimized for dealing with data in chunks of 32 bytes. The Solidity compiler has to do more work and generate more bytecode when data isn’t in chunks of 32 bytes, which leads to higher gas cost (bytes32 fits into a single word in the EVM, using less gas). Also, since `string` and `bytes` is a dynamically-sized type, contracts can’t read a string or bytes that’s returned from another contract (this is a limitation in Solidity arising from the fact that strings don't fit into a single word in the EVM). Therefore, always try to limit the return value from 1 to 32 bytes.

##### Mappings not objects

Instead of objects (like in Java) there are mappings. The keys of a mapping can be integers, strings, or addresses. You can map a key to anything (including a struct or another mapping). You can’t iterate over a mapping, so if you want to get the output, create an array of the mapping’s keys.

For example, if you were an exchange you could map a user’s address to a struct containing a boolean (true means they're a person, false that they're a business) and a uint (the max amount of ether they can send).

```javascript
mapping(address => userInfo) userMapping;

struct userInfo { 
    bool typeUser; 
    uint maxValue; 
}

function personSentHere() payable {
	userMapping[msg.sender] = userInfo(true, 10); 
}
```

##### Big numbers

If you're using JavaScript to test the output of your smart contract and see that part of the output looks like `BigNumber { s: 1, e: 0, c: [Array] }`, you're being shown the output in BigNumber format. For test results that are of type uint, web3.js puts the result to BigNumber since it's larger than native JavaScript numbers. You can use BigNumber methods in this [library] (https://goo.gl/TEjJrJ) to see the output more clearly.

##### What if potential dApp users don't have an Ethereum wallet?

They would interact with the dApp through a online account like you would with any Web 2.0 website. To facilitate this, create addresses for users who sign up and give ownership of these addresses to a single node. When a user is using your dApp their browser would connect to this node and you would map their user id to an address. You facilitate ether payments to cover gas cost for them on the backend, while charging them in USD via their online account. The dApp stays trustless (smart contracts are still running on Ethereum) but the user would rely on you to interact with the dApp and wouldn’t have control over their digital identity since they're giving your platform their account information.

Another option, if your users have a bit of knowledge of Ethereum but don't have an address to send transactions, you can create an in-browser or in-app signature that's broadcasted to your server to be used as an input parameter to a contract function to prove that a user signed off on transaction even though they're not sending it themselves. You'd still be facilitating transactions for them, this just gives the user identity control. I've never done this but it seems logical in theory.

##### It's new

Be weary of articles or Stack Overflow posts that are over two years old as there's a good chance the platform has changed since then (especially if you're searching for a very granular question). Solidity is also limited in that it doesn't support certain things like fixed point numbers (only use uint) and as mentioned above, has limitations with respect to strings. Lastly, be prepared to find few resources online and technologies to assist you in your development process, it's still sort of the wild west out there!

#####Check these out

Here's some parts of the Solidity docs + other concepts that I found useful. Many of you may have already read these sections but if not, here you go!

* [Function & Variable Visibility] (https://goo.gl/5qZin7)
* [Events] (https://goo.gl/texVkm)
* [Function Modifiers] (https://goo.gl/Ar1iFf)
* [Types (entire page)] (https://goo.gl/LPQV8v)
* [ABI] (https://goo.gl/ut3aNh)
* [Cost of constant function] (https://goo.gl/1Ynq9o)