/*
  Warnings:

  - A unique constraint covering the columns `[project,key]` on the table `Issue` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Issue_project_key_key" ON "Issue"("project", "key");
