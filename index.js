import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();

import express from "express";
import redisClient from "./connect.to.redis.js";
import crypto from "crypto";
import fs from "fs";
import transport from "./nodemailer.transport.config.js";
import { prismaClient } from "./prisma/client.js";
import { hashPassword } from "./secure.password.js";

const app = express();

app.use(express.json());

app.get("/", async (req, res) => {
	res.send("Welcome to CORMPARSE AUTHENTICATION SUPPORT SERVICE.");
});

app.post("/cache/save/email", async (req, res) => {
	console.log("req body @ /cache/save/email", req.body);
	const email = req.body.email;

	try {
		const emailIsUsed = await prismaClient.user.findFirst({
			where: {
				email,
			},
		});

		//during email verification check if email has been used by another user
		if (emailIsUsed && req.body.type == "verification") {
			res.status(400).send("faulty email");
			return;
		} else if (!emailIsUsed && req.body.type == "reset_pw") {
			//during password reset check if there is a user with the provided email address
			res.status(400).send("faulty email");
			return;
		}
	} catch (err) {
		res.status(500).send("email check failed");

		console.log("email check failed...");
		console.error(err);

		return;
	}

	// generate a random 12 char base64 string key for redis email cache, and generate a new key if the generated key is already in use

	let redisEmailKey;
	let isKeyInUse;

	do {
		redisEmailKey = crypto
			.randomBytes(12)
			.toString("base64")
			.replace(/\s/g, "v"); // replace all white space in the generated string with letter v

		// check if key is already in use
		isKeyInUse = await redisClient.get(redisEmailKey).catch((e) => {
			console.log("error on redis key check");
			console.error(e);
		});
	} while (isKeyInUse);

	console.log(redisEmailKey, " => ", email);

	// store email in redis cache db with an expiry period of 30 min
	const result = await redisClient
		.SET(redisEmailKey, email, {
			NX: true,
			EX: 30 * 60,
		})
		.catch((e) => {
			res.status(500).send("error on cache");
			console.log("error while saving email to cache.");
			console.error(e);
		});

	// email successfully saved to redis cache
	if (result == "OK") {
		// send verification email

		const expDateTime = new Date(Date.now() + 30 * 60 * 1000);

		// get month of year name
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

		// format expiry date-time string
		const expString = `${expMonth} ${expDateTime.getDate()}, ${expDateTime.getFullYear()} at ${expDateTime.getHours()}:${expDateTime.getMinutes()}`;

		// frontend service domain
		const frontendURI =
			process.env.NODE_ENV == "production"
				? "https://cormparse.ddns.net"
				: "http://localhost:3000";

		// fetch html email from file and format email template

		// create continueURL based on email type (verication or password reset)
		let continueURL;

		if (req.body.type == "verification") {
			continueURL = frontendURI + "/auth/finish-email-signup";
		} else if (req.body.type == "reset_pw") {
			continueURL = frontendURI + "/auth/reset-password";
		}

		// select email message based on type
		const emailHTML =
			req.body.type == "verification"
				? `${process.cwd()}/verification.email.html`
				: `${process.cwd()}/password.reset.html`;

		// populate email template
		const html = fs
			.readFileSync(emailHTML, "utf8")
			.replace("{{redis-key}}", redisEmailKey)
			.replace("{{link-expire-time}}", expString)
			.replace("{{continue-url}}", continueURL);

		// send email to user email address
		const info = await transport
			.sendMail({
				from: '"Cormparse" cormparse@gmail.com',
				to: email,
				subject:
					req.body.type == "verification" ? "Verify Email" : "Reset Password",
				html,
				priority: "high",
			})
			.catch((e) => {
				res.status(500).send("Failed");

				// delete email address from cache if sending email fails
				redisClient.del(redisEmailKey);
				console.log("email sending failed");
				console.error(e);
			});

		if (info.accepted[0]) {
			// sending email succeeds
			console.log(info);
			res.sendStatus(200);
		} else {
			res.status(500).send("failed");

			// delete email address from cache if sending email fails
			redisClient.del(redisEmailKey);
		}
	} else {
		// failed to cache email address
		res.status(500).send("failed");
	}
});

app.post("/create/username-n-pw/new-user", async (req, res) => {
	try {
		// check if the provided username is already taken
		const usernameIsUsed = await prismaClient.user.findFirst({
			where: {
				username: req.body.username,
			},
		});

		if (usernameIsUsed) {
			res.status(400).send("username taken");
			return;
		}
	} catch (error) {
		res.status(500).send("username check failed");

		console.log("username check failed...");
		console.error(err);

		return;
	}

	// create new user
	try {
		// hash provide password
		const saltNHash = await hashPassword(req.body.password);

		// insert a new user data into DB
		const newUser = await prismaClient.user.create({
			data: {
				email: req.body.email,
				firstname: req.body.firstname,
				lastname: req.body.lastname,
				username: req.body.username,
				role: req.body.role,
				salt: saltNHash.salt,
				passwordHash: saltNHash.hash,
				recentIssuesViewed: [],
				issuesAssigned: [],
			},
		});

		console.log("new user = ", newUser);

		if (!newUser) {
			// user creation failed
			res.status(500).send("create user failed");
			return;
		}

		// user successfully created
		res.sendStatus(200);
		console.log("user created successfully");
	} catch (error) {
		// error while inserting user data into DB
		res.status(500).send("failed");
		console.log("error on create user");
		console.error(error);
	}
});

app.post("/get-user-by-email", async (req, res) => {
	try {
		const user = await prismaClient.user.findFirst({
			where: {
				email: req.body.email,
			},
		});

		console.log("user by prisma = ", user);

		if (user) {
			res.send(user);
		} else {
			res.status(404).send("user not found");
		}
	} catch (err) {
		console.log("error on get-user-by-email");
		console.log(err);

		res.sendStatus(500);
	}
});

app.post("/get-email-from-cache", async (req, res) => {
	console.log("req body @ /get-email-from-cache", req.body);

	try {
		// get email from cache with provided key
		const email = await redisClient.get(req.body.key);

		console.log("email from cache = ", email);
		if (email) {
			res.send(email);

			// remove the email address from cache when you successfully retrieve it, this way verification linlk can only be used once, and it improves cache db storge space management

			redisClient.del(req.body.key).catch((e) => {
				console.log("error on delete email from cache.");
				console.error(e);
			});
		} else {
			res.status(400).send("not found");
		}
	} catch (err) {
		res.status(500).send("failed");
		console.log("error on get-email-from-cache");
		console.error(err);
	}
});

app.post("/reset-password", async (req, res) => {
	const body = req.body;

	const saltNpw = await hashPassword(body.password);

	const setPwRes = await prismaClient.user.update({
		where: {
			email: body.email,
		},
		data: {
			passwordHash: saltNpw.hash,
			salt: saltNpw.salt,
		},
	});

	if (setPwRes) {
		res.sendStatus(200);
	} else {
		res.sendStatus(500);
	}
});

const PORT = 3055;

app.listen(PORT, () => {
	console.log(`cormparse auth support service listing on port ${PORT}`);
});
