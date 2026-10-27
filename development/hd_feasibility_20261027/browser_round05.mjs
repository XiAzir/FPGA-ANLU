const task = await taskSpace(1);
const page = task.page("p1");
await page.goto("https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux/+/refs/heads/master/drivers/gpu/drm/drm_edid.c");
console.log(await page.snapshot());
console.log(await page.evaluate(() => {
  const text = document.body.innerText;
  return {title: document.title, url:location.href, matches:["4 - 1280x720@60Hz","16 - 1920x1080@60Hz","32 - 1920x1080@24Hz","34 - 1920x1080@30Hz"].map(label=>{const index=text.indexOf(label);return {label,index,excerpt:index>=0?text.slice(index,index+380):null};})};
}));
