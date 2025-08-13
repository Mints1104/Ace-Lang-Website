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

### Netlify Hosting Setup Guide

#### Step 1: Deploy to Netlify
1. **Sign up/Login to Netlify** (netlify.com)
2. **Choose deployment method:**
   - **Drag & Drop:** Drag your project folder to Netlify dashboard
   - **GitHub Integration:** Connect your GitHub repo for automatic deployments
3. **Your site will be live at:** `https://your-site-name.netlify.app`

#### Step 2: Configure Netlify Forms
1. **Forms are already configured** in `index.html` with `data-netlify="true"`
2. **Access form submissions:**
   - Go to Netlify Dashboard → Your Site → Forms
   - View submissions, export data, or set up notifications
3. **Form notifications:**
   - Go to Forms → Form notifications
   - Set up email notifications for new submissions
   - Configure webhooks for custom integrations

#### Step 3: Custom Domain Setup
1. **Add custom domain in Netlify:**
   - Go to Site Settings → Domain management
   - Click "Add custom domain"
   - Enter your domain (e.g., `acelanguageservices.com`)

2. **Update DNS at your domain registrar:**
   - **Option A (Recommended):** Use Netlify DNS
     - Go to Site Settings → Domain management
     - Click "Add domain" → "Use Netlify DNS"
     - Update nameservers at your registrar to Netlify's
   
   - **Option B:** Keep your current DNS provider
     - Add these DNS records at your registrar:
       ```
       Type: A
       Name: @
       Value: 75.2.60.5
       
       Type: CNAME
       Name: www
       Value: your-site-name.netlify.app
       ```

3. **SSL Certificate:**
   - Netlify automatically provides free SSL certificates
   - Takes 24-48 hours to activate after DNS is configured

#### Step 4: Advanced Netlify Features
1. **Environment Variables:**
   - Go to Site Settings → Environment variables
   - Add any API keys or configuration values

2. **Redirects & Headers:**
   - Create `_redirects` file in your project root for custom redirects
   - Create `_headers` file for custom HTTP headers

3. **Build Settings (if using Git):**
   - Build command: (leave empty for static sites)
   - Publish directory: (leave empty for root directory)

#### Troubleshooting
- **Domain not working:** Check DNS propagation (can take 24-48 hours)
- **Forms not working:** Ensure `data-netlify="true"` is in your form
- **SSL issues:** Wait 24-48 hours after DNS setup
- **Deployment fails:** Check for syntax errors in HTML/CSS/JS files

---

## 5. FAQ & Troubleshooting
- **Q: How do I make the site multi-language?**
  - This is a bigger task; would require duplicating content and toggling languages.
- **Q: How do I change the logo?**
  - Replace the `<h1>` in Section 1. Header Section with an `<img>` tag.

## CSS File Overview

All CSS files are now in the `css/` folder. Here’s what each one is for:

- `base.css` – Reset, typography, and base layout styles
- `header.css` – Header, navigation, and mobile burger menu styles
- `hero.css` – Hero section styles
- `features.css` – Why Choose Us/Features section
- `services.css` – Services and language services
- `about.css` – About section and stats
- `contact.css` – Contact form and info
- `map.css` – Map section styles
- `footer.css` – Footer styles
- `responsive.css` – All media queries and responsive tweaks
- `utility.css` – Notifications, animations, and utility classes

---

## 6. Recent Updates & Features

### Mobile Burger Menu (Latest)
- **Desktop:** Header remains unchanged with logo, contact info, and CTA button
- **Mobile:** Logo + burger menu on the right
- **Sidebar:** Quick access to Why Choose Us, Services, About, Contact, Find Us
- **Features:** Smooth animations, overlay, escape key support, click-to-close

### Mobile Optimizations
- **Services & Languages:** Single column layout on mobile (no horizontal scrolling)
- **Touch targets:** Minimum 80px height for better accessibility
- **Responsive breakpoints:** 768px, 600px, 480px for progressive enhancement
- **Icons & text:** Appropriately sized for mobile screens

### Form Handling
- **Netlify Forms:** Automatically configured with `data-netlify="true"`
- **Validation:** Real-time client-side validation with error messages
- **Notifications:** Success/error notifications with auto-dismiss
- **Accessibility:** Proper ARIA labels and keyboard navigation

### Common Mobile Issues
- **Burger menu not working:** Check that `responsive.css` doesn't override header styles
- **Horizontal scrolling:** Services/languages now use single column on mobile
- **Touch targets:** All interactive elements meet minimum 80px height requirement


