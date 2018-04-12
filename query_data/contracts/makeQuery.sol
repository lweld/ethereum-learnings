pragma solidity ^0.4.18;

import "./usingOraclize.sol";

contract makeQuery is usingOraclize {

    uint public theResult;
    event secondRainfall(uint price);

    function makeQuery() {
        OAR = OraclizeAddrResolverI(/*add OAR outputted by node bridge*/);
        theQuery();
    }

    // Result of query is passed into this function.
    function __callback(bytes32 id, string result) {
        // If the address of the sender of the result isn't the same as address that
        // made the query, don't accept the result of the query.
        if (msg.sender != oraclize_cbAddress()) throw;
        // The query returns a string as the result, so we convert the string to a uint
        // to 2 decimal places, e.g., '23.78' becomes 2378.
        theResult = parseInt(result, 2);
        // Logs the query to the EVM. We can use a JavaScript test to watch for and
        // output this result. We can't use return in __callback so we must use events.
        secondRainfall(theResult);
    }

    // Uses the function, oraclize_query, defined in usingOraclize.sol to make the query.
    function theQuery() payable {
        oraclize_query("URL", "json(https://wt-19530e90680cc09cb0b8e139b494d0f1-0.run.webtask.io/hello).rainfall['2016-01-03']");
    }
}