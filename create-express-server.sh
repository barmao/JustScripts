#!/bin/bash

if [ -z "$1" ]
then
  echo "Please provide a project name."
  exit 1
fi

SERVER_PROJECT_NAME=$1

# Create server project directory
mkdir $SERVER_PROJECT_NAME
cd $SERVER_PROJECT_NAME

# Initialize a new npm project
npm init -y

# Install required dependencies
npm install --save bcrypt body-parser cors cross-env dotenv express jwt-simple loglevel-colored-level-prefix mongoose morgan
npm install --save-dev typescript @types/express @types/node @types/body-parser @types/cors @types/morgan @types/bcrypt nodemon ts-node

# Create server folder structure
mkdir -p src/{routes,controllers,models}

# Generate tsconfig.json
echo '{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "lib": [
      "es6"
    ],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules"
  ]
}' > tsconfig.json

# Update the scripts section of the package.json file
sed -i.bak 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"dev": "cross-env NODE_ENV=development nodemon --exec ts-node src\/index.ts", "start": "cross-env NODE_ENV=production node dist\/index.js", "postinstall": "tsc", "build": "tsc"/' package.json && rm package.json.bak

# Generate server files

# Generate app.ts
echo "import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import exampleRoute from './routes/exampleRoute';

dotenv.config();

const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api', exampleRoute);

export default app;" > src/app.ts

# Generate index.ts
echo "import http from 'http';
import app from './app';

const port = process.env.PORT || 3000;

const server = http.createServer(app);

server.listen(port, () => {
  console.log(\`Server running on port \$\{port\}\`);
});" > src/index.ts

# Generate exampleRoute.ts
echo "import { Router } from 'express';
import exampleController from '../controllers/exampleController';

const router = Router();

router.get('/example', exampleController.getExample);

export default router;" > src/routes/exampleRoute.ts

# Generate exampleController.ts
echo "import { Request, Response } from 'express';

export const getExample = (req: Request, res: Response) => {
  res.json({ message: 'Example route from server' });
};" > src/controllers/exampleController.ts

# Generate example model
echo "import { Schema, model } from 'mongoose';

const ExampleSchema = new Schema({
  name: String,
  age: Number
});

const ExampleModel = model('Example', ExampleSchema);

export default ExampleModel;" > src/models/ExampleModel.ts

echo "Express server project created successfully."
