const task = await taskSpace('TF25 official speed check');
console.log({spaceId: task.spaceId});
const page = task.page('sd');
await page.goto('https://www.sdcard.org/developers/sd-standard-overview/speed-class/');
console.log(await page.snapshot());
