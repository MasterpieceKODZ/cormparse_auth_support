/*
  Warnings:

  - You are about to drop the `Team` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_teamAsAdmin` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_teamAsMember` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `defaultAssignee` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `description` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `key` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lead` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `url` to the `Project` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "IssueLinkType" AS ENUM ('child', 'parent');

-- CreateEnum
CREATE TYPE "Priority" AS ENUM ('highest', 'high', 'mid', 'low');

-- CreateEnum
CREATE TYPE "Type" AS ENUM ('improvement', 'task', 'sub_task', 'bug', 'feature');

-- CreateEnum
CREATE TYPE "ActivityAction" AS ENUM ('comment', 'update');

-- DropForeignKey
ALTER TABLE "Team" DROP CONSTRAINT "Team_creator_fkey";

-- DropForeignKey
ALTER TABLE "Team" DROP CONSTRAINT "Team_lead_fkey";

-- DropForeignKey
ALTER TABLE "_teamAsAdmin" DROP CONSTRAINT "_teamAsAdmin_A_fkey";

-- DropForeignKey
ALTER TABLE "_teamAsAdmin" DROP CONSTRAINT "_teamAsAdmin_B_fkey";

-- DropForeignKey
ALTER TABLE "_teamAsMember" DROP CONSTRAINT "_teamAsMember_A_fkey";

-- DropForeignKey
ALTER TABLE "_teamAsMember" DROP CONSTRAINT "_teamAsMember_B_fkey";

-- AlterTable
ALTER TABLE "Project" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "defaultAssignee" TEXT NOT NULL,
ADD COLUMN     "description" TEXT NOT NULL,
ADD COLUMN     "key" VARCHAR(10) NOT NULL,
ADD COLUMN     "lead" TEXT NOT NULL,
ADD COLUMN     "name" VARCHAR(30) NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "url" VARCHAR(150) NOT NULL;

-- DropTable
DROP TABLE "Team";

-- DropTable
DROP TABLE "_teamAsAdmin";

-- DropTable
DROP TABLE "_teamAsMember";

-- CreateTable
CREATE TABLE "Issue" (
    "id" SERIAL NOT NULL,
    "summary" VARCHAR(150) NOT NULL,
    "key" VARCHAR(15) NOT NULL,
    "description" TEXT NOT NULL,
    "type" "Type" NOT NULL,
    "priority" "Priority" NOT NULL,
    "status" TEXT NOT NULL,
    "tags" TEXT[],
    "attachments" JSONB NOT NULL,
    "assignee" TEXT NOT NULL,
    "reporter" TEXT NOT NULL,
    "project" INTEGER NOT NULL,
    "parentIssue" INTEGER NOT NULL,
    "superIssue" INTEGER NOT NULL,
    "reportedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Issue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" SERIAL NOT NULL,
    "author" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "postedAt" TIMESTAMP(3) NOT NULL,
    "isReply" BOOLEAN,
    "replyTo" INTEGER,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "unlikes" INTEGER NOT NULL DEFAULT 0,
    "issue" INTEGER NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Activity" (
    "id" SERIAL NOT NULL,
    "action" "ActivityAction" NOT NULL,
    "description" TEXT NOT NULL,
    "comment" INTEGER,
    "actor" TEXT NOT NULL,
    "issue" INTEGER NOT NULL,

    CONSTRAINT "Activity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_projectCreator" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_projectAdmin" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE INDEX "Issue_key_idx" ON "Issue"("key");

-- CreateIndex
CREATE INDEX "Issue_type_idx" ON "Issue"("type");

-- CreateIndex
CREATE INDEX "Issue_status_idx" ON "Issue"("status");

-- CreateIndex
CREATE INDEX "Issue_priority_idx" ON "Issue"("priority");

-- CreateIndex
CREATE INDEX "Issue_reporter_idx" ON "Issue"("reporter");

-- CreateIndex
CREATE INDEX "Issue_assignee_idx" ON "Issue"("assignee");

-- CreateIndex
CREATE UNIQUE INDEX "Activity_comment_key" ON "Activity"("comment");

-- CreateIndex
CREATE INDEX "Activity_actor_idx" ON "Activity"("actor");

-- CreateIndex
CREATE INDEX "Activity_comment_idx" ON "Activity"("comment");

-- CreateIndex
CREATE UNIQUE INDEX "_projectCreator_AB_unique" ON "_projectCreator"("A", "B");

-- CreateIndex
CREATE INDEX "_projectCreator_B_index" ON "_projectCreator"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_projectAdmin_AB_unique" ON "_projectAdmin"("A", "B");

-- CreateIndex
CREATE INDEX "_projectAdmin_B_index" ON "_projectAdmin"("B");

-- CreateIndex
CREATE INDEX "Project_name_key_idx" ON "Project"("name", "key");

-- CreateIndex
CREATE INDEX "Project_key_idx" ON "Project"("key");

-- CreateIndex
CREATE INDEX "Project_creator_idx" ON "Project"("creator");

-- CreateIndex
CREATE INDEX "Project_lead_idx" ON "Project"("lead");

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_lead_fkey" FOREIGN KEY ("lead") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_defaultAssignee_fkey" FOREIGN KEY ("defaultAssignee") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_assignee_fkey" FOREIGN KEY ("assignee") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_reporter_fkey" FOREIGN KEY ("reporter") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_project_fkey" FOREIGN KEY ("project") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_parentIssue_fkey" FOREIGN KEY ("parentIssue") REFERENCES "Issue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_superIssue_fkey" FOREIGN KEY ("superIssue") REFERENCES "Issue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_author_fkey" FOREIGN KEY ("author") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_replyTo_fkey" FOREIGN KEY ("replyTo") REFERENCES "Comment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_issue_fkey" FOREIGN KEY ("issue") REFERENCES "Issue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activity" ADD CONSTRAINT "Activity_comment_fkey" FOREIGN KEY ("comment") REFERENCES "Comment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activity" ADD CONSTRAINT "Activity_actor_fkey" FOREIGN KEY ("actor") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activity" ADD CONSTRAINT "Activity_issue_fkey" FOREIGN KEY ("issue") REFERENCES "Issue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_projectCreator" ADD CONSTRAINT "_projectCreator_A_fkey" FOREIGN KEY ("A") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_projectCreator" ADD CONSTRAINT "_projectCreator_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_projectAdmin" ADD CONSTRAINT "_projectAdmin_A_fkey" FOREIGN KEY ("A") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_projectAdmin" ADD CONSTRAINT "_projectAdmin_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
