Open your terminal or command prompt.

Navigate to the directory where you want to create your Next.js app.

Run the following command to create a new Next.js app with TypeScript:

```
npx create-next-app --example with-typescript <app-name>

```

Replace `<app-name>` with the name you want to give your app. This will create a new directory with the specified name and install all the required dependencies for a basic Next.js app with TypeScript support.

Once the app is created, navigate into the app directory:

```
cd <app-name>
```

Here's an installation script that can be used to install the dependencies specified in the `package.json` file:

```
npm install @reduxjs/toolkit axios  next next-redux-wrapper react react-dom react-redux redux redux-thunk styled-components
npm install --save-dev typescript @types/node @types/react @types/styled-components
```
  
This will install all the dependencies specified in the `package.json` file. You're now ready to start building your Next.js app with the installed dependencies!

Run the following command to start the development server:

```
npm run dev
```

This will start the development server and you can access your app at `http://localhost:3000`.
