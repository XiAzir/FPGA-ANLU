const task = await taskSpace(1);
const page = task.page("p1");
const evidence = await page.evaluate(() => {
  const text = document.body.innerText;
  return {title:document.title,url:location.href, source_blob:text.match(/blob: ([0-9a-f]+)/)?.[1],matches:["4 - 1280x720@60Hz","16 - 1920x1080@60Hz","32 - 1920x1080@24Hz","34 - 1920x1080@30Hz"].map(label=>{const index=text.indexOf(label);return {label,index,excerpt:index>=0?text.slice(index,index+260):null};})};
});
const fs = await import("node:fs/promises");
await fs.writeFile("E:/VSCODE-project/FPGA-ANLU/development/hd_feasibility_20261027/display_mode_evidence.json",JSON.stringify(evidence,null,2),"utf8");
console.log({url:evidence.url, source_blob:evidence.source_blob,modes:evidence.matches.map(m=>({label:m.label,found:m.index>=0}))});
await task.finish({keep: []});
