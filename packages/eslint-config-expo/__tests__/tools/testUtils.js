const REGEXP_REPLACE_SLASHES = /\\/g;

function toPosixPath(filePath) {
  return filePath.replace(REGEXP_REPLACE_SLASHES, '/');
}

function normalizeLintResult(result) {
  delete result.filePath;

  // The `fix.range` property varies between platforms.
  // On Windows, the CRLF line endings add extra characters to the range.
  for (const message of result.messages) {
    if (message.fix?.range != null) {
      delete message.fix.range;
    }

    if (message.suggestions != null) {
      for (const suggestion of message.suggestions) {
        if (suggestion.fix?.range != null) {
          delete suggestion.fix.range;
        }
      }
    }
  }
}

module.exports = {
  toPosixPath,
  normalizeLintResult,
};
