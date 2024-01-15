<template data-parse>2023-01-15 #indieweb #programming</template>

# More Indieweb Goofin'

I did it! It took several hours of dorking around with Netlify functions. And understanding the cryptic indieweb specifications. And purposefully leaning into the hurdles of TypeScript’s strict setting. All said and done—I’ve got a working [indieauth](https://indieauth.spec.indieweb.org)/[micropub](https://micropub.spec.indieweb.org) setup on www.danott.co.

Here’s how it works. I add my website as a micropub account in iA Writer. Publishing a draft from iA Writer creates a GitHub Issue. The iA Writer filename (without extension) becomes the issue title. The file contents become the issue description. Bingpot.

That’s it for now. The next step is a GitHub Action to transform the issue into a fully published file within the main branch of the repository. Ideally after I add a label like “commit” or “publish”. 

I know that’s an extra step. And more glue code. But it matches my comfort level. I’m generating OAuth 2.0 bearer tokens to give to third party micropub clients. I want to limit the blast radius of a bearer token being compromised. With this setup, the worst that can happen is a flooding of my GitHub Issues. I’m using a [fine-grained personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-fine-grained-personal-access-token) that only allows the creation of issues in this lone repository.

This paranoia is kind of silly in the case of iA Writer. It appears the request to convert a `code` into an `access_token` (OAuth 2.0 bearer token) does not happen on iA’s servers. It  happens once Writer is opened on the device. Leading me to believe it’s never visible publicly. It’s an SSL exchange between my local machine and www.danott.co. Both of which I control. 

But also; I’m using Netlify. Who knows what all is logged in such a comprehensive platform. And how it could be breached by a motivated attacker of a centralized service. I have my limits of risk mitigation. Thus; the Issues.

TypeScript is great. Opting into the strictest rules did feel slow at first. Deploy-time brought the payoff. Few unexpected errors from all the strict type checking. The biggest hurdle was parsing `x-www-form-urlencode` data. Turns out, `new UrlSearchParams(event.body)` works just fine. It’s in the names. It took a minute to slow down and observe them.

[bcrypt](https://www.npmjs.com/package/bcrypt) and [jsonwebtoken](https://www.npmjs.com/package/jsonwebtoken) also entered the scene. Rolling your own auth can be scary. I’m satisfied with my implementation. And I’ve got all the mechanisms to rotate secrets in the event of the worst.