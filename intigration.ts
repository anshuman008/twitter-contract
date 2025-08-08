import{ethers} from "ethers";
import dotenv from "dotenv";
import { Wallet } from "ethers";
import { Contract } from "ethers";
dotenv.config();


const provider = new ethers.JsonRpcProvider(process.env.RPC_URL!);
const CONTRACT_ADDRESS = "0x31d5fB51C9ED651B8Bcc5C8d4Db514fA4a75B6C5";
const wallet = new Wallet(process.env.PRIVATE_KEY!,provider);

const abi = [
    "function addTweet(string calldata tweet)",
    "function addLike(address _userAddress, uint256 _tweetId)",
    "function unLike(address _userAddress, uint256 _tweetId)",
    "function addComment(address _authorAddress, uint256 _tweetID, string calldata content)",
    "function changeTweetMaxLength(uint16 _newLen)",
    "function changeCommentMaxLength(uint16 _newLen)",

    // reading ones
    "function getTweet(address _authorAddress, uint256 _id)  external view returns (string memory content, uint256 timestamp, uint256 likes, uint256 commentsCount)",
    "function getAllTweets(address _userAddress) external view returns (Tweet[] memory)",
    "function getAllLikers(address _userAddress, uint256 _tweetId) external view returns (address[] memory)",
    "function getAllComments(address _authorAddress, uint256 _tweetID) external  view returns (Comment[] memory)",
    "function getTweetCount(address _userAddress) external view returns (uint256)"
]

const contract = new Contract(CONTRACT_ADDRESS,abi,wallet);

   
