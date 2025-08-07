# Ace Language Services – Quick Reference Notes

## Table of Contents
1. Common Changes
2. Where to Edit What
3. CSS/HTML Navigation
4. Deployment & Domain
5. FAQ & Troubleshooting
6. Useful Tips

---

## 1. Common Changes

- **Add a new service:**
  - Go to `index.html` → Section 4. Services Section
  - Copy a `<div class="service-item">...</div>` block and edit the icon/title.
- **Add a new language:**
  - Go to `index.html` → Section 5. Language Translation Services
  - Copy a `<div class="language-item">...</div>` block and change the language name.
- **Change company info (address, phone, email):**
  - Go to `index.html` → Section 1. Header Section, Section 7. Contact Section, or Section 9. Footer
- **Change colors or fonts:**
  - Go to `styles.css` → Section 2. Header Styles, Section 3. Hero Section, etc.
- **Edit contact form:**
  - Go to `index.html` → Section 7. Contact Section
  - For validation/notifications, see `script.js`

---

## 2. Where to Edit What

| What you want to change         | File         | Section Number & Name                |
|---------------------------------|--------------|--------------------------------------|
| Company name, slogan, contacts  | index.html   | 1. Header, 7. Contact, 9. Footer     |
| Services offered                | index.html   | 4. Services Section                  |
| Languages offered               | index.html   | 5. Language Translation Services     |
| Colors, fonts, layout           | styles.css   | See Table of Contents at top         |
| Animations, notifications       | styles.css   | 15. Loading Animation, 18. Notification Styles |
| Map location                    | index.html   | 8. Map Section                       |
| Form handling                   | script.js    | (search for 'contactForm')           |

---

## 3. CSS/HTML Navigation
- Use the Table of Contents at the top of `index.html` and check the `css/` folder for the relevant CSS file for each section.
- Each CSS file in `css/` is named after the section it styles (e.g., `header.css`, `services.css`).
- Use `Ctrl+P` or your editor’s file search to quickly open the right CSS file.
- Use `Ctrl+F` to search for class names or section numbers within each CSS file.
- Use browser Inspect tool to find which CSS rules apply to an element, then look for those classes in the correct CSS file in `css/`.

---

## 4. Deployment & Domain
- **Deploy:** Use Netlify (drag-and-drop or GitHub integration)
- **Custom domain:** Add domain in Netlify dashboard, update DNS at registrar
- **Form handling:** Netlify Forms works out of the box

---

## 5. FAQ & Troubleshooting
- **Q: How do I make the site multi-language?**
  - This is a bigger task; would require duplicating content and toggling languages.
- **Q: How do I change the logo?**
  - Replace the `<h1>` in Section 1. Header Section with an `<img>` tag.

## CSS File Overview

All CSS files are now in the `css/` folder. Here’s what each one is for:

- `base.css` – Reset, typography, and base layout styles
- `header.css` – Header and navigation styles
- `hero.css` – Hero section styles
- `features.css` – Why Choose Us/Features section
- `services.css` – Services and language services
- `about.css` – About section and stats
- `contact.css` – Contact form and info
- `map.css` – Map section styles
- `footer.css` – Footer styles
- `responsive.css` – All media queries and responsive tweaks
- `utility.css` – Notifications, animations, and utility classes


