import { PrismaClient } from "@prisma/client";

const prismaClient = new PrismaClient();

await prismaClient.$connect();

export default prismaClient;
