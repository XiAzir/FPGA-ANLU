const fs = await import('node:fs/promises');
const task = await taskSpace('P4 HDMI electrical review 20261027 1605');
console.log({ taskSpaceId: task.spaceId });
const page = task.page('p1');
await page.goto('https://www.google.com/search?q=LVDS+TMDS+AC+coupling+site%3Ati.com%2Flit%2F');
const result = await page.evaluate(() => ({
  url: location.href,
  text: (document.querySelector('main')?.innerText || document.body.innerText).slice(0,18000),
  links: [...document.querySelectorAll('a[href]')].map(a => ({text:a.innerText.trim().slice(0,180),url:a.href}))
    .filter(a => a.url.startsWith('https://www.ti.com/lit/') || a.url.startsWith('https://www.analog.com/') || a.url.startsWith('https://www.latticesemi.com/'))
}));
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser_followup_1605/search01.json',JSON.stringify(result,null,2));
console.log(result);
