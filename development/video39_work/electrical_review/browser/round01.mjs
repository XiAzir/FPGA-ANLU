const fs = await import('node:fs/promises');
const task = await taskSpace('1080p30 native HDMI electrical review 20261027');
const page = task.page('p1');
await page.goto('https://www.google.com/search?q=site%3Ati.com+LVDS+HDMI+TMDS+AC+coupling+termination');
const snapshot = await page.snapshot({scope:'full_page'});
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser/search01.txt',typeof snapshot === 'string' ? snapshot : JSON.stringify(snapshot,null,2));
console.log({spaceId:task.spaceId,page:page.label,url:await page.url()});
console.log(typeof snapshot === 'string' ? snapshot.slice(0,14500) : snapshot);
