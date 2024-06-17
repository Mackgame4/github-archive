const Digits = '0123456789';
const Chars = {
    'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8,
    'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'P': 7, 'R': 9,
    'S': 2, 'T': 3, 'U': 4, 'V': 5, 'W': 6, 'X': 7, 'Y': 8, 'Z': 9,
    '0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
};

const Weights = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2];

function randomFromArray(array) {
    return array[Math.floor(Math.random() * array.length)];
};

const randomString = (length, charSet) => {
    if (length === 0) {
        return '';
    }
    const chars = charSet.split('');
    return Array(length).fill('').map((_) => randomFromArray(chars)).join('');
};

exports("GenerateVIN", (owned) => {
     // Don't accept I, O, Q characters
    const charsSet = `ABCDEFGHJKLMNPRSTUVWXYZ${Digits}`;
    const prefix = owned ? 'A' : 'B';
    const generated = `${prefix}${randomString(7, charsSet)}${randomString(1, `${Digits}X`)}${randomString(8, charsSet)}`;
    const sum = generated.split('').map((c, index) => Chars[c] * Weights[index]).reduce((a, b) => a + b, 0);
    const remainder = sum % 11;
    const checkCharacter = remainder === 10 ? 'X' : `${remainder}`;
    return `${generated.substr(0, 8)}${checkCharacter}${generated.substr(9)}`;
});

exports("GeneratePlate", () => {
    // Don't accept I, O, Q characters because they all basically look the same
    const charsSet = `ABCDEFGHJKLMNPRSTUVWXYZ${Digits}`;
    const generated = randomString(8, charsSet)
    return generated;
});