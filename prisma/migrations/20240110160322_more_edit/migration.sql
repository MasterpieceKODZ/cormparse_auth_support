/*
  Warnings:

  - The `attachments` column on the `Issue` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `issuesAssigned` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `recentIssuesViewed` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `_projectCreator` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_projectCreator" DROP CONSTRAINT "_projectCreator_A_fkey";

-- DropForeignKey
ALTER TABLE "_projectCreator" DROP CONSTRAINT "_projectCreator_B_fkey";

-- AlterTable
ALTER TABLE "Issue" DROP COLUMN "attachments",
ADD COLUMN     "attachments" JSONB[];

-- AlterTable
ALTER TABLE "User" DROP COLUMN "issuesAssigned",
DROP COLUMN "recentIssuesViewed",
ADD COLUMN     "recentIssues" JSONB[];

-- DropTable
DROP TABLE "_projectCreator";

-- CreateTable
CREATE TABLE "_projectMember" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_projectMember_AB_unique" ON "_projectMember"("A", "B");

-- CreateIndex
CREATE INDEX "_projectMember_B_index" ON "_projectMember"("B");

-- AddForeignKey
ALTER TABLE "_projectMember" ADD CONSTRAINT "_projectMember_A_fkey" FOREIGN KEY ("A") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_projectMember" ADD CONSTRAINT "_projectMember_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
