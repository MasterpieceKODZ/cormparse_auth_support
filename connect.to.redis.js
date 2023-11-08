import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();
import { createClient } from "redis";
import fs from "fs";

// get redis password from container or secrets file

let redisDBPassword;

if (process.env.NODE_ENV == "production" && !process.env.REDIS_PW) {
	redisDBPassword = fs
		.readFileSync("/run/secrets/redis_pw", "utf-8")
		.toString();
} else {
	redisDBPassword = process.env.REDIS_PW;
}

// get redis username from env or container config file
let redisUsername;

if (process.env.NODE_ENV == "production" && !process.env.REDIS_USERNAME) {
	redisUsername = fs.readFileSync("/config/redis_username", "utf-8").toString();
} else {
	redisUsername = process.env.REDIS_USERNAME;
}

// get redis host from env or config file
let redisHost;

if (process.env.NODE_ENV == "production" && !process.env.REDIS_HOST) {
	redisHost = fs.readFileSync("/config/redis_host", "utf-8").toString();
} else {
	redisHost = process.env.REDIS_HOST;
}

// get redis port from env or config file
let redisPort;

if (process.env.NODE_ENV == "production" && !process.env.REDIS_PORT) {
	redisPort = fs.readFileSync("/config/redis_port", "utf-8").toString();
} else {
	redisPort = process.env.REDIS_PORT;
}

let redisURL;

if (!redisUsername) {
	redisURL = `redis://${redisHost}:${redisPort}`;
} else {
	redisURL = `redis://${redisUsername}:${redisDBPassword}@${redisHost}:${redisPort}`;
}

const redisClient = createClient({
	url: redisURL,
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
