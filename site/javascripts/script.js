/* @format */

console.log("Hello World!");

class EvalRuby extends HTMLElement {
  connectedCallback() {
    console.error(
      "Unexpected element added to page! This should have been removed when building the site!"
    );
    console.error(this);
    this.parentElement.removeChild(this);
  }
}

class IncludeInHeader extends EvalRuby {}

customElements.define("eval-ruby", EvalRuby);
customElements.define("include-in-header", IncludeInHeader);
