pragma solidity ^0.4.18;

import "./usingOraclize.sol";

contract computationQuery is usingOraclize {

    event LogNewOraclizeQuery(string description);
    event LogResult(uint integer);

    function computationQuery() {
        // Proofs indicate that oraclize didn't tamper with anything.
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        update();
    }

    // Result of query is passed into this function.
    function __callback(bytes32 myid, string result, bytes proof) {
        // If the address of the sender of the result isn't the same as address that
        // made the query, don't accept the result of the query.
        if (msg.sender != oraclize_cbAddress()) throw;
        // Last part of the program to be executed. Logs the query to the EVM. We can 
        // use a JavaScript test to watch for and output this result.
        LogResult(parseInt(result));
    }

    // Uses the function, oraclize_query, defined in usingOraclize.sol to make the query.
    // Must be payable so it can have ether sent to it so it can cover gas costs of transactions.
    function update() payable {
        // This if-else block isn't overly necessary for the testnet but is important for the 
        // mainnet since it deals with gas limits.
        if (oraclize.getPrice("computation") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            // Asks Oraclize for the computation datasource and passes the hash of a Docker image.
            oraclize_query("computation",["QmdWnhkcC2eGfcsuFB5J5WjzXvKVPV4XJ2yn93H3nXpZhm", "2"]);
        }
    }
}