
exports("FormatUnixForBirthday", (unix) => { // https://momentjs.com/docs/#/displaying/
    return new Date(unix * 1000).toLocaleString('en-US', { 
        month: 'short',
        day: 'numeric',
        year: 'numeric'
    })
});