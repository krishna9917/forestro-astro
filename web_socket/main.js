import express from "express";
import cors from "cors";
import { createServer } from "http";
import { Server } from "socket.io";
import path from "path";
import { fileURLToPath } from "url";
import { jsonToFormData, request } from "./apiRequest.js";
import admin from "firebase-admin";
import fs from "fs";
import url from "url";
const __filename2 = fileURLToPath(import.meta.url);
const __dirname2 = path.dirname(__filename2);
const firebasePath = path.join(__dirname2, "astro-99c72-firebase-adminsdk-1yat4-f729d71c73.json");
const firebase = JSON.parse(fs.readFileSync(firebasePath, { encoding: "utf-8" }));
const app = express();
const ts = () => new Date().toISOString();
const log = (scope, obj = {}) => {
  try {
    console.log(`[${ts()}] ${scope}`, typeof obj === 'string' ? obj : JSON.stringify(obj));
  } catch (_) {
    console.log(`[${ts()}] ${scope}`);
  }
};
const PORT = 4000;
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
admin.initializeApp({
  credential: admin.credential.cert(firebase),
});
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function calculateDuration(startTime) {
  // Get the current time in milliseconds since the Unix epoch
  const currentTime = Date.now();

  // Calculate the duration in milliseconds
  const durationMs = currentTime - startTime;

  // Convert milliseconds to seconds, minutes, and hours
  const durationSeconds = Math.floor((durationMs / 1000) % 60);
  const durationMinutes = Math.floor((durationMs / (1000 * 60)) % 60);
  const durationHours = Math.floor((durationMs / (1000 * 60 * 60)) % 24);

  return {
    milliseconds: durationMs,
    seconds: durationSeconds,
    minutes: durationMinutes,
    hours: durationHours,
  };
}

app.get("/", (_, res) => {
  log('http.root', { cwd: __dirname });
  res.sendFile(path.join(__dirname, "doc.html"));
});

app.post("/notify", async (req, res) => {
  try {
    const body = req.body;
    if (!body) {
      return res.status(500).send({
        status: false,
        res: "Enter body of Message",
      });
    }
    const resPonse = await admin.messaging().send(body);
    log('http.notify.sent', { to: body?.token, title: body?.notification?.title });
    res.send({
      status: true,
      res: resPonse,
    });
  } catch (error) {
    log('http.notify.error', { error: error?.toString?.() || String(error) });

    res.status(500).send({
      status: false,
      res: error.toString(),
    });
  }
});

const http = createServer(app);
const socketIO = new Server(http, {
  cors: {
    origin: "*",
  },
});
app.use(cors());

/**
 * @type {Map<string, SocketData>}
 */
const socketUserMap = new Map();

/**
 * @typedef {Object} SocketData
 * @property {string } id
 * @property {string} type
 * @property {any} [otherProps]
 */

/**
 * @param {string} userId
 * @param {string} type
 * @returns {{socketId: string, id: string, type: string,token:string, [key: string]: any} | null}
 */
function getSocketIdByUserId(userId, type) {
  for (const [socketId, data] of socketUserMap) {
    if (data.id === userId && data.type === type) {
      return { socketId, ...data };
    }
  }
  return null;
}

/**
 * @typedef {Object} LiveData
 * @property {string } liveId
 * @property {string } id
 * @property {string } charges
 * @property {number} startTime
 * @property {any} [otherProps]
 */

/**
 * @type {Map<string, LiveData>}
 */
const socketLiveAstroMap = new Map();

/**
 * @param {string} userId
 * @param {string} type
 * @returns {{socketId: string,liveId:string, id: string,time:number, [key: string]: any} | null}
 */

function getSocketLiveUserId(userId, type) {
  for (const [socketId, data] of socketUserMap) {
    if (data.id === userId && data.type === type) {
      return { socketId, ...data };
    }
  }
  return null;
}

