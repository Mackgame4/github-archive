<svelte:head>
	<title>BlockBox</title>
    <meta name="description" content="Page description">
</svelte:head>

<script>
    //import * as FBS from 'flowbite-svelte';
    //import { onMount } from 'svelte';
    import Home from './Home.svelte';

    let statusColor = "gray";
    let thisUser = {
        name: "John Doe",
        avatar: "https://i.redd.it/ni3joj3xob3a1.png",
        status: "Online",
    };

    if (thisUser.status == "Online") {
        statusColor = "green";
    } else if (thisUser.status == "Away") {
        statusColor = "gold";
    } else if (thisUser.status == "DoNotDisturb") {
        statusColor = "firebrick";
    } else {
        statusColor = "gray";
    }

    let activeMenu = 0;
    function setActiveMenu() {
        let menu = document.getElementsByClassName("menuOption");
        for (let i = 0; i < menu.length; i++) {
            menu[i].classList.remove("selected");
        }
        this.classList.add("selected");
        activeMenu = this.id.replace("menu-", "");
        activeMenu = parseInt(activeMenu);
    }

    let popMenuIndex = 0;

    let popMenuEnabled = false;
    function showPopMenu() {
        /* make menu slide in from right */
        if (popMenuEnabled) {
            document.getElementById("popMenu").style.width = "0";
            document.getElementById("popMenu").style.marginRight = "0";
            document.getElementById("popMenuContent").style.width = "0";
            document.getElementById("popMenuContent").style.marginRight = "0";
            popMenuEnabled = false;
        } else {
            /* gets the index of the button that was clicked */
            popMenuIndex = this.id.replace("popMenuButton-", "");
            popMenuIndex = parseInt(popMenuIndex);
            document.getElementById("popMenu").style.width = "400px";
            document.getElementById("popMenu").style.marginRight = "18px";
            document.getElementById("popMenuContent").style.width = "400px";
            document.getElementById("popMenuContent").style.marginRight = "18px";
            popMenuEnabled = true;
        }
    }
</script>

