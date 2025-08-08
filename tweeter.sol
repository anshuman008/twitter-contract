// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Tweeter {
    address admin;
    uint16 public MAX_TWEET_LENGTH = 300;
    uint16 public MAX_COMMENT_LENGTH = 150;

    struct Comment {
        address commenter;
        string content;
        uint256 timestamp;
    }

    struct Tweet {
        uint256 id;
        string content;
        uint256 timestamp;
        address[] likers;
        Comment[] comments;
    }

    event TweetAdded(
        address indexed author,
        uint256 indexed tweetId,
        string tweet
    );
    event CommentAdded(
        address indexed commenter,
        address indexed author,
        uint256 indexed tweetId,
        string comment
    );
    event AddLike(
        address indexed liker,
        address indexed author,
        uint256 tweetId
    );
    event RemoveLike(
        address indexed liker,
        address indexed author,
        uint256 tweetId
    );

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin can access this!");
        _;
    }

    mapping(address => Tweet[]) public tweets;

    function addTweet(string calldata tweet) external {
        require(bytes(tweet).length > 0, "Tweet can't be empty!");
        require(
            bytes(tweet).length <= MAX_TWEET_LENGTH,
            "Tweet content is too long!"
        );

        tweets[msg.sender].push();

        Tweet storage newTweet = tweets[msg.sender][
            tweets[msg.sender].length - 1
        ];
        newTweet.id = tweets[msg.sender].length - 1;
        newTweet.content = tweet;
        newTweet.timestamp = block.timestamp;

        emit TweetAdded(msg.sender, newTweet.id, tweet);
    }

    function getTweet(
        address _authorAddress,
        uint256 _id
    )
        external
        view
        returns (
            string memory content,
            uint256 timestamp,
            uint256 likes,
            uint256 commentsCount
        )
    {
        require(_id < tweets[_authorAddress].length, "Tweet does not exist");

        return (
            tweets[_authorAddress][_id].content,
            tweets[_authorAddress][_id].timestamp,
            tweets[_authorAddress][_id].likers.length,
            tweets[_authorAddress][_id].comments.length
        );
    }

    function getAllTweets(
        address _authorAddress
    ) external view returns (Tweet[] memory) {
        return tweets[_authorAddress];
    }

    function addComment(
        address _authorAddress,
        uint256 _tweetID,
        string calldata content
    ) external {
        require(
            _tweetID < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        require(bytes(content).length > 0, "Comment can't be empty!");
        require(
            bytes(content).length <= MAX_COMMENT_LENGTH,
            "Comment is too long!"
        ); // FIXED: <= instead of <

        Tweet storage targetTweet = tweets[_authorAddress][_tweetID];

        Comment memory newComment = Comment({
            commenter: msg.sender,
            content: content,
            timestamp: block.timestamp
        });

        targetTweet.comments.push(newComment);

        emit CommentAdded(msg.sender, _authorAddress, _tweetID, content);
    }

    function getAllComments(
        address _authorAddress,
        uint256 _tweetID
    ) external view returns (Comment[] memory) {
        require(
            _tweetID < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        return tweets[_authorAddress][_tweetID].comments;
    }

    function addLike(address _authorAddress, uint256 _tweetId) external {
        require(
            _tweetId < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        require(
            !_hasLiked(msg.sender, _authorAddress, _tweetId),
            "Already liked the tweet"
        );

        tweets[_authorAddress][_tweetId].likers.push(msg.sender);

        emit AddLike(msg.sender, _authorAddress, _tweetId);
    }

    function getAllLikers(
        address _authorAddress,
        uint256 _tweetId
    ) external view returns (address[] memory) {
        require(
            _tweetId < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        return tweets[_authorAddress][_tweetId].likers;
    }

    function unLike(address _authorAddress, uint256 _tweetId) external {
        require(
            _tweetId < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        require(
            _hasLiked(msg.sender, _authorAddress, _tweetId),
            "You can't unlike without like"
        );

        _removeLike(msg.sender, _authorAddress, _tweetId);

        emit RemoveLike(msg.sender, _authorAddress, _tweetId);
    }

    function _hasLiked(
        address _userAddress,
        address _authorAddress,
        uint256 _tweetId
    ) private view returns (bool) {
        for (
            uint i = 0;
            i < tweets[_authorAddress][_tweetId].likers.length;
            i++
        ) {
            if (tweets[_authorAddress][_tweetId].likers[i] == _userAddress) {
                return true;
            }
        }
        return false;
    }

    function _removeLike(
        address _userAddress,
        address _authorAddress,
        uint256 _tweetId
    ) private {
        for (
            uint i = 0;
            i < tweets[_authorAddress][_tweetId].likers.length;
            i++
        ) {
            if (tweets[_authorAddress][_tweetId].likers[i] == _userAddress) {
                tweets[_authorAddress][_tweetId].likers[i] = tweets[
                    _authorAddress
                ][_tweetId].likers[
                        tweets[_authorAddress][_tweetId].likers.length - 1
                    ];
                tweets[_authorAddress][_tweetId].likers.pop();
                break;
            }
        }
    }

    function changeTweetMaxLength(uint16 _newLen) external onlyAdmin {
        MAX_TWEET_LENGTH = _newLen;
    }

    function changeCommentMaxLength(uint16 _newLen) external onlyAdmin {
        MAX_COMMENT_LENGTH = _newLen;
    }

    function getTweetCount(
        address _authorAddress
    ) external view returns (uint256) {
        return tweets[_authorAddress].length;
    }

    function getSpecificComment(
        address _authorAddress,
        uint256 _tweetID,
        uint256 _commentIndex
    )
        external
        view
        returns (address commenter, string memory content, uint256 timestamp)
    {
        require(
            _tweetID < tweets[_authorAddress].length,
            "Tweet does not exist"
        );
        require(
            _commentIndex < tweets[_authorAddress][_tweetID].comments.length,
            "Comment does not exist"
        );

        Comment memory comment = tweets[_authorAddress][_tweetID].comments[
            _commentIndex
        ];
        return (comment.commenter, comment.content, comment.timestamp);
    }
}
