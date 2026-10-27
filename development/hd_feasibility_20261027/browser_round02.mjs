const task = await taskSpace(1);
const page = task.page("p1");
for (const query of ["site:anlogic.com EG4 LVDS", "site:docs.amd.com 720p 1080p 74.25 148.5 HDMI"]) {
  await page.goto("https://www.google.com/search?q=" + encodeURIComponent(query));
  console.log({query});
  console.log(await page.evaluate(() => ({text: document.querySelector("main")?.innerText.slice(0,11000), links: [...document.querySelectorAll("main a")].filter(a=>a.querySelector("h3")).map(a=>({title:a.innerText,href:a.href}))})));
}
