# The Assignment
```
We know there are a lot of things we can improve on in our docs. Identify 3-5 higher order concerns and your solution for them. Be ready to discuss why you think these are significant issues we should address and the reasoning behind your solution.

This will be a conversation with me and either a PM or Engineer, so someone who you would be working with fairly closely. You can use notes or whatever you need.
```

# The Observations

## Technical: Look and Feel
- navigation can be challenging
- docs should take up browser width
- the online docs are for what version of the software? I don't see a way to access and read docs for a specific version - ability to change versions instead of moving older docs to bottom of left navigation

- Brian is evaluating [Helpdocs](https://www.helpdocs.io/) and [Document360](https://document360.io/_)

## Technical: Search functionality?
- no search functionality for docs.armory.io

## Technical: Why separate websites?
- docs.armory.io
- kb.armory.io
- blog.armory.io

All three sites have different headers, which are different from armory.io

### blog
- blog site uses web (CDNs, fontawesome.com) to grab JS; same with stylesheets - users outside of US and Canada may experience delays or no access (China)
- no menu of blogs, so have to click through pages to see what blogs have been published
- no RSS Feed link

## Content: Content organization
- docs is for both Armory Spinnaker and Armory Halyard - should have separate sections for each

  - installation and configuration
  - troubleshooting
  - how to use
  - CLI (Halyard is the CLI); what features does Armory add to open source Halyard?

- move glossary and release notes
- intro sections for the Armory products: Spinnaker, Halyard, Dinghy (any product the customer uses)
- User Guides - Best Practices: move to a configuration section
- Group like content together; Best Practices has sections on Secrets and there are 3 secrets pages in the Installation and Administration Guides section
- dual-source: do not want to replicate Spinnaker upstream docs; do not want to duplicate content on main Armory website

## Content: Style guide
- written by software engineers
- who is the target audience?
- any site analytics to determine location of most readers?
