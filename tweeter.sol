// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;



contract Tweeter {
    address admin;
    uint16 public MAX_TWEET_LENGTH = 300;


    struct Tweet{
    uint256 id;
    string content;
    uint256 timestamp;
    address[] likers;
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

    tweets[msg.sender].push();
    

    Tweet storage newTweet = tweets[msg.sender][tweets[msg.sender].length - 1];
   

     newTweet.id = tweets[msg.sender].length -1 ;
     newTweet.content = tweet;
     newTweet.timestamp = block.timestamp;

  }


  function getTweet(uint256 _id) external view returns (  string memory content,uint256 timestamp, uint likes) {

     return (
       tweets[msg.sender][_id].content,
       tweets[msg.sender][_id].timestamp,
       tweets[msg.sender][_id].likers.length
     );
  }


  function getallTweets(address _userAddress) external view returns (Tweet[] memory) {

    
    return tweets[_userAddress];
  }

  function addLike(address _userAddress, uint256 _tweetId) public {

    require(_tweetId < tweets[_userAddress].length, "Tweet does not exist");
     require(!_has_liked(msg.sender,_userAddress,_tweetId),"Already liked the tweet");
    
      tweets[_userAddress][_tweetId].likers.push(msg.sender);
  }

  function getAlllikers(address _userAddress, uint256 _tweetId) public view returns (address[] memory) {

    require(_tweetId < tweets[_userAddress].length, "Tweet does not exist");
    return tweets[_userAddress][_tweetId].likers;

  }

  function unLike(address _userAddress, uint256 _tweetId) public {

    require(_tweetId < tweets[_userAddress].length, "Tweet does not exist");
    require(_has_liked(msg.sender,_userAddress,_tweetId),"You cant unlike without like");



     _remove_like(msg.sender,_userAddress,_tweetId);

  }

  function _has_liked(address _userAddress, address _authorAddress, uint256 _tweetId) private view returns (bool) {
    
     for(uint i = 0; i < tweets[_authorAddress][_tweetId].likers.length ; i++){
      if(tweets[_authorAddress][_tweetId].likers[i] == _userAddress ){
        return true;
      }
     }

     return false;

  }

  function _remove_like(address _userAddress, address _authorAddress, uint256 _tweetId) private {

     for(uint i = 0; i < tweets[_authorAddress][_tweetId].likers.length ; i++){
      if(tweets[_authorAddress][_tweetId].likers[i] == _userAddress ){
           tweets[_authorAddress][_tweetId].likers[i] = tweets[_authorAddress][_tweetId].likers[tweets[_authorAddress][_tweetId].likers.length -1];
           tweets[_authorAddress][_tweetId].likers.pop();

           break;
      }
      
     }

    
  }



  function changeTweetMaxLength(uint16 _newLen) public   onlyAdmin  {
     MAX_TWEET_LENGTH = _newLen;
  }

}