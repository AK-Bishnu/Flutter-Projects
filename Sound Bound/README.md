# SoundBound 🔊✨

Welcome to **SoundBound**, a real-time audio synchronization offline app built using **Flutter**. This project allows multiple devices to connect and play audio in perfect sync, creating a shared listening experience—ideal for parties, group sessions, or multi-device setups.

## Demo 🎥
Watch **SoundBound** in action:  
[![Watch the demo](https://img.youtube.com/vi/tpzm9dDhOMI/0.jpg)](https://youtu.be/tpzm9dDhOMI?si=RaJtJkrdkdoIiSGF)  

Or click here to watch: [https://youtu.be/tpzm9dDhOMI](https://youtu.be/tpzm9dDhOMI?si=RaJtJkrdkdoIiSGF)

## Features 🚀
- **Synchronized Audio Playback**: Play audio across multiple devices in real-time with minimal delay.
- **Host-Controlled System**: One device acts as the host, controlling playback, timing, and effects.
- **Party Mode 🎉**: Includes dynamic flash effects and visual feedback synced with audio for an immersive environment.
- **Wireless Connection**: Devices connect easily via Wi-Fi hotspot—no internet required.
- **Real-Time Communication**: Built using socket-based communication for fast and efficient data transfer.
- **Multi-Device Support**: Seamlessly connect and manage multiple client devices.

## Tech Stack 🛠️
- **Flutter**
- **Socket Programming (TCP)**

## How It Works ⚙️
- The **host device** creates a session and acts as the central controller.
- Other devices (**clients**) connect via Wi-Fi hotspot.
- Commands like play, pause, and sync signals are sent through sockets.
- All devices respond instantly to maintain synchronized playback.

## Screenshots 📸
Here are some in-app screenshots:

<div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
  <img src="https://github.com/user-attachments/assets/8f8b555a-6dbc-4140-9ab7-66f006555337" width="180" height="300" style="margin-right: 20px;">
  <img src="https://github.com/user-attachments/assets/98a75c2c-44e3-4f75-8d34-8854aa11170a" width="180" height="300" style="margin-right: 20px;">
  <img src="https://github.com/user-attachments/assets/27c63f20-c5bb-438a-a2a0-77d7bcb033e5" width="180" height="300" style="margin-right: 20px;">
  <img src="https://github.com/user-attachments/assets/9506da49-183d-427c-b5dc-1b6e672629eb" width="180" height="300" style="margin-right: 20px;">
  <img src="https://github.com/user-attachments/assets/014a04e9-50f5-4630-84aa-48160a336b34" width="180" height="300">
</div>

## Project Highlights 💡
- Designed a **low-latency sync mechanism** for consistent playback across devices  
- Implemented **custom socket communication protocol**  
- Built a **real-time host-client architecture** without external backend  
- Focused on **performance, timing accuracy, and smooth user experience**  

## Future Improvements 🔮
- Music streaming integration from anywhere, not only locally
- UI/UX enhancements and theme customization  

---

Feel free to explore and give feedback! ⭐
