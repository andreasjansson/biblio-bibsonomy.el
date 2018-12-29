# biblio-bibsonomy

[Bibsonomy](https://www.bibsonomy.org) backend for [biblio.el](https://github.com/cpitclaudel/biblio.el).

## Installation

1. Download [bibsonomy.el](https://raw.githubusercontent.com/andreasjansson/biblio-bibsonomy/master/biblio-bibsonomy.el) to your Emacs load path
1. Create an account on [www.bibsonomy.org](https://www.bibsonomy.org)
1. In the [Settings tab of the account apge](https://www.bibsonomy.org/settings?selTab=1#selTab1), find your API key under the API heading
1. Set the following variables in your Emacs init file:

```lisp
(require 'biblio-bibsonomy)

(setq
 biblio-bibsonomy-api-key "my-api-key"
 biblio-bibsonomy-username "my-user-name")
```

## Usage

```
M-x biblio-lookup
```

First, select the Bibsonomy backend (biblio-bibsonomy.el automatically adds the Bibsonomy backend to biblio.el).

[screenshot 1](https://raw.githubusercontent.com/andreasjansson/biblio-bibsonomy/master/readme-assets/screenshot-1.png)

Then, type in your search query.

[screenshot 2](https://raw.githubusercontent.com/andreasjansson/biblio-bibsonomy/master/readme-assets/screenshot-2.png)

In the list of results, type `C` to copy the bibtex entry to the kill ring and close the buffer.

[screenshot 3](https://raw.githubusercontent.com/andreasjansson/biblio-bibsonomy/master/readme-assets/screenshot-3.png)

Finally, yank the bibtex entry into your bibliography buffer.

[screenshot 4](https://raw.githubusercontent.com/andreasjansson/biblio-bibsonomy/master/readme-assets/screenshot-4.png)
