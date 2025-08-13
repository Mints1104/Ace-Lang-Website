# Ace Language Services Website

A modern, responsive website for Ace Language Services - a professional translation and interpretation company based in Newport, UK.

## Features

- **Modern Design**: Clean, professional layout with a blue color scheme
- **Fully Responsive**: Optimized for desktop, tablet, and mobile devices
- **Semantic HTML**: Properly structured with accessibility in mind
- **CSS Grid & Flexbox**: Modern layout techniques for responsive design
- **Minimal JavaScript**: Lightweight interactions and form handling
- **Contact Form**: Functional contact form with validation
- **Google Maps Integration**: Embedded map showing company location
- **Smooth Animations**: Subtle hover effects and scroll animations

## File Structure

```
Ace-Lang-Website/
├── index.html          # Main HTML file
├── styles.css          # CSS styles
├── script.js           # JavaScript functionality
└── README.md           # This file
```

## Sections

1. **Header**: Company name, slogan, contact info, and CTA button
2. **Hero Section**: Compelling headline and value proposition
3. **Why Choose Us**: Three key benefits with icons
4. **Services**: Comprehensive list of translation and interpretation services
5. **About Us**: Company overview with statistics
6. **Contact**: Contact form and company information
7. **Map**: Google Maps integration
8. **Footer**: Links and copyright information

## Technologies Used

- **HTML5**: Semantic markup
- **CSS3**: Modern styling with Grid and Flexbox
- **Vanilla JavaScript**: Minimal, lightweight interactions
- **Font Awesome**: Icons for visual elements
- **Google Fonts**: Inter font family
- **Google Maps**: Location embedding

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Responsive Breakpoints

- **Desktop**: 1200px and above
- **Tablet**: 768px - 1199px
- **Mobile**: 480px - 767px
- **Small Mobile**: Below 480px

## Features

### Contact Form
- Form validation for required fields
- Email format validation
- Success/error notifications
- Loading states during submission

### Interactive Elements
- Smooth scrolling navigation
- Hover effects on service items
- Click-to-copy contact information
- Scroll-triggered animations

### Accessibility
- Semantic HTML structure
- Proper heading hierarchy
- Focus styles for keyboard navigation
- Alt text for images (when added)
- ARIA labels where appropriate

## Customization

### Colors
The website uses a blue color scheme that can be easily modified in the CSS:
- Primary Blue: `#2563eb`
- Secondary Blue: `#3b82f6`
- Accent Orange: `#f59e0b`

### Content
All content is easily editable in the HTML file. The contact information, services, and company details can be updated directly in the markup.

## Setup

1. Download all files to a web server or local directory
2. Open `index.html` in a web browser
3. The website is ready to use!

## Deployment Options

### Option 1: Static Hosting (FormSpree, Netlify Forms)
- Upload files to services like Netlify, Vercel, or GitHub Pages
- Use form services like FormSpree or Netlify Forms for contact form functionality
- No server setup required

### Option 2: Node.js Backend
- Install Node.js and npm
- Run `npm install` to install dependencies
- Configure email settings in `server-example.js`
- Run `npm start` to start the server
- Deploy to platforms like Heroku, Railway, or DigitalOcean

### Option 3: PHP Backend
- Upload files to a PHP-enabled web server
- Use the PHP code provided in `server-example.js` comments
- Configure your server's mail settings

### Option 4: Third-party Form Services
- Use services like Google Forms, Typeform, or JotForm
- Embed the form using an iframe or redirect
- No backend setup required

## Real Form Submission Implementation

The current JavaScript simulates form submission. For a real application, you have several options:

### **Option A: Node.js Backend (Recommended)**
1. Install dependencies: `npm install`
2. Configure email settings in `server-example.js`
3. Set environment variables for email credentials
4. Run: `npm start`

### **Option B: PHP Backend**
1. Upload files to a PHP-enabled server
2. Create `contact.php` with the PHP code from `server-example.js`
3. Update the fetch URL in `script.js` to point to your PHP file

### **Option C: Form Services**
- **FormSpree**: Add `action="https://formspree.io/f/YOUR_FORM_ID"` to the form
- **Netlify Forms**: Add `data-netlify="true"` to the form
- **Google Forms**: Embed a Google Form iframe

### **Option D: Email Services**
- **SendGrid**: Use their API for sending emails
- **Mailgun**: Another popular email service
- **AWS SES**: Amazon's email service

The `server-example.js` file contains a complete Node.js implementation that:
- Validates form data
- Sends notification emails to your business
- Sends confirmation emails to customers
- Handles errors gracefully
- Includes proper CORS headers

## Google Maps

The embedded Google Maps iframe uses placeholder coordinates. To update with the actual location:

1. Go to Google Maps
2. Search for "2-4 Chepstow Rd, Newport, NP19 8EA"
3. Click "Share" and select "Embed a map"
4. Copy the iframe code and replace the existing iframe in the HTML

## Contact Information

- **Address**: 2-4 Chepstow Rd, Newport, NP19 8EA
- **Phone**: +44 1633 864 000
- **Email**: info@acelanguageservices.com
- **Hours**: Monday-Friday 9:00 AM - 6:00 PM, Saturday 10:00 AM - 4:00 PM

## Services Offered

- Emergency Interpretation & Translation
- Localisation
- Design
- Linguists
- Telephone Interpretation
- Translation Emergency
- Court Interpreting
- BSL (British Sign Language)
- Interpreting
- Conference Calls
- Leaflets
- Posters
- Collaboration
- Bookings
- Confidentiality
- Terms & Conditions
- Translation services in: Chinese, French, German, Japanese, Spanish, Italian

## Future Enhancements

- Add real images and company logo
- Implement a blog section
- Add testimonials section
- Create a quote calculator
- Add multi-language support
- Implement a booking system
- Add SEO optimization
- Create admin panel for content management

## License

This website is created for Ace Language Services. All rights reserved. 