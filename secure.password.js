import crypto from "crypto";

export async function hashPassword(password) {
	const salt = crypto.randomBytes(256).toString("base64").replace(/\s/g, "v");

	const hash = crypto
		.pbkdf2Sync(password, salt, 10000, 1028, "sha512")
		.toString("hex");

	return {
		salt,
		hash,
	};
}
