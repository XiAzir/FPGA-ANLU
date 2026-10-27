const fs = await import('node:fs/promises');
const task = await taskSpace(4);
const response = await fetch('https://www.ti.com/lit/gpn/tmds250');
if (!response.ok) throw new Error('TMDS250 fetch status '+response.status);
const content = Buffer.from(await response.arrayBuffer());
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/TI_TMDS250_datasheet.pdf',content);
console.log({url:response.url,bytes:content.length});
await task.finish({keep:[]});
console.log('ELECTRICAL_REFERENCE_BROWSER_FINISHED');
