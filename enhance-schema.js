const fs = require('fs');
const path = require('path');

// Enhanced schema template for language pages
const enhancedSchemaTemplate = (language, languageName) => `    <!-- Enhanced ${languageName} Translation Service Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "Service",
        "name": "${languageName} Translation Services",
        "description": "Professional ${languageName} translation and interpretation services in Newport, Cardiff, Swansea, Bristol and throughout Wales. Certified ${languageName} translators for legal, medical, business and personal documents.",
        "provider": {
            "@type": "LocalBusiness",
            "name": "Ace Language Services",
            "address": {
                "@type": "PostalAddress",
                "streetAddress": "2-4 Chepstow Rd",
                "addressLocality": "Newport",
                "addressRegion": "Wales",
                "postalCode": "NP19 8EA",
                "addressCountry": "GB"
            },
            "telephone": "+441633266201",
            "openingHours": [
                "Mo-Fr 08:30-18:30",
                "Sa 08:30-13:00"
            ]
        },
        "serviceArea": {
            "@type": "Place",
            "name": "Wales and Western England",
            "containedInPlace": ["Newport", "Cardiff", "Bristol", "Swansea"]
        },
        "serviceType": ["Document Translation", "Interpretation", "Certified Translation", "Legal Translation", "Medical Translation", "Business Translation"],
        "hasOfferCatalog": {
            "@type": "OfferCatalog",
            "name": "${languageName} Translation Services",
            "itemListElement": [
                {
                    "@type": "Offer",
                    "itemOffered": {
                        "@type": "Service",
                        "name": "${languageName} Document Translation",
                        "description": "Professional ${languageName} translation for legal documents, medical records, business contracts, and personal documents"
                    }
                },
                {
                    "@type": "Offer",
                    "itemOffered": {
                        "@type": "Service",
                        "name": "${languageName} Interpretation",
                        "description": "Face-to-face and telephone ${languageName} interpretation services for meetings, appointments, and legal proceedings"
                    }
                },
                {
                    "@type": "Offer",
                    "itemOffered": {
                        "@type": "Service",
                        "name": "Certified ${languageName} Translation",
                        "description": "Certified ${languageName} translations accepted by courts, universities, and government agencies throughout the UK"
                    }
                }
            ]
        }
    }
    </script>

    <!-- ${languageName} Translation FAQ Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "How much does ${languageName} translation cost?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "${languageName} translation costs vary based on document complexity and urgency. Standard translations start from £25 per page, while certified translations may cost more. Contact us for a free quote based on your specific ${languageName} translation needs."
                }
            },
            {
                "@type": "Question",
                "name": "How long does ${languageName} translation take?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Standard ${languageName} translations typically take 2-3 business days. Urgent translations can be completed within 24 hours. We also offer same-day emergency ${languageName} translation services when needed."
                }
            },
            {
                "@type": "Question",
                "name": "Do you provide certified ${languageName} translations?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, we provide certified ${languageName} translations for legal documents, academic transcripts, and official documents. Our certified ${languageName} translations are accepted by courts, universities, and government agencies throughout the UK."
                }
            },
            {
                "@type": "Question",
                "name": "What areas do you serve for ${languageName} translation?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "We provide ${languageName} translation services in Newport, Cardiff, Bristol, Swansea, and throughout South Wales and Western England. We also offer remote ${languageName} translation services nationwide."
                }
            }
        ]
    }
    </script>

    <!-- Breadcrumb Schema for ${languageName} Translation Page -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Home",
                "item": "https://www.acelang.com/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Language Services",
                "item": "https://www.acelang.com/#language-services"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "${languageName} Translation",
                "item": "https://www.acelang.com/languages/${language}-translation-services.html"
            }
        ]
    }
    </script>`;

// Language mappings
const languageMappings = {
    'afrikaans': 'Afrikaans',
    'arabic': 'Arabic',
    'bengali': 'Bengali',
    'dutch': 'Dutch',
    'farsi': 'Farsi',
    'french': 'French',
    'german': 'German',
    'hindi': 'Hindi',
    'italian': 'Italian',
    'japanese': 'Japanese',
    'korean': 'Korean',
    'mandarin': 'Mandarin',
    'polish': 'Polish',
    'portuguese': 'Portuguese',
    'russian': 'Russian',
    'spanish': 'Spanish',
    'swedish': 'Swedish',
    'turkish': 'Turkish',
    'urdu': 'Urdu',
    'vietnamese': 'Vietnamese',
    'welsh': 'Welsh'
};

// Function to enhance a language page
function enhanceLanguagePage(filePath, language) {
    try {
        let content = fs.readFileSync(filePath, 'utf8');
        
        // Check if already enhanced
        if (content.includes('Enhanced ' + languageMappings[language] + ' Translation Service Schema')) {
            console.log(`✓ ${language} page already enhanced`);
            return;
        }
        
        // Find the old schema section
        const oldSchemaRegex = /<!-- [^>]*Translation Service Schema -->\s*<script[^>]*>[\s\S]*?<\/script>/;
        const oldSchemaMatch = content.match(oldSchemaRegex);
        
        if (oldSchemaMatch) {
            // Replace old schema with enhanced version
            const enhancedSchema = enhancedSchemaTemplate(language, languageMappings[language]);
            content = content.replace(oldSchemaRegex, enhancedSchema);
            
            // Write back to file
            fs.writeFileSync(filePath, content, 'utf8');
            console.log(`✓ Enhanced ${language} page schema`);
        } else {
            console.log(`⚠ No schema found in ${language} page`);
        }
    } catch (error) {
        console.error(`✗ Error processing ${language}:`, error.message);
    }
}

// Main execution
console.log('🚀 Starting schema enhancement for language pages...\n');

const languagesDir = path.join(__dirname, 'languages');

// Process each language file
Object.keys(languageMappings).forEach(language => {
    const filePath = path.join(languagesDir, `${language}-translation-services.html`);
    if (fs.existsSync(filePath)) {
        enhanceLanguagePage(filePath, language);
    } else {
        console.log(`⚠ File not found: ${language}-translation-services.html`);
    }
});

console.log('\n🎉 Schema enhancement complete!');
console.log('\n📋 What was enhanced:');
console.log('   • Service schema with detailed offer catalog');
console.log('   • FAQ schema for better search visibility');
console.log('   • Breadcrumb schema for navigation');
console.log('   • Enhanced descriptions and service types');
