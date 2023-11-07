import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();

import express from "express";
import redisClient from "./connect.to.redis.js";
import crypto from "crypto";
import fs from "fs";
import transport from "./nodemailer.transport.config.js";

const app = express();

app.use(express.json());

const PORT = 3055;

app.post("/cache/save/email", async (req, res) => {
	const email = req.body.email;

	console.log("email from body => ", email);
	let redisEmailKey;
	let isKeyInUse;

	// generate a random key for redis email cache, and generate new key if the current key is already in use
	do {
		redisEmailKey = crypto.randomBytes(12).toString("base64");
		isKeyInUse = await redisClient.get(redisEmailKey).catch((e) => {
			console.log("error on redis key check");
			console.error(e);
		});
	} while (isKeyInUse);

	console.log(redisEmailKey, " => ", email);

	redisClient
		.SET(redisEmailKey, email, {
			NX: true,
			EX: 17 * 60,
		})
		.then((result) => {
			res.status(200).send(result);
		})
		.catch((e) => {
			console.log("error while saving email to cache.");
			console.error(e);

			res.status(500).send("unable to save email to cache.");
		});
});

app.get("/cache/fetch/email/:key", async (req, res) => {
	const key = req.params.key;
});

app.post("/test/email-sender", (req, res) => {
	const key = crypto.randomBytes(16).toString("base64");

	const htmlMsg = fs
		.readFileSync(`${process.cwd()}/testEmail.html`, "utf8")
		.replace(/{{redis-key}}/, key);

	transport.sendMail(
		{
			to: "grail.masterpiece@gmail.com",
			html: htmlMsg,
			subject: "Cormparse Email Verification",
			priority: "high",
		},
		(err, info) => {
			if (err) {
				console.log("email sending error...");
				console.error(err);

				res.sendStatus(500);
			} else if (info) {
				console.log(info);
				res.sendStatus(200);
			}
		},
	);
});

app.listen(PORT, () => {
	console.log(`cormparse auth support service listing on port ${PORT}`);
});
