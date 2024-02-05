/*
  Warnings:

  - You are about to drop the `_recentIssuesBtActivity` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_project_fkey";

-- DropForeignKey
ALTER TABLE "_recentIssuesBtActivity" DROP CONSTRAINT "_recentIssuesBtActivity_A_fkey";

-- DropForeignKey
ALTER TABLE "_recentIssuesBtActivity" DROP CONSTRAINT "_recentIssuesBtActivity_B_fkey";

-- DropTable
DROP TABLE "_recentIssuesBtActivity";

-- CreateTable
CREATE TABLE "_recentIssuesByActivity" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_recentIssuesByActivity_AB_unique" ON "_recentIssuesByActivity"("A", "B");

-- CreateIndex
CREATE INDEX "_recentIssuesByActivity_B_index" ON "_recentIssuesByActivity"("B");

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_project_fkey" FOREIGN KEY ("project") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_recentIssuesByActivity" ADD CONSTRAINT "_recentIssuesByActivity_A_fkey" FOREIGN KEY ("A") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_recentIssuesByActivity" ADD CONSTRAINT "_recentIssuesByActivity_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
