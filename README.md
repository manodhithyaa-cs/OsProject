# 🧠 Virtual Personal Assistant (VPA) & Docker-Swarm Clustering Project

## 👨‍💻 Team Members
- **Manodhithyaa C S**
- **Shaalini S**
- **Visva P**

---

## 🚀 Project Overview
This repository combines two interconnected modules:

1. **Virtual Personal Assistant (VPA)** — a text-based AI assistant that automates basic user commands and interacts through a chat-style interface.
2. **Docker-Swarm Clustering Script** — a shell-based automation that creates a 3-node Docker Swarm cluster (1 Manager + 2 Workers) and deploys an Nginx service with multiple replicas.

Together, they demonstrate the integration of **AI-driven automation** with **distributed system deployment** using container orchestration.

---

## 🧩 Module 1: Docker-Swarm Clustering Project

### 📜 Description
The clustering script automates the process of setting up a Docker Swarm cluster locally using Docker-in-Docker (DinD).  
It configures a manager node and multiple worker nodes, then deploys a web service across them for load balancing and availability.

### ⚙️ Features
- Automatically creates a Docker bridge network (`swarm-net`)
- Initializes Swarm and generates worker join tokens
- Deploys an **Nginx** web service with configurable replicas
- Prints live logs and service status
- Can be run repeatedly (auto cleans old setup)

### 🧰 Tools & Technologies
- **Bash**
- **Docker Engine**
- **Docker Swarm**
- **Nginx**
- **Linux (WSL / Ubuntu)**

### 🏗️ How It Works
1. The script cleans up any old containers or networks.  
2. Creates a new bridge network `swarm-net`.  
3. Spins up one manager and two worker containers using Docker-in-Docker.  
4. Initializes the Swarm and joins workers using a token.  
5. Deploys an Nginx service with defined replicas (default: 3).  
6. Displays cluster status and live logs.

### 🧠 Architecture
```
┌──────────────┐
│   Manager    │  <── Docker Swarm init
│ (Nginx svc)  │
└──────┬───────┘
       │
 ┌─────┴─────┐
 │  Worker 1 │  <── Joins using token
 └───────────┘
 │  Worker 2 │  <── Joins using token
 └───────────┘
```

### 🧪 Run Instructions
```bash
chmod +x swarm-setup.sh
./swarm-setup.sh
```

Then open [http://localhost:8080](http://localhost:8080) in your browser to view the running Nginx service.

---

## 🤖 Module 2: Virtual Personal Assistant (VPA)

### 📜 Description
The VPA is a lightweight, **text-based AI assistant** designed to handle simple automation tasks, provide system information, and act as a foundation for personalized extensions.  
It simulates the behavior of digital assistants like Siri or Alexa — but operates entirely through **typed interaction**, without any speech recognition or voice output.

### 💡 Features
- Command-based chat interface  
- Task automation (open apps, check system info, reminders, etc.)  
- Extensible modular architecture  
- Can be integrated with APIs for weather, time, or chat responses

### 🧰 Tools & Technologies
- **Python 3**
- **Flask / FastAPI (optional for web UI)**
- **SQLite (for user data)**

### 🏗️ System Design
```
User Input → Command Parser → Task Executor → Response Generator → Output Display
```

### ⚙️ Example Commands
- `time` → shows current time  
- `open youtube` → opens YouTube in default browser  
- `search AI` → performs a Google search  
- `note buy groceries` → saves a reminder note

---

## 🧩 Integration & Vision
Both modules highlight **automation and scalability** — the VPA serves as a front-end intelligent system, while the Docker Swarm module provides a scalable back-end environment for deployment and clustering.

---

## 📈 Future Enhancements
- Add container monitoring using Prometheus + Grafana  
- Integrate VPA with APIs (ChatGPT, Weather, News)  
- Deploy both modules on cloud (AWS / Azure / GCP)

---

## 🏁 Conclusion
This project demonstrates a blend of **AI automation** and **DevOps orchestration**, showcasing practical applications of containerization, clustering, and intelligent assistants for modern computing environments.
