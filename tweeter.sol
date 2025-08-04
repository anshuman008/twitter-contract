// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;



contract Tweeter {
   struct Tweet{
    string content;
    uint256 timestamp;
    uint256 likes;
   }
  

  mapping (address => Tweet[]) public  tweets;


  function addTweet (string memory tweet) public  {
    require(bytes(tweet).length > 0,"tweet cant be empty!");
    require(bytes(tweet).length <= 300 ,"tweet content is too long!");

    Tweet memory newTweet = Tweet({
      content: tweet,
      timestamp: block.timestamp,
      likes: 0
    });

    tweets[msg.sender].push(newTweet);
  }


  function getTweet(uint256 _id) external view returns (Tweet memory) {
     return  tweets[msg.sender][_id];
  }


  function getallTweets(address _userAddress) external view returns (Tweet[] memory) {
    return tweets[_userAddress];
  }


}
