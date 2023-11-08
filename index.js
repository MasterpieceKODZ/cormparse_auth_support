import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();

import express from "express";
import redisClient from "./connect.to.redis.js";
import crypto from "crypto";
import fs from "fs";
import transport from "./nodemailer.transport.config.js";

const app = express();

app.use(express.json());

app.get("/", async (req, res) => {
	res.send("Welcome to CORMPARSE AUTHENTICATION SUPPORT SERVICE.");
});

app.post("/cache/save/email", async (req, res) => {
	const email = req.body.email;

	// generate a random key for redis email cache, and generate a new key if the current key is already in use

	let redisEmailKey;
	let isKeyInUse;

	do {
		redisEmailKey = crypto.randomBytes(12).toString("base64");
		isKeyInUse = await redisClient.get(redisEmailKey).catch((e) => {
			console.log("error on redis key check");
			console.error(e);
		});
	} while (isKeyInUse);

	console.log(redisEmailKey, " => ", email);

	// store email in redis cache db
	const result = await redisClient
		.SET(redisEmailKey, email, {
			NX: true,
			EX: 17 * 60,
		})
		.catch((e) => {
			console.log("error while saving email to cache.");
			console.error(e);
		});

	if (result == "OK") {
		// send verification email

		const expDateTime = new Date(Date.now() + 40 * 60 * 1000);
		let expMonth;
		switch (expDateTime.getMonth()) {
			case 0:
				expMonth = "JAN";
				break;
			case 1:
				expMonth = "FEB";
				break;
			case 2:
				expMonth = "MAR";
				break;
			case 3:
				expMonth = "APR";
				break;
			case 4:
				expMonth = "MAY";
				break;
			case 5:
				expMonth = "JUN";
				break;
			case 6:
				expMonth = "JUL";
				break;
			case 7:
				expMonth = "AUG";
				break;
			case 8:
				expMonth = "SEPT";
				break;
			case 9:
				expMonth = "OCT";
				break;
			case 10:
				expMonth = "NOV";
				break;
			default:
				expMonth = "DEC";
		}

		const expString = `${expMonth} ${expDateTime.getDate()}, ${expDateTime.getFullYear()} at ${expDateTime.getHours()}:${expDateTime.getMinutes()}`;

		const continueURL =
			process.env.NODE_ENV == "production"
				? "https://cormparse.ddns.net"
				: "http://localhost:3055";

		const html = fs
			.readFileSync(`${process.cwd()}/verification.email.html`, "utf8")
			.replace("{{redis-key}}", redisEmailKey)
			.replace("{{link-expire-time}}", expString)
			.replace("{{continue-url}}", continueURL);

		const info = await transport
			.sendMail({
				from: '"Cormparse" cormparse@gmail.com',
				to: email,
				subject: "Verify Email",
				html,
				priority: "high",
			})
			.catch((e) => {
				res.status(500).send("Failed");

				// delete email address from cache if sending verification email fails
				redisClient.del(redisEmailKey);
				console.log("email sending failed");
				console.error(e);
			});

		if (info.accepted[0]) {
			console.log(info);
			res.sendStatus(200);
		} else {
			res.status(500).send("address rejected");

			// delete email address from cache if sending verification email fails
			redisClient.del(redisEmailKey);
		}
	} else {
		res.status(500).send("cache failed");
	}
});

const PORT = 3055;

app.listen(PORT, () => {
	console.log(`cormparse auth support service listing on port ${PORT}`);
});
