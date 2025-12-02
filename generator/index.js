// const SERVER_API = "https://qr-generator-ve0u.onrender.com/api/encrypt"

// const response = await fetch("https://qr-generator-ve0u.onrender.com/api/encrypt", {
//     method: 'POST',
//     body: JSON.stringify({ name: "Nathanael", phone: "0900017309"})
// });

// const data = await response.json()

// console.log(response.ok)
// console.log(data) 

const crypto = require('crypto');

const SECRET_KEY_HEX = '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'; // 32 bytes (64 hex chars)
const ALGORITHM = 'aes-256-gcm';

// Helper to get key buffer
const getKey = () => Buffer.from(SECRET_KEY_HEX, 'hex');

function generateQR (name, phone) {
    try {
        if (!name || !phone) {
            throw new Error("Name and Phone is required!");
        }

        const iv = crypto.randomBytes(12); // 12 bytes for GCM
        const key = getKey();

        const cipher = crypto.createCipheriv(ALGORITHM, key, iv);

        const data = JSON.stringify({ name, phone });
        let encrypted = cipher.update(data, 'utf8', 'hex');
        encrypted += cipher.final('hex');

        const authTag = cipher.getAuthTag().toString('hex');

        // Create a hash for integrity check (similar to previous implementation)
        const hash = crypto.createHash('sha256')
            .update(SECRET_KEY_HEX + encrypted + iv.toString('hex') + authTag)
            .digest('hex');
        
        return { encrypted, iv, authTag, hash };
    } catch (error) {
        console.error('Encryption error:', error);
    }
}

const code = generateQR("Nathanael", "0900017309");

console.log(code);