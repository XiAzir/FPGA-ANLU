const task = await takeOverTaskSpace(8);
const page = task.page('p1');
await page.click('@21', {label:'核对SD总线速率'});
const result = await page.evaluate(() => ({url:location.href, text:document.querySelector('main')?.innerText ?? document.body.innerText}));
const fs = await import('node:fs/promises');
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video40_work/sda_bus_speed.json', JSON.stringify(result, null, 2), 'utf8');
console.log(result);
await task.finish({keep:[]});
console.log('SDA_CHECK_FINISHED');
