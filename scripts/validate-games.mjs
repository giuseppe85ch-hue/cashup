import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const files = [
  "catalog.json",
  "catalog-2001-3000.json",
  "catalog-3001-4000.json",
  "catalog-4001-5000.json",
  "catalog-5001-6000.json",
  "catalog-6001-7000.json",
  "catalog-7001-8000.json",
  "catalog-8001-9000.json",
  "catalog-9001-10000.json"
];
const ids = new Set();
let total = 0;
for (const file of files) {
  const fullPath = path.join(root, "games", file);
  const data = JSON.parse(fs.readFileSync(fullPath, "utf8"));
  if (!Array.isArray(data.games)) throw new Error(file + ": games array missing");
  for (const game of data.games) {
    if (!game.id || !game.title || !game.category || !game.description) {
      throw new Error(file + ": incomplete game entry");
    }
    const id = String(game.id);
    if (ids.has(id)) throw new Error("Duplicate game ID: " + id);
    ids.add(id);
    total++;
  }
}
if (total !== 10000) throw new Error("Expected 10000 catalog concepts, found " + total);
const plan = JSON.parse(fs.readFileSync(path.join(root, "games", "catalog-350-categories-plan.json"), "utf8"));
if (plan.categories?.length !== 600) throw new Error("Expected 600 planned categories");
const existing = plan.categories.filter((item) => item.status === "existing_category").length;
const planned = plan.categories.filter((item) => item.status === "planned_category").length;
if (existing !== 100 || planned !== 500) {
  throw new Error("Unexpected category status counts: " + existing + " existing, " + planned + " planned");
}
console.log("CASHUP GAMES catalog OK:", total, "unique concepts;", existing, "categories populated;", planned, "planned.");
