/*
  Warnings:

  - You are about to drop the column `recentIssues` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "recentIssues";

-- CreateTable
CREATE TABLE "_recentIssuesBtActivity" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_recentIssuesBtActivity_AB_unique" ON "_recentIssuesBtActivity"("A", "B");

-- CreateIndex
CREATE INDEX "_recentIssuesBtActivity_B_index" ON "_recentIssuesBtActivity"("B");

-- AddForeignKey
ALTER TABLE "_recentIssuesBtActivity" ADD CONSTRAINT "_recentIssuesBtActivity_A_fkey" FOREIGN KEY ("A") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_recentIssuesBtActivity" ADD CONSTRAINT "_recentIssuesBtActivity_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
