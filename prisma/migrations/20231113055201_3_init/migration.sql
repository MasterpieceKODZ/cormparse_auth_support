-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_creator_fkey";

-- AlterTable
ALTER TABLE "Project" ALTER COLUMN "creator" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_creator_fkey" FOREIGN KEY ("creator") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;
