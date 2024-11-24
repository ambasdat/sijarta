# SIJARTA by AMBASDAT

### 🚀 Getting Started

Follow these steps to set up and run the SIJARTA application locally:

1. **Clone the Repository**

   Start by cloning the GitHub repository to your local machine:

   ```bash
   git clone https://github.com/ambasdat/sijarta.git
   cd sijarta
   ```

2. **Install Node.js**

   Ensure Node.js is installed on your system. If not, download and install it from [nodejs.org](https://nodejs.org/en/download).

   Verify the installation by running:

   ```bash
   node -v
   # Expected output: v20.15.1

   npm -v
   # Expected output: 10.7.0
   ```

3. **Install Dependencies**

   Inside the project directory, install the required packages:

   ```bash
   npm install
   ```

4. **Set Up Environment Variables**

   - Locate the .env.example file in the root directory.
   - Create a new file named .env and copy the contents of .env.example into it.
   - Update the file with your specific configuration values.

5. **Prepare the Database**

   Before starting the application, you need to set up the database schema and dummy data. Run the following command:

   > [!WARNING]
   > 
   > Ensure the target database is correct as this process overwrites the entire database.

   ```
   npm run prepare
   ```

6. **Start the Development Server**

   Run the following command to launch the development server:

   ```bash
   npm run dev
   ```

7. **Open the Application**

   Once the server is running, open your browser and navigate to the URL displayed in the terminal (http://localhost:3000) to view the application. 🎉
