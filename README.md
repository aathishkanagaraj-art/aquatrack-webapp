# 🌊 AquaTrack

AquaTrack is a comprehensive water management system built with Next.js, designed to help manage bore wells, track water usage, monitor expenses, and generate detailed reports.

## 🚀 Quick Start

### Windows Users
```bash
# Quick development start
quick-start.bat

# Full development start with verbose output
dev.bat

# Production build and start
start.bat
```

### PowerShell Users
```powershell
# Start development server
.\dev.ps1

# Clean install and start
.\dev.ps1 -Clean

# Force reinstall dependencies
.\dev.ps1 -Install

# Show help
.\dev.ps1 -Help
```

### Unix/Linux/Mac Users
```bash
# Make script executable (first time only)
chmod +x dev.sh

# Start development server
./dev.sh

# Clean install and start
./dev.sh --clean

# Force reinstall dependencies
./dev.sh --install

# Show help
./dev.sh --help
```

## 🏗️ Project Structure

```
aquatrack/
├── 📁 app/                 # Next.js App Router pages
│   ├── 📁 api/            # API routes
│   ├── 📁 dashboard/      # Dashboard pages
│   └── 📁 owner/          # Owner management pages
├── 📁 components/         # Reusable React components
│   ├── 📁 dashboard/      # Dashboard-specific components
│   └── 📁 ui/            # UI component library
├── 📁 contexts/           # React context providers
├── 📁 hooks/             # Custom React hooks
├── 📁 lib/               # Utility libraries and configurations
├── 📁 prisma/            # Database schema and migrations
├── 📁 scripts/           # Development and deployment scripts
└── 📁 ui/               # Additional UI components
```

## 🛠️ Features

- **💧 Bore Well Management**: Track and manage multiple bore wells
- **📊 Water Usage Monitoring**: Monitor daily water consumption
- **💰 Expense Tracking**: Track diesel, labor, and maintenance costs
- **📈 Analytics Dashboard**: Visual insights and reporting
- **👥 Multi-User Support**: Owner and manager role management
- **📱 Responsive Design**: Works on desktop, tablet, and mobile
- **🔐 Secure Authentication**: Built-in user authentication
- **📄 Report Generation**: PDF report generation with charts

## 🔧 Technology Stack

- **Frontend**: Next.js 15, React, TypeScript
- **Styling**: Tailwind CSS, Radix UI
- **Database**: Prisma ORM with PostgreSQL/SQLite
- **Authentication**: Custom auth system
- **Charts**: Chart.js integration
- **PDF Generation**: jsPDF with autotable
- **Deployment**: Vercel/Firebase hosting ready

## 📋 Prerequisites

- **Node.js** >= 18.0.0
- **npm** or **yarn**
- **Database** (PostgreSQL recommended, SQLite for development)

## 🔧 Environment Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aquatrack.git
   cd aquatrack
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create environment file**
   ```bash
   cp .env.example .env
   ```
   
4. **Configure your environment variables in `.env`**
   ```env
   # For development (SQLite)
   DATABASE_URL="file:./dev.db"
   
   # For production (PostgreSQL/MySQL)
   # DATABASE_URL="postgresql://username:password@localhost:5432/aquatrack"
   ```

5. **Initialize the database**
   ```bash
   npx prisma db push
   npx prisma generate
   ```

6. **Start development server**
   ```bash
   npm run dev
   ```
   
   Or use platform-specific scripts:
   - **Windows**: `.\dev.bat` or `.\quick-start.bat`
   - **PowerShell**: `.\dev.ps1`
   - **Unix/Linux**: `./dev.sh`

## 🚦 Development Workflow

1. **Start development server**
   - Windows: `dev.bat` or `quick-start.bat`
   - PowerShell: `.\dev.ps1`
   - Unix/Linux: `./dev.sh`

2. **Access the application**
   - Open browser to `http://localhost:9002`
   - Development server with hot reload

3. **Database operations**
   ```bash
   npx prisma studio          # Open database GUI
   npx prisma migrate dev     # Run migrations
   npx prisma generate       # Generate client
   ```

## 🏭 Production Deployment

1. **Build the application**
   ```bash
   npm run build
   ```

2. **Start production server**
   ```bash
   npm start
   # or use start.bat on Windows
   ```

3. **Environment considerations**
   - Set `NODE_ENV=production`
   - Configure production database
   - Set up proper domain and SSL

## 📁 Key Directories

- `app/`: Next.js app router pages and API routes
- `components/`: Reusable React components
- `lib/`: Utility functions and configurations
- `prisma/`: Database schema and migrations
- `scripts/`: Development and deployment scripts

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues and questions:
- Check the documentation
- Review existing issues
- Create a new issue with detailed information

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**🌊 AquaTrack - Managing Water Resources with Technology**
