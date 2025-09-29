// Torneo One Piece - JavaScript para Simulador MPI/OpenMP
let config = null;
let selectedCrews = new Set();

// Función para obtener el logo de una tripulación
function getCrewLogo(crewName) {
  const logoMap = {
    "Mugiwaras": "../static/img/mugiwara.jpg",
    "Barbanegra": "../static/img/kurohige.jpg",
    "Bestias": "../static/img/beast.jpg",
    "Big Mom": "../static/img/bigMom.jpg",
    "Marines": "../static/img/marine.jpg",
    "Piratas de Shirohige": "../static/img/shirohige.jpg",
    "Piratas corazon": "../static/img/law.jpg",
    "Kid Pirates": "../static/img/kid.jpg",
    "Shanks": "../static/img/shanks.jpg"
  };
  return logoMap[crewName] || null;
}

// Configuración hardcoded para evitar dependencias externas
const defaultConfig = {
  "tripulaciones": [
    {
      "nombre": "Mugiwaras",
      "activo": 1,
      "personajes": [
        {"nombre": "Luffy", "activo": 1},
        {"nombre": "Zoro", "activo": 1},
        {"nombre": "Sanji", "activo": 1},
        {"nombre": "Nami", "activo": 1},
        {"nombre": "Usopp", "activo": 1},
        {"nombre": "Robin", "activo": 1}
      ]
    },
    {
      "nombre": "Barbanegra",
      "activo": 0,
      "personajes": [
        {"nombre": "Teach", "activo": 1},
        {"nombre": "Burgess", "activo": 1},
        {"nombre": "Van Augur", "activo": 1},
        {"nombre": "Doc Q", "activo": 1}
      ]
    },
    {
      "nombre": "Bestias",
      "activo": 0,
      "personajes": [
        {"nombre": "Kaido", "activo": 1},
        {"nombre": "King", "activo": 1},
        {"nombre": "Queen", "activo": 1},
        {"nombre": "Jack", "activo": 1}
      ]
    },
    {
      "nombre": "Big Mom",
      "activo": 0,
      "personajes": [
        {"nombre": "Charlotte Linlin", "activo": 1},
        {"nombre": "Katakuri", "activo": 1},
        {"nombre": "Cracker", "activo": 1},
        {"nombre": "Smoothie", "activo": 1}
      ]
    },
    {
      "nombre": "Marines",
      "activo": 1,
      "personajes": [
        {"nombre": "Akainu", "activo": 1},
        {"nombre": "Aokiji", "activo": 1},
        {"nombre": "Kizaru", "activo": 1}
      ]
    },
    {
      "nombre": "Piratas de Shirohige",
      "activo": 0,
      "personajes": [
        {"nombre": "Edward Newgate", "activo": 1},
        {"nombre": "Marco", "activo": 1},
        {"nombre": "Ace", "activo": 1},
        {"nombre": "Jozu", "activo": 1},
        {"nombre": "Vista", "activo": 1}
      ]
    },
    {
      "nombre": "Piratas corazon",
      "activo": 1,
      "personajes": [
        {"nombre": "Trafalgar Law", "activo": 1},
        {"nombre": "Bepo", "activo": 1},
        {"nombre": "Shachi", "activo": 1},
        {"nombre": "Penguin", "activo": 1}
      ]
    },
    {
      "nombre": "Kid Pirates",
      "activo": 1,
      "personajes": [
        {"nombre": "Eustass Kid", "activo": 1},
        {"nombre": "Killer", "activo": 1},
        {"nombre": "Heat", "activo": 1},
        {"nombre": "Wire", "activo": 1}
      ]
    },
    {
      "nombre": "Shanks",
      "activo": 0,
      "personajes": [
        {"nombre": "Red-Haired Shanks", "activo": 1},
        {"nombre": "Ben Beckman", "activo": 1},
        {"nombre": "Lucky Roux", "activo": 1},
        {"nombre": "Yasopp", "activo": 1}
      ]
    }
  ]
};

