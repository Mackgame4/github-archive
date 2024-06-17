let niceCb = false;

const emulatedResponses = {}

/* eslint-disable no-unreachable */

export default {
    setCb(cb) {
        niceCb = cb;
    },
    async send(event, data = {}) {
        /* eslint-disable no-async-promise-executor */
        return new Promise(async res => {
            /// #if DEBUG && !INGAMEDEBUG
            const response = emulatedResponses[event] ? emulatedResponses[event] : null;
            setTimeout(() => res(response), 350);
            niceCb(true, event, data, response);
            return;
            /// #endif
            const realEventResponse = await fetch(`https://arp-phone/${event}`, {
                method: 'post',
                headers: {
                    'Content-type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify(data),
            }).then(resp => resp.json());
            niceCb(true, event, data, realEventResponse);
            res(realEventResponse)
        })
        /* eslint-enable no-async-promise-executor */
    },
    emulate(event, data = null) {
        window.dispatchEvent(new MessageEvent('message', {
            data: {
                event,
                data,
            },
        }));
    },
    addEmulatedResponse(event, responseData) {
        emulatedResponses[event] = responseData;
    },
    removeEmulatedResponse(event) {
        delete emulatedResponses[event];
    },
    inDev() {
        /// #if DEBUG
        return true;
        /// #endif
        return false;
    },
    doDelay(ms) {
        return new Promise(res => setTimeout(res, ms));
    }
};
