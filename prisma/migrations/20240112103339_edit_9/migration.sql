/*
  Warnings:

  - You are about to drop the `Activity` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Activity" DROP CONSTRAINT "Activity_actor_fkey";

-- DropForeignKey
ALTER TABLE "Activity" DROP CONSTRAINT "Activity_comment_fkey";

-- DropForeignKey
ALTER TABLE "Activity" DROP CONSTRAINT "Activity_issue_fkey";

-- DropTable
DROP TABLE "Activity";

-- DropEnum
DROP TYPE "ActivityAction";

-- CreateTable
CREATE TABLE "Update" (
    "id" SERIAL NOT NULL,
    "description" TEXT NOT NULL,
    "actor" TEXT NOT NULL,
    "issue" INTEGER NOT NULL,

    CONSTRAINT "Update_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Update_actor_idx" ON "Update"("actor");

-- AddForeignKey
ALTER TABLE "Update" ADD CONSTRAINT "Update_actor_fkey" FOREIGN KEY ("actor") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Update" ADD CONSTRAINT "Update_issue_fkey" FOREIGN KEY ("issue") REFERENCES "Issue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
