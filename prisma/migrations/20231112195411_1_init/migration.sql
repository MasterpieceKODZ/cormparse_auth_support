
-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_creator_id_fkey";

-- AlterTable
ALTER TABLE "Project" DROP COLUMN "creator_id",
ADD COLUMN     "creator" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_creator_fkey" FOREIGN KEY ("creator") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
