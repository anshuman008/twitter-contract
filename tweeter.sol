// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;



contract Tweeter {


   address admin;
    uint16 public MAX_TWEET_LENGTH = 300;
   struct Tweet{
    string content;
    uint256 timestamp;
    uint256 likes;
   }


   constructor(){
    admin = msg.sender;
   }

   
  modifier onlyAdmin() {
     require(msg.sender == admin,"Only Admin can access this!");
     _;
  }
  


  mapping (address => Tweet[]) public  tweets;


  function addTweet (string memory tweet) public  {
    require(bytes(tweet).length > 0,"tweet cant be empty!");
    require(bytes(tweet).length <= MAX_TWEET_LENGTH ,"tweet content is too long!");

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


  function changeTweetMaxLength(uint16 _newLen) public   onlyAdmin  {
     MAX_TWEET_LENGTH = _newLen;
  }

}