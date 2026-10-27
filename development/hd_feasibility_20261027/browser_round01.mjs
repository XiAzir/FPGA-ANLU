const task = await taskSpace("ANLU HD feasibility 20261027");
console.log({spaceId: task.spaceId});
const page = task.page("p1");
await page.goto("https://www.google.com/search?q=site%3Aanlogic.com+Eagle+EG4S20+LVDS+Mbps");
console.log(await page.snapshot());
