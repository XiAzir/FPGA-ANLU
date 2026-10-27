const task = await taskSpace(1);
const url = "https://raw.githubusercontent.com/torvalds/linux/master/drivers/gpu/drm/drm_edid.c";
const response = await fetch(url);
const text = await response.text();
console.log({url, status: response.status});
for (const label of ["4 - 1280x720@60Hz", "16 - 1920x1080@60Hz", "32 - 1920x1080@24Hz", "34 - 1920x1080@30Hz"]) {
  const index = text.indexOf(label);
  console.log({label, index, excerpt: index>=0 ? text.slice(Math.max(0,index-6),index+300) : null});
}
await task.finish({keep: []});
