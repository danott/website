/* @format */

console.log("Hello World!");

class IncludeHere extends HTMLElement {
  connectedCallback() {
    console.error("Unexpected Custom element added to page!");
    console.error(this);
    this.parentElement.removeChild(this);
  }
}

class IncludeInHeader extends IncludeHere {}

customElements.define("include-in-header", IncludeInHeader);
customElements.define("eval-ruby", IncludeHere);
