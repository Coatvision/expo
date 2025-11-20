const path = require('path');

const lintAsync = require('./tools/lint8Async');
const { normalizeLintResult, toPosixPath } = require('./tools/testUtils');

const configFile = path.resolve(__dirname, '../default.js');

it('lints custom rules', async () => {
  const results = await lintAsync(
    {
      overrideConfigFile: configFile,
      ignore: false,
      useEslintrc: false,
    },
    ['fixtures/rule-*']
  );
  for (const result of results) {
    const relativeFilePath = toPosixPath(path.relative(__dirname, result.filePath));
    normalizeLintResult(result);
    expect(result).toMatchSnapshot(relativeFilePath);
  }
}, 20000);
