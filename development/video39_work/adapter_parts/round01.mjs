const fs = await import('node:fs/promises');
const task = await taskSpace('P4 HDMI adapter parts 20261027 1620');
console.log({spaceId:task.spaceId});
const page = task.page('p1');
const results = [];
for (const query of ['HDMI-19F-01 site:lcsc.com', 'TPD4E1U06 DBV SOT-23 capacitance site:ti.com', 'TSW-118-07-L-D site:samtec.com']) {
  await page.goto('https://www.google.com/search?q='+encodeURIComponent(query));
  results.push(await page.evaluate(() => ({url:location.href,text:(document.querySelector('main')?.innerText || document.body.innerText).slice(0,13000),links:[...document.querySelectorAll('a[href]')].map(a=>({text:a.innerText.trim().slice(0,160),url:a.href})).filter(a=>/^https:\/\/(www\.)?(lcsc\.com|ti\.com|samtec\.com|jlc\.com|szlcsc\.com)\//.test(a.url))})));
}
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/adapter_parts/search01.json',JSON.stringify(results,null,2));
console.log(results);
