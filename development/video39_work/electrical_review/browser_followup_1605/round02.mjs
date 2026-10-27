const fs = await import('node:fs/promises');
const task = await taskSpace(5);
const page = task.page('p1');
const results = [];
for (const query of ['"LVDS" "TMDS" "coupling" site:latticesemi.com', '"LVDS" "TMDS" "bias" site:ti.com', '"HDMI" "AC coupled" "LVDS" site:analog.com']) {
  await page.goto('https://www.google.com/search?q='+encodeURIComponent(query));
  results.push(await page.evaluate(() => ({url:location.href,text:(document.querySelector('main')?.innerText || document.body.innerText).slice(0,14000),links:[...document.querySelectorAll('a[href]')].map(a=>({text:a.innerText.trim().slice(0,180),url:a.href})).filter(a=>/^https:\/\/(www\.)?(latticesemi\.com|ti\.com|analog\.com|e2e\.ti\.com)\//.test(a.url))})));
}
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser_followup_1605/search02.json',JSON.stringify(results,null,2));
console.log(results);
