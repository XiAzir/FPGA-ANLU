const task = await taskSpace(1);
const page = task.page("p1");
console.log(await page.snapshot());
await page.goto("https://www.kernel.org/doc/html/latest/gpu/drm-kms-helpers.html");
console.log(await page.evaluate(() => ({title:document.title,text:document.body.innerText.slice(0,1200)})));
