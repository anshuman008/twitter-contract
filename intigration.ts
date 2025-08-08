import { ethers } from "ethers";
import dotenv from "dotenv";
import { Wallet } from "ethers";
import { Contract } from "ethers";
dotenv.config();

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL!);
const CONTRACT_ADDRESS = "0xBe5aa94E072D2e7ef854C1e0aC3d01FA4911323C";
const wallet = new Wallet(process.env.PRIVATE_KEY!, provider);

const abi = [
  "function addTweet(string calldata tweet)",
  "function addLike(address _authorAddress, uint256 _tweetId)",
  "function unLike(address _authorAddress, uint256 _tweetId)",
  "function addComment(address _authorAddress, uint256 _tweetID, string calldata content)",
  "function changeTweetMaxLength(uint16 _newLen)",
  "function changeCommentMaxLength(uint16 _newLen)",

  // reading ones
  "function getTweet(address _authorAddress, uint256 _id)  external view returns (string memory content, uint256 timestamp, uint256 likes, uint256 commentsCount)",
  "function getAllTweets(address _userAddress) view returns (tuple(uint256 id, string content, uint256 timestamp, address[] likers, tuple(address commenter, string content, uint256 timestamp)[] comments)[] memory)",
  "function getAllLikers(address _authorAddress, uint256 _tweetId) external view returns (address[] memory)",
  "function getAllComments(address _authorAddress, uint256 _tweetID) external  view returns (tuple(address commenter, string content, uint256 timestamp)[])",
  "function getTweetCount(address _authorAddress) external view returns (uint256)",
];

const contract = new Contract(CONTRACT_ADDRESS, abi, wallet);

const addTweet = async (tweet: string) => {
  try {
    const txs = await contract.addTweet(tweet);

    console.log("waiting for confirmation---");
    const recp = await txs.wait();

    console.log("transaction confirmed!--", recp);
  } catch (e) {
    console.log("adding tweet failed!", e);
  }
};

const addLike = async (_authorAddress: string, _tweetId: number) => {
  try {
    const txs = await contract.addLike(_authorAddress, _tweetId);

    console.log("waiting for confirmation---");
    const recp = await txs.wait();

    console.log("transaction confirmed!--", recp);
  } catch (e) {
    console.log("addLike failed!", e);
  }
};

const unLike = async (_authorAddress: string, _tweetId: number) => {
  try {
    const txs = await contract.unLike(_authorAddress, _tweetId);

    console.log("waiting for confirmation---");
    const recp = await txs.wait();

    console.log("transaction confirmed!--", recp);
  } catch (e) {
    console.log("unLike failed!", e);
  }
};

const addComment = async (
  _authorAddress: string,
  _tweetId: number,
  content: string
) => {
  try {
    const txs = await contract.addComment(_authorAddress, _tweetId, content);

    console.log("waiting for confirmation---");
    const recp = await txs.wait();

    console.log("transaction confirmed!--", recp);
  } catch (e) {
    console.log("addComment failed!", e);
  }
};

const getTweet = async (_authorAddress: string, _id: number) => {
  try {
    const data = await contract.getTweet(_authorAddress, _id);

    console.log("here is onchain data--", data);
  } catch (e) {
    console.log("getTweet failed!", e);
  }
};

const getAllTweets = async (_authorAddress: string) => {
  try {
    const data = await contract.getAllTweets(_authorAddress);

    console.log("here is onchain data--", data[0]);
  } catch (e) {
    console.log("getAllTweets failed!", e);
  }
};

const getAllLikers = async (_authorAddress: string, _tweetID: number) => {
  try {
    const data = await contract.getAllLikers(_authorAddress, 0);

    console.log("here is onchain data--", data[0]);
  } catch (e) {
    console.log("getAllTweets failed!", e);
  }
};

const getAllComments = async (_authorAddress: string, _tweetID: number) => {
  try {
    const data = await contract.getAllComments(_authorAddress, 0);

    console.log("here is onchain data--", data[0]);
  } catch (e) {
    console.log("getAllTweets failed!", e);
  }
};

const getTweetCount = async (_authorAddress: string) => {
  try {
    const data = await contract.getTweetCount(_authorAddress);

    console.log("here is onchain data--", data);
  } catch (e) {
    console.log("getAllTweets failed!", e);
  }
};

(async () => {
  // await addTweet("this is my first tweet on blockchain!");
  // await getTweet("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9",0);
  //   await addLike("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9",0);
  //   await unLike("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9", 0);
  // await addComment("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9",0,"superb!");
  //   await getAllTweets("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9");
  // await getAllComments("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9",0);
  // await getAllLikers("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9",0);
  // await getTweetCount("0x178AB9A0e1e1679d086799fffbd2699E4573f4E9");
})();
