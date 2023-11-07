import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();
import { createClient } from "redis";
import fs from "fs";

let redisDBPassword;

if (process.env.NODE_ENV == "production") {
	redisDBPassword = fs
		.readFileSync("/run/secrets/redis_pw", "utf-8")
		.toString();
} else {
	redisDBPassword = process.env.REDIS_PW;
}

const redisClient = createClient({
	url: `redis://${process.env.REDIS_USERNAME}:${redisDBPassword}@${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
});

redisClient.on("error", (err) => {
	console.log("redis client error.");
	console.error(err);
});

await redisClient.connect().catch((e) => {
	console.log("error while connecting to redis.");
	console.error(e);
});

if (redisClient.isReady) {
	console.log("redis client is connected successfully.");
}

export default redisClient;
