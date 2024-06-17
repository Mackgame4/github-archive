export const isImageUrlValid = (url) => {
    if (typeof(url) === 'string') {
        // * I hate Regex, Checks that the string starts with https:// (that is not repeated again) and then it ands with . proceeded by a valid
        // * file name extension that is there
        const validRegex = /^(?:(?!https:\/\/))*https:\/\/(?!https:\/\/).*\.(jpg|jpeg|png|apng|gif|webp)$/.test(url);
        return validRegex;
    } else return false;
}

export const isNumberValid = (num) => {
    if (typeof(num) === 'string') {
        const valid = num.search('^[0-9]{3}-[0-9]{3}-[0-9]{4}$');
        return !valid;
    } else return false;
}