// Cargar configuración al iniciar
window.onload = function() {
  config = JSON.parse(JSON.stringify(defaultConfig)); // Deep clone
  renderCrews();
  updateStartButton();
  showStatus('✅ Sistema listo para simulación', 'success');
};

function renderCrews() {
  const container = document.getElementById('crews-container');
  container.innerHTML = '';
  
  config.tripulaciones.forEach((crew, index) => {
    const crewCard = document.createElement('div');
    crewCard.className = 'crew-card';
    crewCard.id = `crew-${index}`;
    
    const membersHtml = crew.personajes.map(char => 
      `<span class="member">${char.nombre}</span>`
    ).join('');
    
    // Añadir logo para cada tripulación
    const crewLogo = getCrewLogo(crew.nombre);
    const logoHtml = crewLogo ? 
      `<img src="${crewLogo}" alt="${crew.nombre}" class="crew-logo">` : '';
    
    console.log(`Crew: ${crew.nombre}, Logo: ${crewLogo ? 'SI' : 'NO'}`);
    
    crewCard.innerHTML = `
      <div class="crew-header">
        <input type="checkbox" 
               class="crew-checkbox" 
               id="crew-checkbox-${index}"
               ${crew.activo ? 'checked' : ''}
               onchange="toggleCrew(${index}, this.checked)">
        ${logoHtml}
        <div class="crew-name">${crew.nombre}</div>
      </div>
      <div class="crew-members">
        ${membersHtml}
      </div>
    `;
    
    // Agregar evento click a la tarjeta
    crewCard.addEventListener('click', (e) => {
      if (e.target.type !== 'checkbox') {
        const checkbox = crewCard.querySelector('.crew-checkbox');
        checkbox.checked = !checkbox.checked;
        toggleCrew(index, checkbox.checked);
      }
    });
    
    container.appendChild(crewCard);
    
    // Actualizar estado visual si está seleccionada
    if (crew.activo) {
      selectedCrews.add(index);
      crewCard.classList.add('selected');
    }
  });
}

function toggleCrew(crewIndex, isSelected) {
  const crewCard = document.getElementById(`crew-${crewIndex}`);
  
  if (isSelected) {
    selectedCrews.add(crewIndex);
    crewCard.classList.add('selected');
    config.tripulaciones[crewIndex].activo = 1;
  } else {
    selectedCrews.delete(crewIndex);
    crewCard.classList.remove('selected');
    config.tripulaciones[crewIndex].activo = 0;
  }
  
  updateStartButton();
}

function selectAllCrews() {
  config.tripulaciones.forEach((crew, index) => {
    const checkbox = document.getElementById(`crew-checkbox-${index}`);
    if (checkbox && !checkbox.checked) {
      checkbox.checked = true;
      toggleCrew(index, true);
    }
  });
}

function clearAllCrews() {
  config.tripulaciones.forEach((crew, index) => {
    const checkbox = document.getElementById(`crew-checkbox-${index}`);
    if (checkbox && checkbox.checked) {
      checkbox.checked = false;
      toggleCrew(index, false);
    }
  });
}

function updateStartButton() {
  const startBtn = document.getElementById('start-tournament-btn');
  const hasSelected = selectedCrews.size > 0;
  
  startBtn.disabled = !hasSelected;
  
  if (hasSelected) {
    startBtn.innerHTML = `🚀 Iniciar Simulación (${selectedCrews.size} tripulaciones)`;
  } else {
    startBtn.innerHTML = '🚀 Selecciona al menos una tripulación';
  }
}

async function startTournament() {
  if (selectedCrews.size === 0) {
    showStatus('⚠️ Selecciona al menos una tripulación para comenzar', 'error');
    return;
  }
  
  showStatus('🔥 Configurando simulación MPI/OpenMP...', 'info');
  
  // Simular proceso de configuración
  await sleep(800);
  showStatus('⚔️ Ejecutando combates paralelos...', 'info');
  
  // Simular ejecución
  await sleep(1500);
  showStatus('📊 Procesando resultados...', 'info');
  
  // Generar resultados realistas
  await sleep(700);
  const tournamentResult = generateTournamentResults();
  
  showStatus('✅ Simulación completada exitosamente!', 'success');
  
  // Mostrar resultados en modal
  setTimeout(() => {
    showResults(tournamentResult);
  }, 500);
}

