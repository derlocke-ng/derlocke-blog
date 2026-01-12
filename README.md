# 🖥️ derlocke.net Blog

A personal blog built on [Kiwi Blog](https://github.com/derlocke-ng/kiwi-blog) — a lightweight static site generator powered by Markdown.

**Live:** [derlocke.net](https://derlocke.net)

## ✨ Features

- 🌙 **Dark mode by default** — Terminal-inspired aesthetic
- 🎨 **Theme customization** — Color slider to personalize
- 📱 **Responsive design** — Works on all devices
- 🔧 **Service dock** — Quick access to VPN, XMPP, etc.
- 📁 **Archive system** — Posts organized by year
- 🚀 **GitHub Pages ready** — Zero-config deployment
- 📝 **Markdown content** — Easy to write and maintain

## 🚀 Quick Start

### Prerequisites

- `pandoc` (Markdown processor)
- `bash` (Build script)

```bash
# Install pandoc (Debian/Ubuntu)
sudo apt install pandoc

# Install pandoc (Fedora)
sudo dnf install pandoc

# Install pandoc (Arch)
sudo pacman -S pandoc

# Install pando (brew)
brew install pandoc
```

### Build & Preview

```bash
# Clone the repo
git clone https://github.com/yourusername/derlocke-blog.git
cd derlocke-blog

# Make build script executable
chmod +x build.sh

# Build the site
./build.sh

# Preview locally
python3 -m http.server 8000
# Open http://localhost:8000
```

## 📁 Structure

```
derlocke-blog/
├── build.sh                 # Build script
├── template.html            # Main page template
├── archive-template.html    # Archive page template
├── style.css                # All styling
├── theme.js                 # Theme controller
├── bg.jpg                   # Background image (optional)
├── index.html               # Generated homepage
├── archive.html             # Generated archive
└── blogentries/             # Your blog posts
    ├── home.md              # Homepage content
    ├── pinned.md            # Pinned message
    └── *.md                 # Blog posts
```

## ✍️ Writing Posts

Create a new `.md` file in `blogentries/`:

```markdown
# My Post Title

**Date:** 2026-01-15

Your content here. Supports all Markdown features:
- Lists
- **Bold**, *italic*
- `code` and code blocks
- Links, images, tables
- Blockquotes

> Like this one!
```

Then run `./build.sh` to regenerate the site.

## 🎨 Customization

### Background Image

Add a `bg.jpg` file to the root directory. The CSS will automatically use it.

### Service Dock

Edit the `<div class="service-dock">` section in `template.html` to add your own service links.

### Colors

- Default is terminal green (hue: 120)
- Users can adjust with the slider
- Change default in CSS: `--content-hue: 120;`

### Adding Custom Pages

Follow the Kiwi Blog pattern:
1. Create `mypage-template.html`
2. Create `mypage/` folder with `.md` files
3. Add `<!--MYPAGE-->` placeholder in template
4. Run `./build.sh`

## 🌐 Deployment

### GitHub Pages

1. Push to GitHub
2. Go to Settings → Pages
3. Select branch: `main`, folder: `/ (root)`
4. Save and wait for deployment

### Custom Domain

Add a `CNAME` file with your domain:
```
derlocke.net
```

## 📜 License

MIT License — Based on [Kiwi Blog](https://github.com/derlocke-ng/kiwi-blog)

---

Made with 🖥️ and too much coffee.
