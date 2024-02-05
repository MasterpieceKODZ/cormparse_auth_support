/*
  Warnings:

  - A unique constraint covering the columns `[creator,key]` on the table `Project` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[creator,name]` on the table `Project` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Project_creator_key_key" ON "Project"("creator", "key");

-- CreateIndex
CREATE UNIQUE INDEX "Project_creator_name_key" ON "Project"("creator", "name");
