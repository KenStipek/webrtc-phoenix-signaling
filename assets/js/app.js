// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

let channel = socket.channel("call", {})

// Both join websocket channel
channel.join()
  .receive("ok", () => { console.log("Successfully joined call channel") })
  .receive("error", () => { console.log("Unable to join") })

let localStream, peerConnection;
let localVideo = document.getElementById("localVideo");
let remoteVideo = document.getElementById("remoteVideo");
let connectButton = document.getElementById("connect");
let callButton = document.getElementById("call");
let hangupButton = document.getElementById("hangup");

hangupButton.disabled = true;
callButton.disabled = true;
connectButton.onclick = connect;
callButton.onclick = call;
hangupButton.onclick = hangup;



var conf = {iceServers: [{url: 'stun:stun.l.google.com:19302'}]};
const error = e => console.log("error: " + e);

// Both set peerConnection
// Initialize:


function connect() {
    peerConnection = new RTCPeerConnection(conf);
    console.log("Created local peer connection");
    peerConnection.onicecandidate = event => {
    if (event.candidate) {
        console.log("Local ICE candidate: \n" + event.candidate.candidate);
        channel.push("message", {body: JSON.stringify({
                    "candidate": event.candidate
                })});
        }
    }
    peerConnection.onaddstream = event => {
        remoteVideo.src = URL.createObjectURL(event.stream);
        console.log("Received remote stream");
    }

    console.log("Requesting access to local video and audio");
    navigator.mediaDevices.getUserMedia( { video: true, audio: false } )
        .then(stream => {
            console.log("Received local video & audio stream");
            localVideo.src = URL.createObjectURL(stream);
            localStream = stream;
        })
        .then(() => {
            connectButton.disabled = true;
            callButton.disabled = false;
            hangupButton.disabled = false;
            console.log("Waiting for call");
        })
        .then(() => {
            console.log("added stream:")
            console.log(localStream)
            peerConnection.addStream(localStream)
        })
        .catch(error)
}

// function gotStream(stream) {
//    console.log("Received local stream");
//    localVideo.src = URL.createObjectURL(stream);
//    localStream = stream;
//    setupPeerConnection();
// }

// function setupPeerConnection() { 
//   callButton.disabled = false;
//   hangupButton.disabled = false;
//   console.log("Waiting for call");

//   let servers = {
//     "iceServers": [{
//       "url": "stun:stun.example.org"
//     }]
//   };

//   peerConnection = new RTCPeerConnection(servers);
//   console.log("Created local peer connection");
//   peerConnection.onicecandidate = gotLocalIceCandidate;
//   peerConnection.onaddstream = gotRemoteStream;
//   peerConnection.addStream(localStream);
//   console.log("Added localStream to localPeerConnection");
// }

var offerOptions = {
    offerToReceiveAudio: 0,
    offerToReceiveVideo: 1
};

function call() {
    callButton.disabled = true;
    console.log("Starting call");
    // peerConnection.createOffer(gotLocalDescription, handleError);
    console.log(peerConnection);
    const getOffer = () => peerConnection.createOffer(offerOptions)
        .then(offer => peerConnection.setLocalDescription(offer))
        .then(() => { channel.push("message", { body: JSON.stringify(
            { "sdp": peerConnection.localDescription }    
        )})
                    console.log("Offer from localPeerConnection: \n" + description.sdp);
        })
        .catch(error)
    getOffer();
}

function gotLocalDescription(description){
  peerConnection.setLocalDescription(description, () => {
      channel.push("message", { body: JSON.stringify({
              "sdp": peerConnection.localDescription
          })});
      }, handleError);
  console.log("Offer from localPeerConnection: \n" + description.sdp);
}

function gotRemoteDescription(description){
  console.log("Answer from remotePeerConnection: \n" + description.sdp);
  peerConnection.setRemoteDescription(new RTCSessionDescription(description.sdp))
    .then(() => peerConnection.createAnswer())
    .then(gotLocalDescription)
    .catch(error);
//   peerConnection.createAnswer(gotLocalDescription, handleError);
}

function gotRemoteStream(event) {
  remoteVideo.src = URL.createObjectURL(event.stream);
  console.log("Received remote stream");
}

// function gotLocalIceCandidate(event) {
//   if (event.candidate) {
//     console.log("Local ICE candidate: \n" + event.candidate.candidate);
//     channel.push("message", {body: JSON.stringify({
//         "candidate": event.candidate
//     })});
//   }
// }

function gotRemoteIceCandidate(event) {
  callButton.disabled = true;
  if (event.candidate) {
    peerConnection.addIceCandidate(new RTCIceCandidate(event.candidate));
    console.log("Remote ICE candidate: \n " + event.candidate.candidate);
  }
}

channel.on("message", payload => {
  let message = JSON.parse(payload.body);
  if (message.sdp) {
    gotRemoteDescription(message);
  } else {
    gotRemoteIceCandidate(message);
  }
})

function hangup() {
  console.log("Ending call");
  peerConnection.close();
  localVideo.src = null;
  peerConnection = null;
  hangupButton.disabled = true;
  connectButton.disabled = false;
  callButton.disabled = true;
}

function handleError(error) {
  console.log(error.name + ": " + error.message);
}