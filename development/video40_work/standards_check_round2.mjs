const task = await takeOverTaskSpace(8);
const page = task.page('p1');
await page.goto('https://www.sdcard.org/developers/sd-standard-overview/speed-class/');
console.log(await page.snapshot());
