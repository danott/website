/* @format */

var availableFontStacks = [
  "var(--font-system)",
  "var(--font-transitional)",
  "var(--font-old-style)",
  "var(--font-humanist)",
  "var(--font-geometric-humanist)",
  "var(--font-classical-humanist)",
  "var(--font-neo-grotesque)",
  "var(--font-monospace-slab-serif)",
  "var(--font-monospace-code)",
  "var(--font-industrial)",
  "var(--font-rounded-sans)",
  "var(--font-slab-serif)",
  "var(--font-antique)",
  "var(--font-didone)",
  "var(--font-handwritten)",
];

function applyFontStack(fontStack) {
  document.body.style.fontFamily = fontStack;
}
