const fs = await import('node:fs/promises');
const task = await taskSpace(5);
const page = task.page('p1');
await page.goto('https://www.analog.com/en/products/adn4624.html');
const result = await page.evaluate(() => ({url:location.href,title:document.title,links:[...document.querySelectorAll('a[href]')].map(a=>({text:a.innerText.trim(),url:a.href})).filter(a=>/adn4624.*\.pdf|data-sheets.*adn462/i.test(a.href || a.url))}));
await fs.writeFile('E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser_followup_1605/adn4624_links.json',JSON.stringify(result,null,2));
console.log(result);
const link = result.links.find(a => /data-sheets/i.test(a.url));
if (link) {
  const response = await fetch(link.url);
  if (!response.ok) throw new Error('PDF response '+response.status);
  const body = new Uint8Array(await response.arrayBuffer());
  if (new TextDecoder().decode(body.slice(0,5)) !== '%PDF-') throw new Error('Expected PDF');
  const file = 'E:/VSCODE-project/FPGA-ANLU/development/video39_work/electrical_review/browser_followup_1605/ADI_ADN4624.pdf';
  await fs.writeFile(file,body);
  console.log({download:link.url,file,bytes:body.length});
}
