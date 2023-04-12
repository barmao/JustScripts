#!/bin/bash

if [ -z "$1" ]
then
  echo "Please provide a project name."
  exit 1
fi

PROJECT_NAME=$1

# Create project directory
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Initialize a new npm project
npm init -y

# Install required dependencies
npm install --save next react react-dom styled-components axios redux react-redux redux-thunk @reduxjs/toolkit next-redux-wrapper
npm install --save-dev typescript @types/react @types/node @types/styled-components



# Create the project structure
mkdir -p pages/api
mkdir public
mkdir -p src/components src/lib src/context src/styles src/lib src/redux/slices src/redux/store src/redux/reducers
#mkdir -p src/{redux/{slices,store}}
#mkdir -p server/routes server/controllers

# Generate .gitignore
echo "node_modules/
.next/
out/" > .gitignore

# Generate package.json scripts
node -e "const package = require('./package.json');
package.scripts = {
  ...package.scripts,
  dev: 'next dev',
  build: 'next build',
  start: 'next start',
  lint: 'next lint',
  'type-check': 'tsc --noEmit'
};
require('fs').writeFileSync('./package.json', JSON.stringify(package, null, 2));"

# Generate tsconfig.json
echo '{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": false,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve"
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx"
  ],
  "exclude": [
    "node_modules"
  ]
}' > tsconfig.json

# Generate next-env.d.ts
echo '/// <reference types="next" />
/// <reference types="next/types/global" />' > next-env.d.ts

# Generate sample pages and necessary files for the project

# Generate src/redux/store/index.ts
echo "import { configureStore } from '@reduxjs/toolkit';
import { createWrapper } from 'next-redux-wrapper';
import rootReducer from '../reducers/rootReducer';

const makeStore = () => configureStore({ reducer: rootReducer });

export const wrapper = createWrapper(makeStore);
export const store = makeStore();" > src/redux/store/index.ts

# Generate src/redux/reducers/rootReducer.ts
echo "import { combineReducers } from '@reduxjs/toolkit';

const rootReducer = combineReducers({
  // Add your reducers here
});

export type RootState = ReturnType<typeof rootReducer>;
export default rootReducer;" > src/redux/reducers/rootReducer.ts

echo "import { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  res.status(200).json({ message: 'Hello from API route!' });
}" > pages/api/example.ts

echo "import '../src/styles/GlobalStyles';

function MyApp({ Component, pageProps }) {
  return <Component {...pageProps} />;
}

export default MyApp;" > pages/_app.tsx

echo "import Document, { Html, Head, Main, NextScript } from 'next/document';

class MyDocument extends Document {
  static async getInitialProps(ctx) {
    const initialProps = await Document.getInitialProps(ctx);
    return { ...initialProps };
  }

  render() {
    return (
      <Html>
        <Head />
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default MyDocument;" > pages/_document.tsx

echo "import Head from 'next/head';

const Home = () => (
  <>
    <Head>
      <title>MERN Next.js Project</title>
    </Head>
    <h1>Welcome to your MERN project with Next.js!</h1>
  </>
);

export default Home;" > pages/index.tsx

# Generate files under src directory

# Generate _app.tsx
echo "import { Provider } from 'react-redux';
import { store } from '../src/redux/store';
import { AppProps } from 'next/app';
import { wrapper } from '../src/redux/store';

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <Provider store={store}>
      <Component {...pageProps} />
    </Provider>
  );
}

export default wrapper.withRedux(MyApp);" > pages/_app.tsx

echo "import React from 'react';

const Header: React.FC = () => {
  return (
    <header>
      <h1>Header</h1>
    </header>
  );
};

export default Header;" > src/components/Header.tsx

echo "import React from 'react';

const Footer: React.FC = () => {
  return (
    <footer>
      <p>Footer</p>
    </footer>
  );
};

export default Footer;" > src/components/Footer.tsx

echo "import axios from 'axios';

const apiClient = axios.create({
  baseURL: '/api',
  timeout: 1000
});

export default apiClient;" > src/lib/api-client.ts

echo "import React, { createContext, useState } from 'react';

type AppContextValues = {
  theme: string;
  toggleTheme: () => void;
};

type AppContextProviderProps = {
  children: React.ReactNode;
};

export const AppContext = createContext<AppContextValues>({
  theme: 'light',
  toggleTheme: () => {},
});

const AppContextProvider: React.FC<AppContextProviderProps> = ({ children }) => {
  const [theme, setTheme] = useState<string>('light');

  const toggleTheme = () => {
    setTheme(theme === 'light' ? 'dark' : 'light');
  };

  return (
    <AppContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </AppContext.Provider>
  );
};

export default AppContextProvider;" > src/context/AppContext.tsx

echo "import { createGlobalStyle } from 'styled-components';

const GlobalStyles = createGlobalStyle`
  /* Add your global styles here */
`;

export default GlobalStyles;" > src/styles/GlobalStyles.ts
echo "Project structure created successfully."
