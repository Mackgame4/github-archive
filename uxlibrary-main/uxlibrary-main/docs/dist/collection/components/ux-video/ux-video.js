import { h } from '@stencil/core';
export class UxVideo {
  constructor() {
    this.src = 'https://www.youtube.com/watch?v=Tx9zMFodNtA';
    this.autoplay = false;
    this.loop = false;
    this.muted = this.autoplay || false;
    this.controls = true;
    this.fullscreen = false;
    this.theater = false;
    this.hasVideoLoaded = false;
    this.isPlaying = this.autoplay || false;
    this.isMuted = this.muted || false;
    this.duration = 0;
    this.currentTime = 0;
    this.supportsPictureInPicture = false;
    this.isPictureInPicture = false;
  }
  // Default function to run when the component is loaded
  componentDidLoad() {
    setTimeout(() => {
      this.getVideoDuration();
      if (this.autoplay) {
        this.playVideo();
        this.timer(false);
      }
    }, 1);
  }
  isVideoSrcFile() {
    const src = this.src;
    if (src.indexOf('.mp4') !== -1 || src.indexOf('.webm') !== -1 || src.indexOf('.ogg') !== -1) {
      this.supportsPictureInPicture = true;
      return true;
    }
    this.supportsPictureInPicture = false;
    return src.indexOf('http') === -1;
  }
  getVideoEmbed(src) {
    try {
      const url = new URL(src);
      if (url.searchParams.get('v')) {
        return src.replace('watch?v=', 'embed/');
      }
    }
    catch (e) {
      console.error(e);
    }
    return src;
  }
  playVideo() {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      video.play();
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        iframe.contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
      }
    }
  }
  pauseVideo() {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      video.pause();
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        iframe.contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
      }
    }
  }
  playPauseVideo() {
    if (!this.isPlaying) {
      this.playVideo();
      this.timer(false);
    }
    else {
      this.pauseVideo();
      this.timer(true);
    }
    this.isPlaying = !this.isPlaying;
  }
  changeAudioLevel(level) {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      if (level === 0) {
        video.muted = true;
      }
      else {
        video.muted = false;
        video.volume = level / 100;
      }
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        if (level === 0) {
          iframe.contentWindow.postMessage('{"event":"command","func":"mute","args":""}', '*');
        }
        else {
          iframe.contentWindow.postMessage('{"event":"command","func":"unMute","args":""}', '*');
          iframe.contentWindow.postMessage(`{"event":"command","func":"setVolume","args":[${level}]}`, '*');
        }
      }
    }
    this.isMuted = level === 0;
  }
  getVideoDuration() {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      this.duration = Math.round(video.duration);
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        try {
          const apiKey = 'AIzaSyDvbdyu40r6L2v22ZPW5eooyRb00TFeVcI'; // TODO: get this from a config file or env variable
          fetch(`https://www.googleapis.com/youtube/v3/videos?id=${this.src.split('v=')[1]}&key=${apiKey}&part=contentDetails`)
            .then(response => response.json())
            .then(data => {
            const duration = data.items[0].contentDetails.duration;
            const hours = duration.match(/(\d+)H/);
            const minutes = duration.match(/(\d+)M/);
            const seconds = duration.match(/(\d+)S/);
            this.duration = (hours ? parseInt(hours[1]) * 3600 : 0) + (minutes ? parseInt(minutes[1]) * 60 : 0) + (seconds ? parseInt(seconds[1]) - 1 : 0);
          });
        }
        catch (e) {
          console.error(e);
        }
      }
    }
  }
  formatTimer(time) {
    const hours = Math.floor(time / 3600);
    const minutes = Math.floor((time - (hours * 3600)) / 60);
    const seconds = time - (hours * 3600) - (minutes * 60);
    let result = (minutes < 10 ? '0' + minutes : minutes) + ':' + (seconds < 10 ? '0' + seconds : seconds);
    if (hours > 0) {
      result = hours + ':' + result;
    }
    return result;
  }
  timer(isPaused) {
    if (this.isVideoSrcFile()) {
      const video = this.el.shadowRoot.querySelector('video');
      this.currentTime = Math.round(video.currentTime);
      if (isPaused) {
        clearInterval(this.timerInterval);
      }
      else {
        this.timerInterval = setInterval(() => {
          this.currentTime = Math.round(video.currentTime);
          if (this.currentTime >= this.duration) {
            this.currentTime = 0;
            if (!this.loop) {
              this.playPauseVideo();
            }
          }
        }, 999); // 999 because the timer starts within 1 ms
      }
    }
    else {
      if (isPaused) {
        clearInterval(this.timerInterval);
      }
      else {
        this.timerInterval = setInterval(() => {
          this.currentTime++;
          if (this.currentTime >= this.duration) {
            this.currentTime = 0;
            if (!this.loop) {
              this.playPauseVideo();
            }
          }
        }, 999); // 999 because the timer starts within 1 ms
      }
    }
  }
  pictureInPicture() {
    const video = this.el.shadowRoot.querySelector('video');
    if (video && this.supportsPictureInPicture) {
      video.addEventListener('leavepictureinpicture', () => {
        this.isPictureInPicture = false;
        this.pauseVideo();
      });
      if (!this.isPictureInPicture) {
        video.requestPictureInPicture();
        this.isPictureInPicture = true;
      }
      else {
        console.log('exitPictureInPicture');
        document.exitPictureInPicture();
        this.isPictureInPicture = false;
      }
    }
    else {
      console.error('Picture in picture not supported');
    }
  }
  fullscreenToggle(mode) {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      if (!mode || !this.fullscreen) {
        this.fullscreen = true;
        video.requestFullscreen();
      }
      else {
        this.fullscreen = false;
        document.exitFullscreen();
      }
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        if (!mode || !this.fullscreen) {
          this.fullscreen = true;
          iframe.requestFullscreen();
        }
        else {
          this.fullscreen = false;
          document.exitFullscreen();
        }
      }
    }
  }
  theaterToggle() {
    let style = '';
    if (!this.theater) {
      this.theater = true;
      // hide scrollbars
      style = `::-webkit-scrollbar { display: none; }`;
    }
    else {
      this.theater = false;
      // show scrollbars
      style = `::-webkit-scrollbar { display: block; }`;
    }
    const styleElement = document.createElement('style');
    styleElement.type = 'text/css';
    styleElement.appendChild(document.createTextNode(style));
    document.head.appendChild(styleElement);
  }
  changeTime(event) {
    const video = this.el.shadowRoot.querySelector('video');
    if (video) {
      //this.currentTime = event.target.value;
      video.currentTime = event.target.value;
      this.isPlaying = true;
    }
    else {
      const iframe = this.el.shadowRoot.querySelector('iframe');
      if (iframe) {
        this.currentTime = event.target.value;
        this.isPlaying = true;
        iframe.contentWindow.postMessage(JSON.stringify({ event: 'command', func: 'seekTo', args: [event.target.value] }), '*');
      }
    }
  }
  render() {
    return (h("div", { class: `video ${this.theater ? 'video-theaterscreen' : ''}` }, h("div", { class: "video-container" }, this.isVideoSrcFile() ? (h("video", { class: "video", autoplay: this.autoplay, loop: this.loop, muted: this.muted, playsinline: true, preload: "auto", src: this.src })) : (h("iframe", { class: "video", src: `${this.getVideoEmbed(this.src)}?autoplay=${this.autoplay}&mute=${this.muted}&loop=${this.loop}&controls=0&modestbranding=1&playsinline=1&rel=0&enablejsapi=1`, frameborder: "0", allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" }))), h("div", { class: "video-controls" }, h("div", { class: "controls-left" }, h("ux-button", { onClick: () => this.playPauseVideo() }, this.isPlaying ? h("ux-icon", { icon: "pause" }) : h("ux-icon", { icon: "play" })), h("ux-button", { onClick: () => this.changeAudioLevel(this.isMuted ? 100 : 0) }, this.isMuted ? h("ux-icon", { icon: "volume-mute" }) : h("ux-icon", { icon: "volume-high" })), h("input", { class: "video-volume", type: "range", min: "0", max: "100", value: this.isMuted ? 0 : 100, onInput: (e) => this.changeAudioLevel(parseInt(e.target.value)) }), h("span", null, h("span", null, this.formatTimer(this.currentTime)), " / ", h("span", null, this.formatTimer(this.duration)))), h("input", { class: "video-time", type: "range", min: "0", max: this.duration, value: this.currentTime, onInput: (e) => this.changeTime(e) }), this.controls ? (h("div", { class: "controls-right" }, this.isVideoSrcFile() ? (h("ux-button", { onClick: () => this.pictureInPicture() }, h("ux-icon", { icon: "picture-in-picture-bottom-right" }))) : null, h("ux-button", { onClick: () => this.theaterToggle() }, h("ux-icon", { icon: "rectangle-outline" })), h("ux-button", { onClick: () => this.fullscreenToggle() }, h("ux-icon", { icon: "fullscreen" })))) : null)));
  }
  static get is() { return "ux-video"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-video.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-video.css"]
    };
  }
  static get properties() {
    return {
      "src": {
        "type": "string",
        "mutable": false,
        "complexType": {
          "original": "string",
          "resolved": "string",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "src",
        "reflect": false,
        "defaultValue": "'https://www.youtube.com/watch?v=Tx9zMFodNtA'"
      },
      "autoplay": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "autoplay",
        "reflect": false,
        "defaultValue": "false"
      },
      "loop": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "loop",
        "reflect": false,
        "defaultValue": "false"
      },
      "muted": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "muted",
        "reflect": false,
        "defaultValue": "this.autoplay || false"
      },
      "controls": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "controls",
        "reflect": false,
        "defaultValue": "true"
      },
      "fullscreen": {
        "type": "boolean",
        "mutable": true,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "fullscreen",
        "reflect": false,
        "defaultValue": "false"
      },
      "theater": {
        "type": "boolean",
        "mutable": true,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "theater",
        "reflect": false,
        "defaultValue": "false"
      }
    };
  }
  static get states() {
    return {
      "hasVideoLoaded": {},
      "isPlaying": {},
      "isMuted": {},
      "duration": {},
      "currentTime": {},
      "supportsPictureInPicture": {},
      "isPictureInPicture": {}
    };
  }
  static get elementRef() { return "el"; }
}
