-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_author_fkey";

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_issue_fkey";

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_replyTo_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_assignee_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_parentIssue_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_reporter_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_superIssue_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_defaultAssignee_fkey";

-- DropForeignKey
ALTER TABLE "Update" DROP CONSTRAINT "Update_actor_fkey";

-- DropForeignKey
ALTER TABLE "Update" DROP CONSTRAINT "Update_issue_fkey";

-- AlterTable
ALTER TABLE "Issue" ALTER COLUMN "assignee" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Project" ALTER COLUMN "defaultAssignee" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_defaultAssignee_fkey" FOREIGN KEY ("defaultAssignee") REFERENCES "User"("email") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_assignee_fkey" FOREIGN KEY ("assignee") REFERENCES "User"("email") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_reporter_fkey" FOREIGN KEY ("reporter") REFERENCES "User"("email") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_parentIssue_fkey" FOREIGN KEY ("parentIssue") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_superIssue_fkey" FOREIGN KEY ("superIssue") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_author_fkey" FOREIGN KEY ("author") REFERENCES "User"("email") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_replyTo_fkey" FOREIGN KEY ("replyTo") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_issue_fkey" FOREIGN KEY ("issue") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Update" ADD CONSTRAINT "Update_actor_fkey" FOREIGN KEY ("actor") REFERENCES "User"("email") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Update" ADD CONSTRAINT "Update_issue_fkey" FOREIGN KEY ("issue") REFERENCES "Issue"("id") ON DELETE CASCADE ON UPDATE CASCADE;
