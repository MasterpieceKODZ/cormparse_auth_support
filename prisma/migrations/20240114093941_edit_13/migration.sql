/*
  Warnings:

  - Changed the type of `type` on the `Issue` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `priority` on the `Issue` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Issue" DROP COLUMN "type",
ADD COLUMN     "type" TEXT NOT NULL,
DROP COLUMN "priority",
ADD COLUMN     "priority" TEXT NOT NULL;

-- DropEnum
DROP TYPE "IssueLinkType";

-- DropEnum
DROP TYPE "Priority";

-- DropEnum
DROP TYPE "Type";

-- CreateIndex
CREATE INDEX "Issue_type_idx" ON "Issue"("type");

-- CreateIndex
CREATE INDEX "Issue_priority_idx" ON "Issue"("priority");
