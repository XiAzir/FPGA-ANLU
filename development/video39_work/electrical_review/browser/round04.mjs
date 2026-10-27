const fs = await import('node:fs/promises');
const task = await taskSpace(4);
const page = task.page('p1');
await page.goto('https://www.google.com/search?q=site%3Ati.com+TMDS+differential+swing+400+600+mV');
const result = await page.evaluate(() => ({
  text:(document.querySelector('main')?.innerText || document.body.innerText).slice(0,17000),
  links:[...document.querySelectorAll('a[href]')].map(a=>({text:a.innerText.trim().slice(0,160),url:a.href}))
    .filter(a=>a.url.startsWith('https://www.ti.com/lit/') || a.url.startsWith('https://www.ti.com/product/'))
}));
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser/tmds_levels_search.json',JSON.stringify(result,null,2));
console.log(result);
