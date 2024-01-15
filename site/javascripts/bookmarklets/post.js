/* @format
 *
 * Make it usable at https://bookmarklets.org/maker/
 */

var date = new Date();
date.setHours(date.getHours() - date.getTimezoneOffset() / 60);

var year = date.getFullYear();
var dateString = date.toISOString().split("T").at(0);
var title = window.prompt("Title", document.title);
var slug = window.prompt("Slug", title.toLowerCase().replace(/\s+/g, "-"));

var filename = "site/" + year + "/" + slug + ".md";
var value = "<template data-parse>" + dateString + "</template>\n\n# " + title;

var url = new URL("https://github.com/danott/website/new/main");
url.searchParams.append("filename", filename);
url.searchParams.append("value", value);

window.open(url);