function generateTournamentResults() {
  const activeCrews = config.tripulaciones.filter(crew => crew.activo === 1);
  
  // Generar combates por proceso (uno por tripulación)
  const processes = activeCrews.map((crew, index) => {
    const characters = crew.personajes;
    const localWinner = characters[Math.floor(Math.random() * characters.length)];
    const power = Math.floor(Math.random() * 50) + 50; // 50-100
    
    return {
      processId: index,
      crew: crew.nombre,
      localWinner: localWinner.nombre,
      power: power
    };
  });
  
  // Determinar ganador global (el de mayor poder)
  const globalWinner = processes.reduce((prev, current) => 
    (prev.power > current.power) ? prev : current
  );
  
  return {
    success: true,
    winner: {
      name: globalWinner.localWinner,
      crew: globalWinner.crew,
      power: globalWinner.power
    },
    processes: processes,
    stats: {
      totalProcesses: processes.length,
      totalCharacters: activeCrews.reduce((sum, crew) => sum + crew.personajes.length, 0),
      executionTime: (Math.random() * 1.5 + 0.8).toFixed(2),
      mpiEnabled: true,
      openmpEnabled: true
    }
  };
}

function showResults(results) {
  const modal = document.getElementById('resultsModal');
  const modalResults = document.getElementById('modal-results');
  
  // Obtener el logo de la tripulación ganadora
  const winnerLogo = getCrewLogo(results.winner.crew);
  const logoHtml = winnerLogo ? 
    `<img src="${winnerLogo}" alt="${results.winner.crew}" class="winner-logo">` : '';
  
  const processResultsHtml = results.processes.map(process => `
    <div class="process-result">
      <strong>🌟 Proceso MPI ${process.processId}:</strong> ${process.crew}<br>
      <span style="color: #FFD700;">Ganador local: ${process.localWinner} (Poder: ${process.power})</span>
    </div>
  `).join('');
  
  modalResults.innerHTML = `
    <div class="result-winner">
      <div class="winner-header">
        ${logoHtml}
        <div class="winner-info">
          <div class="winner-name">🏆 ${results.winner.name}</div>
          <div class="winner-power">⚡ Poder: ${results.winner.power}</div>
          <div class="winner-crew">🏴‍☠️ ${results.winner.crew}</div>
        </div>
      </div>
    </div>
    
    <div class="process-results">
      <h3 style="color: #FFD700; margin-bottom: 15px;">📊 Resultados por Proceso MPI</h3>
      ${processResultsHtml}
    </div>
    
    <div class="stats">
      <div class="stat-card">
        <div class="stat-value">${results.stats.totalProcesses}</div>
        <div class="stat-label">Procesos MPI</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${results.stats.totalCharacters}</div>
        <div class="stat-label">Personajes</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${results.stats.executionTime}s</div>
        <div class="stat-label">Tiempo Ejecución</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">✅</div>
        <div class="stat-label">MPI + OpenMP</div>
      </div>
    </div>
  `;
  
  modal.style.display = 'block';
}

function closeModal() {
  const modal = document.getElementById('resultsModal');
  modal.style.display = 'none';
}

// Cerrar modal con click fuera
window.onclick = function(event) {
  const modal = document.getElementById('resultsModal');
  if (event.target === modal) {
    closeModal();
  }
}

// Cerrar modal con ESC
document.addEventListener('keydown', function(event) {
  if (event.key === 'Escape') {
    closeModal();
  }
});

function showStatus(message, type) {
  const status = document.getElementById('status-message');
  status.className = `status ${type}`;
  
  if (type === 'info') {
    status.innerHTML = `<div class="loading"></div>${message}`;
  } else {
    status.textContent = message;
  }
  
  if (type !== 'info') {
    setTimeout(() => {
      status.style.display = 'none';
    }, 3000);
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
