# Computing Data Off-Chain 

In your past work as a developer, performing some computation on a set of data could be as easy as writing a loop, and retrieving external data simply required that you import a library and use functions within that library to retrieve/parse the data. This is possible since the program you wrote is being executed by your computer, which can easily handle the processing/memory storage of a single program.

A smart contract is like a judge, it receives some information and based on that information it makes a decision. Since the code of a smart contract is executed by all the full nodes on the Ethereum network, it is incredibly taxing for the network to perform any computation or store any memory. Therefore, Solidity smart contracts (often referred to as a “walled garden”) are unable to query/parse external data and writing loops is highly discouraged as it'll drain your gas. To fix this you can use an [oracle](https://goo.gl/YzJKH9), which is a trusted third party you to talk to when you need data that you cannot get by yourself. The top oracle service for blockchains is [Oraclize](https://goo.gl/dsAQ9s) and in this tutorial I will explain how to use Oraclize to perform computation on external data off the blockchain, and bring the result of this computation to your smart contract.

Here's a general flow of how this works:

1. Create a Docker image that queries/parses external data and computes things with this data.
2. Store the zip of your Docker image to IPFS.
3. Call Oraclize's computation datasource from within your smart contract and pass it the hash of your image on IPFS.
4. Oraclize receives the query request from your smart contract, retrieves your Docker image from IPFS, creates an instance of an AWS virtual machine to execute the image, and returns the result to your smart contract.

Overall, this allows you to use your favourite programming language to perform the messy work that your Solidity smart contract and the Ethereum blockchain isn't meant to do.

### Creating a Docker Image

The best tutorial for how to use Docker is [Docker](https://goo.gl/13zwhC) itself. I'll be providing a general overview. 

Linux containers are a way of packaging software. If I write a program that requires say a node package or other installations that prevent it from easily running on anyone's computer (i.e., dependencies), I can put the program and all its dependencies in a container. If someone wants to run my program they can simply run this container, which will execute the program. Containers never install anything on your computer when you run them. 

Docker is an easy way to create and use applications with Linux containers. A Docker image is the package that includes everything you need to run an application. A Docker container is an image after its been executed.

There are three parts of our Docker image: 

* Dockerfile: defines a 'build process', which are instructions that Docker reads to build an image. It defines the environment your application runs in. Comments in the Dockerfile explains how it works. 
* computation_test.py: a python program that does everything we want out smart contract to do, i.e., query/parse external data and perform some computation on this data.
* requirements.txt: dependencies that are needed to run our program. If you write Flask in requirements.txt, your application in the container is in an environment with access to Flask.

Test out the Docker image by downloading the computation_docker folder. Open the terminal and write `cd ../computation_docker`, then `docker build -t firsttest .`, then `docker run firsttest`. The output of the Python program in the computation_docker folder should display on the terminal window.

After building an image on your computer it's stored in your local Docker image repository, so to run it a second time you don't have to change the directory and can skip the build step, just open the terminal and write `docker run firsttest`.

### Storing on IPFS

In order to do anything on the IPFS network (e.g., add files, retrieve files) you need to have a node running. Do so by writing `ipfs daemon` on the terminal. You likely need a daemon running since IPFS doesn't follow a client-server model where the application I’m interacting with already has a server running to facilitate my requests. As a peer in the network, I have to serve myself.

The file we add to IPFS that will later be executed by Oraclize has to be in zip format. I've already created a zip file of the Docker folder and added it to IPFS but if you were to do it yourself, highlight all the files in the Docker folder at once and compress them. Add this zip file to IPFS by simply opening a new tab on your terminal window running the daemon and write `cd ../computation_docker`, then `ipfs add Dockerfile.zip`. The terminal returns a hash of your file on the IPFS network. This hash is like a highway to your file, so save it and paste it in your smart contract's oraclize query.

### Using Oraclize's Computation Datasource

Download the committed files in each folder to its corresponding folder in your truffle box.

Git clone the [ethereum-bridge repo](https://goo.gl/sz2Gxg) and open the repo as a folder in the terminal, don’t install the bridge yet. The bridge allows your blockchain node (e.g., Geth, Ganache) to communicate with the Oraclize service. Make sure you have an older version of Python (2.5 - 3.0) and Xcode command tools downloaded as this will help with future installations. If you want to write JavaScript tests to output the result of your contract, install [ethereumjs-abi](https://goo.gl/mghcRe) by doing `npm install ethereumjs-abi` on the ethereum-bridge-master folder. To avoid closed permission settings ensure node version manager is installed, then use nvm to install node.

Open another terminal window and install [Ganache CLI](https://goo.gl/HSJNn7) by typing `npm install -g ganache-cli` and run it by typing `ganache-cli`. This is our ethereum client, i.e., node on the blockchain (it's a rebranding of testrpc and is listening on port 8545). Don’t use the Ganache desktop app as it's not a node on the testnet, so the ethereum bridge won’t interact with accounts on the desktop app. 

Next, on the terminal window with the bridge directory open, install the bridge by typing `node bridge -a 1 dev`. This will generate a keys.json file (special configuration file for the ethereum-bridge) for account 1 (ganache generates 10 accounts, the one you use doesn't matter). The two terminal windows should start processing. The window containing the node will create 2 contracts and process 8 transactions. These are the resolver and connector contracts that Oraclize needs deployed on your network when you run your contracts with the oraclizeAPI.sol file.

Open a third terminal window and cd to the folder containing your smart contract. Compile the contract by running `truffle compile`. Once the 8 transactions on the ganache window have processed and it begins emitting “eth_getFilterChanges”, type `truffle migrate -reset`. Wait 2-3 minutes and watch the bridge window, it'll return "20", which is what's returned from this repo's Docker image.