socketIO.on("connection", (socket) => {
  log('socket.connection', { socketId: socket.id, headers: socket.handshake.headers });
  socket.on("disconnect", async () => {
    log('socket.disconnect', { socketId: socket.id });
    const astroData = socketUserMap.get(socket.id);

    if (astroData && astroData.type == "astro") {
      onLiveEnd();
      try {
        await request({
          method: "POST",
          url: "/mark-online-or-offline",
          data: jsonToFormData({ status: "offline", astro_id: astroData.id }),
          token: astroData.token,
        });
      } catch (error) {
        console.log(error.response.data);
      }
    }

    socketUserMap.delete(socket.id);
  });

  const userId = socket.handshake.headers.userid;
  const type = socket.handshake.headers.type;
  const token = socket.handshake.headers.token;

  if (!userId || !type || !token) {
    log('auth.missing', { userId, type, token });
    socketIO
      .to(socket.id)
      .emit(
        "error",
        " - connection - => (userId, type, token) All Fides Are Required for Connect"
      );
    socket.disconnect();
    return false;
  }

  socketUserMap.set(socket.id, {
    id: userId,
    type: type,
    token: token,
  });
  log('auth.registered', { socketId: socket.id, id: userId, type });

  socketIO.to(socket.id).emit("connected", {
    id: userId,
    type: type,
    token: token,
    message: "You Are Connected Successfully",
  });

  // bradCastSteam
  const broadcastStream = (current = false) => {
    let feeds = [];
    socketLiveAstroMap.forEach((v) => feeds.push(v));
    if (current) {
      socketIO.to(socket.id).emit("liveFeeds", feeds);
    } else {
      socket.broadcast.emit("liveFeeds", feeds);
    }
  };

  // emit Live Data on User Connect
  broadcastStream(true);

  // for Send New Chat/Audio/Video Request
  socket.on("newRequest", ({ userId, userType, requestType, data }) => {
    log('newRequest.recv', { to: userId, userType, requestType });
    if (!userId || !userType || !requestType || !data) {
      socketIO
        .to(socket.id)
        .emit(
          "error",
          " - newRequest - => (userId, userType, requestType, data) All Fides Are Required"
        );
      return false;
    }
    const userData = getSocketIdByUserId(userId, userType);
    if (userData == null) {
      log('newRequest.offline', { userId, userType });
      socketIO
        .to(socket.id)
        .emit("error", " - newRequest - => User Is Offline ");
      return false;
    }
    const astro = socketUserMap.get(socket.id);
    log('newRequest.deliver', { toSocket: userData.socketId });
    socketIO.to(userData.socketId).emit("request", {
      userId: astro.id,
      userType: astro.type,
      requestType,
      data,
      message: `New  ${type} Request Send`,
    });
  });

  // on accepted request
  socket.on("accept", async ({ userId, userType, requestType, data }) => {
    log('accept.recv', { userId, userType, requestType });
    if (!userId || !userType || !requestType || !data) {
      socketIO
        .to(socket.id)
        .emit(
          "error",
          " - accept - => (userId, userType, requestType, data:{communication_id,status}) All Fides Are Required"
        );
      return false;
    }
    const userData = getSocketIdByUserId(userId, userType);
    if (userData == null) {
      log('accept.offline', { userId, userType });
      socketIO.to(socket.id).emit("userOffline", {
        userId,
        userType,
        requestType,
        data,
        message: `User is offline Now`,
        stack: "startChatRequest",
      });
      return false;
    }
    const astro = socketUserMap.get(socket.id);
    log('accept.deliver', { toSocket: userData.socketId });
    socketIO.to(userData.socketId).emit("accepted", {
      userId: astro.id,
      userType: astro.type,
      requestType,
      data,
      message: `Request ${type} Accepted User`,
    });
    socketIO.to(socket.id).emit("wetting", {
      userId,
      userType,
      requestType,
      data,
      message: `Waiting for ${type} Accepted User`,
    });
  });

  // on Decline request
  socket.on("decline", ({ userId, userType, requestType, data }) => {
    log('decline.recv', { userId, userType, requestType });
    const userData = getSocketIdByUserId(userId, userType);
    if (userData == null) {
      log('decline.offline', { userId, userType });
      socketIO.to(socket.id).emit("userOffline", {
        userId,
        userType,
        requestType,
        data,
        message: `User is offline Now`,
        stack: "startChatRequest",
      });
      return false;
    }
    socketIO
      .to(userData.socketId)
      .to(socket.id)
      .emit("wettingDecline", {
        userId,
        userType,
        requestType,
        data,
        message: `Waiting Decline for ${type} Accepted User`,
      });
  });

  // on accepted request
  socket.on("startSession", async ({ userId, userType, requestType, data }) => {
    log('startSession.recv', { userId, userType, requestType });
    if (!userId || !userType || !requestType || !data) {
      socketIO
        .to(socket.id)
        .emit(
          "error",
          " - startSession - => (userId, userType, requestType, data) All Fides Are Required"
        );
      return false;
    }
    const userData = getSocketIdByUserId(userId, userType);
    if (userData == null) {
      log('startSession.offline', { userId, userType });
      socketIO.to(socket.id).emit("userOffline", {
        userId,
        userType,
        requestType,
        data,
        message: `User is offline Now`,
        stack: "startSession",
      });
      return false;
    }

    const astro = socketUserMap.get(socket.id);
    log('startSession.deliver', { toSocket: userData.socketId });
    socketIO.to(userData.socketId).emit("openSession", {
      userId: astro.id,
      userType: astro.type,
      requestType,
      data: data.data,
      message: `Start  ${type} With User`,
    });
    socketIO.to(socket.id).emit("openSession", {
      userId,
      userType,
      requestType,
      data: data.data,
      message: `Start  ${type} Chat With User`,
    });
  });

  // on reject request
  socket.on("reject", async ({ userId, userType, requestType, data }) => {
    log('reject.recv', { userId, userType, requestType });
    if (!userId || !userType || !requestType || !data) {
      socketIO
        .to(socket.id)
        .emit(
          "error",
          " - reject - => (userId, userType, requestType, data:{communication_id,status}) All Fides Are Required"
        );
      return false;
    }
    const userData = getSocketIdByUserId(userId, userType);

    try {
      const token = socketUserMap.get(socket.id).token;
      const res = await request({
        method: "POST",
        url: "/update-communication-status",
        data: jsonToFormData({
          communication_id: data.id,
          status: data.status,
        }),
        token,
      });
      console.log(res.data);
    } catch (error) {
      console.log(error?.response?.data);
      socketIO.to(socket.id).emit("apiError", error?.response?.data || null);
    }
    if (userData == null) {
      socketIO.to(socket.id).emit("error", " - reject - => User Is Offline ");
      return false;
    }
    const astro = socketUserMap.get(socket.id);
    socketIO.to(userData.socketId).emit("rejected", {
      userId: astro.id,
      userType: astro.type,
      requestType,
      data,
      message: `Request ${type} Rejected User`,
    });
  });

  // for Send Use id userBusy Request
  socket.on("userBusy", ({ userId, userType, message }) => {
    log('userBusy.recv', { userId, userType, message });
    if (!userId || !userType || !message) {
      socketIO
        .to(socket.id)
        .emit(
          "error",
          " - userBusy - => (userId, userType, message) All Fides Are Required"
        );
      return false;
    }
    const userData = getSocketIdByUserId(userId, userType);
    if (userData == null) {
      socketIO.to(socket.id).emit("error", " - userBusy - => User Is Offline ");
      return false;
    }
    socketIO.to(userData.socketId).emit("busy", { message });
  });

  // for Close User id Close Request
  socket.on(
    "endSession",
    ({ userId, userType, requestType, message, data }) => {
      log('endSession.recv', { userId, userType, requestType, message });
      if (!userId || !userType || !message || !requestType || !data) {
        socketIO
          .to(socket.id)
          .emit(
            "error",
            " - endSession - => (userId, userType, message,requestType,data) All Fides Are Required"
          );
        return false;
      }
      const userData = getSocketIdByUserId(userId, userType);
      if (userData == null) {
        socketIO
          .to(socket.id)
          .emit("error", " - endSession - => User Is Offline ");
      } else {
        socketIO.to(userData.socketId).emit("closeSession", {
          userId,
          userType,
          requestType,
          message,
          data,
        });
      }
      socketIO
        .to(socket.id)
        .emit("closeSession", { userId, userType, requestType, message, data });
    }
  );

  // Conference: Invite a user by mobile number to current callID
  socket.on('conferenceInvite', async ({ targetMobile, requestType, callID, data }) => {
    log('conferenceInvite.recv', { targetMobile, requestType, callID });
    try {
      if (!targetMobile || !callID) {
        socketIO.to(socket.id).emit('error', ' - conferenceInvite - => (targetMobile, callID) required');
        return;
      }
      // Lookup userId by mobile via API
      const astroData = socketUserMap.get(socket.id);
      const res = await request({
        method: 'POST',
        url: '/lookup-user-by-mobile',
        data: jsonToFormData({ mobile: targetMobile }),
        token: astroData.token,
      });
      log('conferenceInvite.lookup', res?.data);
      const targetUserId = res?.data?.user_id?.toString();
      const targetFcm = res?.data?.notifaction_token || null;
      if (!targetUserId) {
        socketIO.to(socket.id).emit('error', 'User not found for mobile');
        return;
      }
      const userData = getSocketIdByUserId(targetUserId, 'user');
      log('conferenceInvite.userData', userData);
      if (!userData) {
        // User offline: send FCM push as fallback
        if (targetFcm) {
          try {
            await admin.messaging().send({
              token: targetFcm,
              notification: {
                title: 'Conference invite',
                body: 'Join call with astrologer',
              },
              data: {
                type: 'conferenceInvite',
                requestType: requestType || 'video',
                callID: String(callID),
              },
            });
            socketIO.to(socket.id).emit('userOffline', { message: 'User is offline, push sent' });
          } catch (pushErr) {
            socketIO.to(socket.id).emit('userOffline', { message: 'User offline, push failed' });
          }
        } else {
          socketIO.to(socket.id).emit('userOffline', { message: 'User is offline' });
        }
        return;
      }
      log('conferenceInvite.deliver', { toSocket: userData.socketId });
      socketIO.to(userData.socketId).emit('conferenceInvite', {
        userId: socketUserMap.get(socket.id).id,
        requestType: requestType || 'video',
        callID,
        data,
      });
    } catch (error) {
      socketIO.to(socket.id).emit('apiError', error?.response?.data || error.toString());
    }
  });

  socket.on('conferenceAccept', ({ callID, requestType }) => {
    // Broadcast nothing special; the joining client will use callID to join Zego room
    socketIO.to(socket.id).emit('conferenceAccepted', { callID, requestType });
  });

  socket.on('conferenceDecline', ({ callID, requestType }) => {
    socketIO.to(socket.id).emit('conferenceDeclined', { callID, requestType });
  });

  //for go live session
  socket.on(
    "startLiveSession",
    ({ userId, liveId, name, profile, data, charges }) => {
      socketLiveAstroMap.set(socket.id, {
        id: userId,
        liveId: liveId,
        startTime: Date.now(),
        name: name,
        charges: charges,
        profile: profile,
        data: data,
      });
      broadcastStream();
    }
  );

  // for end Live Session
  socket.on("endLiveSession", () => {
    onLiveEnd();
  });

  // on user Join
  socket.on("joinLiveSession", ({ liveId }) => {
    socket.join(liveId);
  });

  // on user Leave
  socket.on("leaveLiveSession", ({ liveId }) => {
    socket.leave(liveId);
  });

  // for end Live Session
  socket.on("reloadLiveFeed", () => {
    broadcastStream(true);
  });

  // function on Live End
  const onLiveEnd = async () => {
    const session = socketLiveAstroMap.get(socket.id);
    if (session) {
      try {
        const astroData = socketUserMap.get(socket.id);
        const { seconds } = calculateDuration(session.startTime);
        const response = await request({
          method: "POST",
          url: "/astrologer-live-charges",
          data: jsonToFormData({
            astro_id: session.id.toString(),
            time: seconds.toString(),
            amount: (seconds * session.charges).toString(),
            live_id: session.liveId.toString(),
            astrologer_live_charges_per_min: (session.charges * 60).toString(),
          }),
          token: astroData.token,
        });
        socket.to(session.liveId).emit("finishedLiveSession", session);
        socketIO.console.log(response.data);
        socketIO.to(socket.id).emit("closedLiveSession", response.data);
        socketLiveAstroMap.delete(socket.id);
        broadcastStream();
      } catch (error) {
        console.log(error?.response?.data);
        socketIO
          .to(socket.id)
          .emit("apiError", error?.response?.data || error.toString());
      }
    }
  };
});

http.listen(PORT, () => {
  log('server.listening', { port: PORT });
});
