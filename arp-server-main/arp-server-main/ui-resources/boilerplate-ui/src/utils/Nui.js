let niceCb = false;

const emulatedResponses = {}

export default {
    setCb(cb) {
        niceCb = cb;
    },
    async send(event, data = {}) {
        /* eslint-disable no-async-promise-executor */
        return new Promise(async res => {
            /// #if DEBUG
            const response = emulatedResponses[event] ? emulatedResponses[event] : false;
            setTimeout(() => res(response), 250);
            niceCb(true, event, data, response);
            return;
            /// #endif

            /* eslint-disable no-unreachable */
            const realEventResponse = await fetch(`https://arp-ui/${event}`, {
                method: 'post',
                headers: {
                    'Content-type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify(data),
            }).then(resp => resp.json());
            niceCb(true, event, data, realEventResponse);
            res(realEventResponse)

            /* eslint-enable no-unreachable  */
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
        /* eslint-disable no-unreachable */
        /// #if DEBUG
        return true;
        /// #endif
        return false;
        /* eslint-enable no-unreachable  */
    },
    doDelay(ms) {
        return new Promise(res => setTimeout(res, ms));
    }
};
