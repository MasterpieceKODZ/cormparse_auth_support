-- AlterTable
ALTER TABLE "Issue" ALTER COLUMN "updatedAt" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Project" ALTER COLUMN "updatedAt" DROP NOT NULL;
