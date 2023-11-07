import dotenv from "dotenv";
if (process.env.NODE_ENV != "production") dotenv.config();

import fs from "fs";
import nodemailer from "nodemailer";
import { google } from "googleapis";

let clientId;
let clientSecret;
let refreshToken;
let appPW;

if (process.env.NODE_ENV == "production") {
	clientId = fs.readFileSync("/run/secrets/oauth_client_id", "utf8");
	clientSecret = fs
		.readFileSync("/run/secrets/oauth_client_secret", "utf8")
		.toString();
	refreshToken = fs.readFileSync("/run/secrets/email_refresh_token", "utf8");
	appPW = fs.readFileSync("/run/secrets/google_app_pw", "utf8");
} else {
	clientId = process.env.OAUTH_CLIENT_ID;
	clientSecret = process.env.OAUTH_CLIENT_SECRET;
	refreshToken = process.env.REFRESH_TOKEN;
	appPW = process.env.GOOGLE_APP_PW;
}

// create google oauth2 client

const oauthRedirectUri = "https://developers.google.com/oauthplayground";

const Oauth2 = google.auth.OAuth2;
const oauthClient = new Oauth2(clientId, clientSecret, oauthRedirectUri);
oauthClient.setCredentials({
	refresh_token: refreshToken,
});
const accessToken = await oauthClient.getAccessToken().catch((e) => {
	console.log("failed to generate access token");
	console.error(e);
});

const transport = nodemailer.createTransport({
	//host: "smtp.gmail.com",
	service: "gmail",
	port: 465,
	secure: true,
	from: "cormparse@gmail.com",
	auth: {
		//type: "OAuth2",
		user: "cormparse@example.com",
		pass: appPW,
		// clientId,
		// clientSecret,
		// refreshToken,
		// accessToken,
	},
});

transport.on("idle", () => {
	console.log("a connection is open.");
});
export default transport;
