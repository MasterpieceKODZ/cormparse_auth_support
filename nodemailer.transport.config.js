import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();

import fs from "fs";
import nodemailer from "nodemailer";

let clientId;
let clientSecret;

if (process.env.NODE_ENV == "production") {
	clientId = fs.readFileSync("/run/secrets/oauth_client_id", "utf8").toString();
	clientSecret = fs
		.readFileSync("/run/secrets/oauth_client_secret", "utf8")
		.toString();
} else {
	clientId = process.env.OAUTH_CLIENT_ID;
	clientSecret = process.env.OAUTH_CLIENT_SECRET;
}

const transport = nodemailer.createTransport({
	host: "smtp.gmail.com",
	port: 465,
	secure: true,
	from: "cormparse@gmail.com",
	auth: {
		type: "OAuth2",
		user: "cormparse@example.com",
		clientId,
		clientSecret,
	},
});

transport.on("idle", () => {
	console.log("a connection is open.");
});
export default transport;