<main>
    <div class="sidebar">
        <div style="display: flex;">
            <img class="logo" src="/icon.png" alt="logo" />
            <h2 class="logoName">BlockBox™</h2>
        </div>
        <div class="sideMenu">
            <button on:click={setActiveMenu} id="menu-0" class="menuOption selected">
                <svg class="sideMenuIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path clip-rule="evenodd" fill-rule="evenodd" d="M6 5v1H4.667a1.75 1.75 0 00-1.743 1.598l-.826 9.5A1.75 1.75 0 003.84 19H16.16a1.75 1.75 0 001.743-1.902l-.826-9.5A1.75 1.75 0 0015.333 6H14V5a4 4 0 00-8 0zm4-2.5A2.5 2.5 0 007.5 5v1h5V5A2.5 2.5 0 0010 2.5zM7.5 10a2.5 2.5 0 005 0V8.75a.75.75 0 011.5 0V10a4 4 0 01-8 0V8.75a.75.75 0 011.5 0V10z"></path>
                </svg>
                <span>Store</span>
            </button>
            <button on:click={setActiveMenu} id="menu-1" class="menuOption">
                <svg class="sideMenuIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M4.75 3A1.75 1.75 0 003 4.75v2.752l.104-.002h13.792c.035 0 .07 0 .104.002V6.75A1.75 1.75 0 0015.25 5h-3.836a.25.25 0 01-.177-.073L9.823 3.513A1.75 1.75 0 008.586 3H4.75zM3.104 9a1.75 1.75 0 00-1.673 2.265l1.385 4.5A1.75 1.75 0 004.488 17h11.023a1.75 1.75 0 001.673-1.235l1.384-4.5A1.75 1.75 0 0016.896 9H3.104z"></path>
                </svg>
                <span>Your Library</span>
            </button>
            <button on:click={setActiveMenu} id="menu-2" class="menuOption">
                <svg class="sideMenuIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path clip-rule="evenodd" fill-rule="evenodd" d="M10 3a.75.75 0 01.75.75v10.638l3.96-4.158a.75.75 0 111.08 1.04l-5.25 5.5a.75.75 0 01-1.08 0l-5.25-5.5a.75.75 0 111.08-1.04l3.96 4.158V3.75A.75.75 0 0110 3z"></path>
                </svg>
                <span>Downloads</span>
            </button>
            <button on:click={setActiveMenu} id="menu-3" class="menuOption bottomMenu">
                <svg class="sideMenuIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path clip-rule="evenodd" fill-rule="evenodd" d="M2 3.5A1.5 1.5 0 013.5 2h9A1.5 1.5 0 0114 3.5v11.75A2.75 2.75 0 0016.75 18h-12A2.75 2.75 0 012 15.25V3.5zm3.75 7a.75.75 0 000 1.5h4.5a.75.75 0 000-1.5h-4.5zm0 3a.75.75 0 000 1.5h4.5a.75.75 0 000-1.5h-4.5zM5 5.75A.75.75 0 015.75 5h4.5a.75.75 0 01.75.75v2.5a.75.75 0 01-.75.75h-4.5A.75.75 0 015 8.25v-2.5z"></path>
                    <path d="M16.5 6.5h-1v8.75a1.25 1.25 0 102.5 0V8a1.5 1.5 0 00-1.5-1.5z"></path>
                </svg>
                <span>News</span>
            </button>
        </div>
    </div>
    <div id="main" class="main">
        <div id="searchInput">
            <svg class="icon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path clip-rule="evenodd" fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z"></path>
            </svg>
            <input class="searchInput" type="text" placeholder="Search whatever you want" />
            <button class="iconButton">
                <svg class="buttonIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M7 4a3 3 0 016 0v6a3 3 0 11-6 0V4z"></path>
                    <path d="M5.5 9.643a.75.75 0 00-1.5 0V10c0 3.06 2.29 5.585 5.25 5.954V17.5h-1.5a.75.75 0 000 1.5h4.5a.75.75 0 000-1.5h-1.5v-1.546A6.001 6.001 0 0016 10v-.357a.75.75 0 00-1.5 0V10a4.5 4.5 0 01-9 0v-.357z"></path>
                </svg>
            </button>
        </div>
        <div class="rightContainer">
            <div class="buttonContainer">
                <button on:click={showPopMenu} id="popMenuButton-0" class="roundIconButton">
                    <svg class="buttonIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path clip-rule="evenodd" fill-rule="evenodd" d="M10 2a6 6 0 00-6 6c0 1.887-.454 3.665-1.257 5.234a.75.75 0 00.515 1.076 32.91 32.91 0 003.256.508 3.5 3.5 0 006.972 0 32.903 32.903 0 003.256-.508.75.75 0 00.515-1.076A11.448 11.448 0 0116 8a6 6 0 00-6-6zM8.05 14.943a33.54 33.54 0 003.9 0 2 2 0 01-3.9 0z"></path>
                    </svg>
                </button>
                <button on:click={showPopMenu} id="popMenuButton-1" class="roundIconButton">
                    <svg class="buttonIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path d="M1 1.75A.75.75 0 011.75 1h1.628a1.75 1.75 0 011.734 1.51L5.18 3a65.25 65.25 0 0113.36 1.412.75.75 0 01.58.875 48.645 48.645 0 01-1.618 6.2.75.75 0 01-.712.513H6a2.503 2.503 0 00-2.292 1.5H17.25a.75.75 0 010 1.5H2.76a.75.75 0 01-.748-.807 4.002 4.002 0 012.716-3.486L3.626 2.716a.25.25 0 00-.248-.216H1.75A.75.75 0 011 1.75zM6 17.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15.5 19a1.5 1.5 0 100-3 1.5 1.5 0 000 3z"></path>
                    </svg>
                </button>
            </div>
            <button on:click={showPopMenu} class="avatarContainer" style="--statusColor: {statusColor}">
                <img class="avatar" src="{thisUser.avatar}" alt="avatar" />
            </button>
        </div>
        <div style="display: flex; height: calc(100% - 124px);">
            <div class="middleContainer">
                {#if activeMenu === 0}
                    <Home />
                {:else if activeMenu === 1}
                    <h1>News</h1>
                {/if}
            </div>
            <div id="popMenu" class="popMenu">
                <div id="popMenuContent" class="popMenuContent">
                    {#if popMenuIndex === 0}
                        <h2>Notifications</h2>
                    {:else if popMenuIndex === 1}
                        <h2>Cart</h2>
                    {:else}
                        <h2>Your account</h2>
                        <h2>Library</h2>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</main>

<style>
    main {
        display: flex;
        flex-direction: row;
        height: 100vh;
        width: 100vw;
    }

    .sidebar {
        background-color: #1A1B1F;
        border-right: 1px solid #222327;
        width: 300px;
        height: 100vh;
    }

    .logo {
        height: 60px;
        margin: 20px;
        margin-left: 40px;
    }

    .logoName {
        color: #FFFFFF;
        font-family: URWGeometricMedium;
        font-size: 24px;
        font-weight: 400;
        letter-spacing: 0.5px;
        margin: 34px -15px;
    }

    .sideMenu {
        display: flex;
        flex-direction: column;
        margin: 0px 30px;
        height: calc(100% - 104px);
    }

    .selected {
        background-color: #275EFE !important;
        box-shadow: 0 0 7px #275EFE !important;
    }

    .selected:hover {
        background-color: #3270FF !important;
        box-shadow: 0 0 7px #3270FF !important;
    }

    .selected span {
        color: #FFFFFF !important;
    }

    .selected .sideMenuIcon {
        fill: #FFFFFF !important;
    }

    .menuOption {
        display: flex;
        background-color: #232428;
        border-radius: 7px;
        padding: 13px 20px;
        flex-direction: row;
        align-items: center;
        margin: 20px 0px;
        cursor: pointer;
        transition: 0.3s;
    }

    .menuOption:hover {
        background-color: #2A2B30;
        box-shadow: 0 0 10px #222327;
    }

    .bottomMenu {
        margin-top: auto;
    }

    .sideMenuIcon {
        height: 20px;
        width: 20px;
        margin-right: 20px;
        fill: #A5A6AB;
    }

    .menuOption span {
        color: #FFFFFF;
        font-family: URWGeometricMedium;
        margin-top: 4px;
        font-size: 16px;
        font-weight: 400;
        letter-spacing: 0.5px;
    }

    .main {
        background-color: #1A1B1F;
        width: 100%;
        height: 100vh;
    }

    input:focus {
        outline: none;
    }

    .searchInput {
        background-color: #232428;
        border: 1px solid #222327;
        /*box-shadow: 0 0 10px #222327;*/
        border-radius: 7px;
        color: #FFFFFF;
        font-family: URWGeometricMedium;
        letter-spacing: 0.5px;
        font-weight: 400;
        font-size: 16px;
        height: 40px;
        margin: 20px;
        padding: 25px 40px;
        width: 30%;
        transition: 0.3s;
    }

    .searchInput:hover, .searchInput:focus {
        box-shadow: 0 0 10px #222327;
    }

    .searchInput::placeholder {
        color: #A5A6AB;
    }

    .icon {
        position: absolute;
        height: 20px;
        width: 20px;
        margin: 20px;
        top: 15px;
        transform: translate(65%, 0);
        fill: #A5A6AB;
    }

    .iconButton {
        background-color: #1A1B1F;
        border: 1px solid #1A1B1F;
        box-shadow: 0 0 7px #1A1B1F;
        border-radius: 7px;
        height: 35px;
        width: 35px;
        position: absolute;
        top: 29px;
        transform: translateX(-190%);
        cursor: pointer;
        transition: 0.3s;
    }

    .iconButton:hover {
        box-shadow: none;
    }

    .buttonIcon {
        height: 20px;
        width: 20px;
        margin-top: 1px;
        margin-left: 0.7px;
        fill: #A5A6AB;
    }

    .middleContainer {
        display: flex;
        flex-direction: column;
        /*background-color: #222327;*/
        width: 100%;
        height: 100%;
        border-radius: 7px;
        margin-top: 5px;
        margin-left: 20px;
        margin-right: 20px;
        transition: width 2s;
        overflow: auto;
    }

    .rightContainer {
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
    }

    .popMenu {
        display: flex;
        flex-direction: column;
        background-color: #222327;
        /*border: 1px solid #222327;*/
        /*box-shadow: 0 0 7px #222327;*/
        /*width: 400px;*/
        width: 0;
        height: 100%;
        border-radius: 7px;
        padding: 10px 0px;
        margin-top: 5px;
        /*margin-right: 20px;*/
        white-space: nowrap;
        z-index: 1;
        overflow: hidden;
        transition: ease-in-out 0.5s;
    }

    .popMenuContent h2 {
        color: #FFFFFF;
        font-family: URWGeometricMedium;
        font-size: 17px;
        font-weight: 400;
        letter-spacing: 0.5px;
        margin: 20px;
        margin-top: 10px;
    }

    .avatarContainer {
        border: 2px solid var(--statusColor);
        border-radius: 50%;
        height: 58px;
        width: 58px;
        margin: 20px;
        margin-top: -76px;
        margin-right: 16px;
        transition: 0.3s;
    }

    .avatarContainer:hover {
        box-shadow: 0 0 10px var(--statusColor);
    }

    .avatar {
        position: absolute;
        top: 0;
        right: 0;
        height: 50px;
        width: 50px;
        border-radius: 50%;
        margin: 20px;
        cursor: pointer;
        transition: 0.3s;
    }

    .avatar:hover {
        box-shadow: 0 0 10px #222327;
    }

    .buttonContainer {
        display: flex;
        flex-direction: row;
        justify-content: center;
        margin-top: -85px;
        margin-right: -10px;
    }

    :global(button) {
        border: none;
        outline: none;
        background: none;
    }

    :global(button:focus) {
        outline: none;
    }

    .roundIconButton {
        background-color: #232428;
        border: 1px solid #222327;
        /*box-shadow: 0 0 7px #222327;*/
        border-radius: 50%;
        height: 53px;
        width: 53px;
        margin: 10px;
        padding: 15px;
        cursor: pointer;
        transition: 0.3s;
    }

    .roundIconButton:hover {
        box-shadow: 0 0 10px #222327;
    }
</style>