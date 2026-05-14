# Hover-scale animation on product image

## Background

The product detail page renders a square placeholder for the
product image. We want a subtle interaction: when the user
hovers over the image, it should grow slightly to feel
responsive. Tailwind's `hover:scale-105` paired with
`transition-transform` is the standard pattern.

## Bug location

`app/pages/ProductPage.cl.jac`. The image element at the start
of the `<div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-8">`
block currently has no hover effect.

## Expected behaviour

Add the following className utilities to the image placeholder
element (the `<div className="aspect-square ...">` directly
inside the grid):

- `transition-transform`: enables the CSS transition.
- `hover:scale-105`: triggers the 5% scale on hover.

Other classes already on the element (`aspect-square`,
`bg-gradient-to-br`, etc.) must remain in place. The product
name initial inside the image must keep rendering.
