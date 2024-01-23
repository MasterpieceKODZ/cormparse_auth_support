-- DropForeignKey
ALTER TABLE "Activity" DROP CONSTRAINT "Activity_actor_fkey";

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_author_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_assignee_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_reporter_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_creator_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_defaultAssignee_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_lead_fkey";

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_creator_fkey" FOREIGN KEY ("creator") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_lead_fkey" FOREIGN KEY ("lead") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_defaultAssignee_fkey" FOREIGN KEY ("defaultAssignee") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_assignee_fkey" FOREIGN KEY ("assignee") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_reporter_fkey" FOREIGN KEY ("reporter") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_author_fkey" FOREIGN KEY ("author") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activity" ADD CONSTRAINT "Activity_actor_fkey" FOREIGN KEY ("actor") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
