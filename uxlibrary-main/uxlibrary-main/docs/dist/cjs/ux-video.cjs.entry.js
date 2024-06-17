'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

const index = require('./index-2bfa05d9.js');

const uxVideoCss = ":host{display:block}.video{position:relative;display:flex;justify-content:center;width:800px;height:auto}.video-container{overflow:hidden;width:100%;aspect-ratio:16/9;pointer-events:none}.video-container iframe{width:100%;height:100%}.video-theaterscreen{position:fixed;top:0;left:0;width:100%;height:100%}.video-controls{position:absolute;bottom:0;left:0;width:100%;height:40px;background-color:var(--containerSecondary);pointer-events:auto}.video-controls button{background-color:transparent;border:none;color:white;cursor:pointer}.controls-left{display:flex;align-items:center;float:left}.controls-right{display:flex;align-items:center;float:right}.video-time{position:absolute;top:0;left:0;width:100%;height:3px;background-color:red;border:none;border-radius:0;transform:translateY(-50%)}";

const UxVideo = class {
  constructor(hostRef) {
    index.registerInstance(this, hostRef);
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
    return (index.h("div", { class: `video ${this.theater ? 'video-theaterscreen' : ''}` }, index.h("div", { class: "video-container" }, this.isVideoSrcFile() ? (index.h("video", { class: "video", autoplay: this.autoplay, loop: this.loop, muted: this.muted, playsinline: true, preload: "auto", src: this.src })) : (index.h("iframe", { class: "video", src: `${this.getVideoEmbed(this.src)}?autoplay=${this.autoplay}&mute=${this.muted}&loop=${this.loop}&controls=0&modestbranding=1&playsinline=1&rel=0&enablejsapi=1`, frameborder: "0", allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" }))), index.h("div", { class: "video-controls" }, index.h("div", { class: "controls-left" }, index.h("ux-button", { onClick: () => this.playPauseVideo() }, this.isPlaying ? index.h("ux-icon", { icon: "pause" }) : index.h("ux-icon", { icon: "play" })), index.h("ux-button", { onClick: () => this.changeAudioLevel(this.isMuted ? 100 : 0) }, this.isMuted ? index.h("ux-icon", { icon: "volume-mute" }) : index.h("ux-icon", { icon: "volume-high" })), index.h("input", { class: "video-volume", type: "range", min: "0", max: "100", value: this.isMuted ? 0 : 100, onInput: (e) => this.changeAudioLevel(parseInt(e.target.value)) }), index.h("span", null, index.h("span", null, this.formatTimer(this.currentTime)), " / ", index.h("span", null, this.formatTimer(this.duration)))), index.h("input", { class: "video-time", type: "range", min: "0", max: this.duration, value: this.currentTime, onInput: (e) => this.changeTime(e) }), this.controls ? (index.h("div", { class: "controls-right" }, this.isVideoSrcFile() ? (index.h("ux-button", { onClick: () => this.pictureInPicture() }, index.h("ux-icon", { icon: "picture-in-picture-bottom-right" }))) : null, index.h("ux-button", { onClick: () => this.theaterToggle() }, index.h("ux-icon", { icon: "rectangle-outline" })), index.h("ux-button", { onClick: () => this.fullscreenToggle() }, index.h("ux-icon", { icon: "fullscreen" })))) : null)));
  }
  get el() { return index.getElement(this); }
};
UxVideo.style = uxVideoCss;

exports.ux_video = UxVideo;
