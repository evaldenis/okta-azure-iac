const express = require('express');
const session = require('express-session');
const { ExpressOIDC } = require('@okta/oidc-middleware');

const app = express();
const port = process.env.PORT || 3000;

// Trust the reverse proxy (Azure App Service)
// This is required for 'cookie.secure: true' to work when SSL is terminated at the load balancer
app.set('trust proxy', 1);

app.use(session({
  secret: process.env.SESSION_SECRET || 'your-session-secret-change-in-production',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000
  }
}));

const oidc = new ExpressOIDC({
  issuer: process.env.OKTA_ISSUER,
  client_id: process.env.OKTA_CLIENT_ID,
  client_secret: process.env.OKTA_CLIENT_SECRET,
  appBaseUrl: process.env.APP_BASE_URL || 'http://localhost:3000',
  redirect_uri: process.env.REDIRECT_URI || 'http://localhost:3000/authorization-code/callback',
  scope: 'openid profile email',
  routes: {
    loginCallback: {
      afterCallback: '/profile'
    }
  }
});

app.use(oidc.router);

app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

app.get('/', (req, res) => {
  if (req.userContext) {
    return res.redirect('/profile');
  }
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Okta OIDC Sample App</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 50px auto;
          padding: 20px;
          background-color: #f5f5f5;
        }
        .container {
          background: white;
          padding: 40px;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          text-align: center;
        }
        h1 {
          color: #333;
        }
        .login-btn {
          display: inline-block;
          padding: 12px 24px;
          background-color: #007bff;
          color: white;
          text-decoration: none;
          border-radius: 4px;
          font-size: 16px;
          margin-top: 20px;
        }
        .login-btn:hover {
          background-color: #0056b3;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🔐 Okta OIDC Sample Application</h1>
        <p>This is a proof of concept demonstrating OIDC authentication with Okta.</p>
        <p>Infrastructure managed by Terraform (Infrastructure as Code).</p>
        <a href="/login" class="login-btn">Login with Okta</a>
      </div>
    </body>
    </html>
  `);
});

// Protected profile route - shows user information (Bonus 2)
app.get('/profile', oidc.ensureAuthenticated(), (req, res) => {
  res.render('profile', {
    user: req.userContext.userinfo
  });
});

// Logout route
app.get('/logout', (req, res) => {
  req.logout();
  res.redirect('/');
});

// Start server
oidc.on('ready', () => {
  app.listen(port, () => {
    console.log(`🚀 Server running on port ${port}`);
    console.log(`📍 Visit: http://localhost:${port}`);
  });
});

oidc.on('error', err => {
  console.error('OIDC Error:', err);
});
