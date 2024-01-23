-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_parentIssue_fkey";

-- DropForeignKey
ALTER TABLE "Issue" DROP CONSTRAINT "Issue_superIssue_fkey";

-- AlterTable
ALTER TABLE "Issue" ALTER COLUMN "status" SET DEFAULT 'to-do',
ALTER COLUMN "parentIssue" DROP NOT NULL,
ALTER COLUMN "superIssue" DROP NOT NULL,
ALTER COLUMN "dueDate" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_parentIssue_fkey" FOREIGN KEY ("parentIssue") REFERENCES "Issue"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Issue" ADD CONSTRAINT "Issue_superIssue_fkey" FOREIGN KEY ("superIssue") REFERENCES "Issue"("id") ON DELETE SET NULL ON UPDATE CASCADE;
