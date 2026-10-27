const fs = await import('node:fs/promises');
const task = await taskSpace(5);
const page = task.page('p1');
await page.goto('https://www.analog.com/en/resources/reference-designs/circuits-from-the-lab/cn0571.html');
const result = await page.evaluate(() => ({url:location.href,title:document.title,text:(document.querySelector('main')?.innerText || document.body.innerText).slice(0,60000),links:[...document.querySelectorAll('a[href]')].map(a=>({text:a.innerText.trim().slice(0,180),url:a.href})).filter(a=>/pdf|schematic|design.support/i.test(a.url)),images:[...document.querySelectorAll('main img')].map(a=>({alt:a.alt,src:a.currentSrc||a.src}))}));
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser_followup_1605/adi_cn0571.json',JSON.stringify(result,null,2));
console.log(result);
