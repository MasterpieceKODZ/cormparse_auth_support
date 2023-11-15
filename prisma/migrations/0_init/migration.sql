-- CreateEnum
CREATE TYPE "Theme" AS ENUM ('dark', 'light', 'default');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "firstname" VARCHAR(50) NOT NULL,
    "lastname" VARCHAR(50) NOT NULL,
    "username" VARCHAR(100) NOT NULL,
    "passwordHash" TEXT,
    "salt" TEXT,
    "photoUrl" TEXT,
    "recentIssuesViewed" JSONB[],
    "issuesAssigned" JSONB[],
    "role" VARCHAR(50),
    "dateCreated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "theme" "Theme" DEFAULT 'default',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "creator" INTEGER NOT NULL,
    "lead" INTEGER NOT NULL,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "id" SERIAL NOT NULL,
    "creator_id" INTEGER NOT NULL,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_teamAsAdmin" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_teamAsMember" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_username_idx" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "_teamAsAdmin_AB_unique" ON "_teamAsAdmin"("A", "B");

-- CreateIndex
CREATE INDEX "_teamAsAdmin_B_index" ON "_teamAsAdmin"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_teamAsMember_AB_unique" ON "_teamAsMember"("A", "B");

-- CreateIndex
CREATE INDEX "_teamAsMember_B_index" ON "_teamAsMember"("B");

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_lead_fkey" FOREIGN KEY ("lead") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_creator_fkey" FOREIGN KEY ("creator") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamAsAdmin" ADD CONSTRAINT "_teamAsAdmin_A_fkey" FOREIGN KEY ("A") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamAsAdmin" ADD CONSTRAINT "_teamAsAdmin_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamAsMember" ADD CONSTRAINT "_teamAsMember_A_fkey" FOREIGN KEY ("A") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamAsMember" ADD CONSTRAINT "_teamAsMember_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

