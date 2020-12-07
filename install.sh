#!/bin/bash

set -e


rm README.md


# create react app in subdir and move files to root
npx create-react-app my-app --template redux-typescript
mv my-app/* .
mv my-app/.[!.]* ./
rmdir my-app


# add updates
yarn add @testing-library/jest-dom@^5.11.6 \
    @testing-library/react@^11.2.2 \
    @testing-library/user-event@^12.5.0 \
    typescript@^4.1.2 \
    @types/jest@^26.0.16 \
    @types/node@^14.14.10 \
    @types/react@^17.0.0 \
    @types/react-dom@^17.0.0 \
    typescript@^4.1.2


yarn add -D \
@rainthief/react-lint-config@^0.0.11 \
react-app-polyfill@^2.0.0


# modify package.json
node --experimental-modules editConfig.mjs && rm editConfig.mjs


# add polyfil import
sed -i.old "/^import \* as serviceWorker/a import 'react-app-polyfill\/stable';\n" src/index.tsx
chmod --reference src/index.tsx.old src/index.tsx
rm src/index.tsx.old


# add temp node modules folder created in pipeline
echo "_node_modules" >> .gitignore
echo ".eslintcache" >> .gitignore

# delete this file
rm install.sh
