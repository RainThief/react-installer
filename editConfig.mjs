import fs from 'fs';

const pkg = JSON.parse(fs.readFileSync('./package.json'));

pkg['private'] = true;

pkg['jest'] = {
  'collectCoverageFrom': [
    'src/**/*.{js,jsx,ts,tsx}',
    '!**/*.d.ts',
    '!src/serviceWorker.ts',
    '!src/index.tsx'
  ],
  'coverageThreshold': {
    'global': {
      'branches': 80,
      'functions': 80,
      'lines': 80,
      'statements': -10
    }
  }
};

pkg['browserslist']['production'].push('chrome 39');

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 4));
