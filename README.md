# 09:22 Café — Menú

Mobile-first menu website for **09:22 Café**, implemented from the Claude Design comp
`Menu 09-22 Cafe.dc.html`. Single static page (vanilla HTML/CSS/JS), no build step,
ready for GitHub Pages.

## Screens
- **Home** — brand header + four category cards (real coffee-shop photos)
- **Bebidas Calientes** / **Bebidas Frías** — items with size/price chips, Extras & "Personaliza tu bebida"
- **Sandwiches** — cards + Extras
- **Postres** — list + "Otros"

Navigation uses URL hashes (`#calientes`, `#frias`, `#sandwiches`, `#postres`), so the
browser back button and deep links work — and no server rewrites are needed.

## Structure
```
index.html            The whole site (markup, styles, data, and renderer)
assets/img/           Web-optimized photos (WebP + JPG fallback, ~1.2 MB total)
Menu/                 Original menu reference graphics (not used by the site)
Fotos Listas/         Full-res source photography (git-ignored — 1.3 GB)
.nojekyll             Serve files as-is on GitHub Pages
```

## Preview locally
Any static server works, e.g.:
```bash
python3 -m http.server 8000
# open http://localhost:8000
```

## Deploy to GitHub Pages
1. Create a repository on GitHub (e.g. `0922-cafe`).
2. From this folder:
   ```bash
   git init
   git add .
   git commit -m "09:22 Café menu site"
   git branch -M main
   git remote add origin git@github.com:<user>/0922-cafe.git
   git push -u origin main
   ```
3. On GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   branch **`main`**, folder **`/ (root)`**. Save.
4. The site publishes at `https://<user>.github.io/0922-cafe/` within a minute or two.

> The `Fotos Listas/` originals are intentionally git-ignored to keep the repo small.
> To regenerate the web images from the originals, see `scripts/build-images.sh`.

## Editing the menu
All prices and items live in the `MENU` object near the top of the `<script>` in
`index.html`. Edit values there — the page re-renders from that single source.
